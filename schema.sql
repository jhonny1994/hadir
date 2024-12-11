-- Enable necessary extensions
create extension if not exists "uuid-ossp";

-- Set up storage for profile pictures (optional)
insert into storage.buckets (id, name) values ('avatars', 'avatars');
create policy "Avatar images are publicly accessible." on storage.objects
  for select using (bucket_id = 'avatars');
create policy "Anyone can upload an avatar." on storage.objects
  for insert using (bucket_id = 'avatars');

-- 1. Profiles table (extends auth.users)
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text not null,
  student_id text unique,  -- null for professors
  user_type text not null check (user_type in ('professor', 'student')),
  avatar_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Courses table
create table public.courses (
  id uuid default uuid_generate_v4() primary key,
  name text not null,
  professor_id uuid references public.profiles not null,
  join_code text unique not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 3. Course enrollments table
create table public.course_enrollments (
  course_id uuid references public.courses on delete cascade,
  student_id uuid references public.profiles on delete cascade,
  status text not null check (status in ('pending', 'approved', 'rejected')),
  enrolled_at timestamp with time zone default timezone('utc'::text, now()) not null,
  primary key (course_id, student_id)
);

-- 4. Schedules table
create table public.schedules (
  id uuid default uuid_generate_v4() primary key,
  course_id uuid references public.courses on delete cascade,
  day_of_week integer not null check (day_of_week between 0 and 6),
  start_time time not null,
  end_time time not null check (end_time > start_time),
  attendance_window integer not null default 15,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 5. Attendance sessions table
create table public.attendance_sessions (
  id uuid default uuid_generate_v4() primary key,
  course_id uuid references public.courses on delete cascade,
  schedule_id uuid references public.schedules on delete cascade,
  qr_code text not null,
  backup_code text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  expires_at timestamp with time zone not null,
  is_active boolean default true
);

-- 6. Attendance records table
create table public.attendance_records (
  session_id uuid references public.attendance_sessions on delete cascade,
  student_id uuid references public.profiles on delete cascade,
  marked_at timestamp with time zone default timezone('utc'::text, now()) not null,
  status text not null check (status in ('present', 'absent', 'excused')),
  excuse_note text,
  excused_at timestamp with time zone,
  primary key (session_id, student_id)
);

-- Now add RLS policies after all tables are created

-- Profiles policies
alter table public.profiles enable row level security;
create policy "Public profiles are viewable by everyone." on public.profiles
  for select using (true);
create policy "Users can insert their own profile." on public.profiles
  for insert with check (auth.uid() = id);
create policy "Users can update own profile." on public.profiles
  for update using (auth.uid() = id);

-- Courses policies
alter table public.courses enable row level security;
create policy "Professors can create courses" on public.courses
  for insert with check (
    auth.uid() = professor_id and 
    exists (select 1 from public.profiles where id = auth.uid() and user_type = 'professor')
  );
create policy "Professors can update their courses" on public.courses
  for update using (
    auth.uid() = professor_id
  );
create policy "Courses are viewable by enrolled students and professors" on public.courses
  for select using (
    auth.uid() = professor_id or
    exists (
      select 1 from public.course_enrollments 
      where course_id = id and student_id = auth.uid() and status = 'approved'
    )
  );

-- Course enrollments policies
alter table public.course_enrollments enable row level security;
create policy "Students can request enrollment" on public.course_enrollments
  for insert with check (
    auth.uid() = student_id and
    exists (select 1 from public.profiles where id = auth.uid() and user_type = 'student')
  );
create policy "Professors can manage enrollments" on public.course_enrollments
  for update using (
    exists (
      select 1 from public.courses 
      where id = course_id and professor_id = auth.uid()
    )
  );
create policy "Enrollments are viewable by relevant users" on public.course_enrollments
  for select using (
    auth.uid() = student_id or
    exists (
      select 1 from public.courses 
      where id = course_id and professor_id = auth.uid()
    )
  );

-- Schedules policies
alter table public.schedules enable row level security;
create policy "Professors can manage schedules" on public.schedules
  for all using (
    exists (
      select 1 from public.courses 
      where id = course_id and professor_id = auth.uid()
    )
  );
create policy "Students can view schedules" on public.schedules
  for select using (
    exists (
      select 1 from public.course_enrollments 
      where course_id = course_id and student_id = auth.uid() and status = 'approved'
    )
  );

-- Attendance sessions policies
alter table public.attendance_sessions enable row level security;
create policy "Professors can manage sessions" on public.attendance_sessions
  for all using (
    exists (
      select 1 from public.courses 
      where id = course_id and professor_id = auth.uid()
    )
  );
create policy "Students can view active sessions" on public.attendance_sessions
  for select using (
    exists (
      select 1 from public.course_enrollments 
      where course_id = course_id and student_id = auth.uid() and status = 'approved'
    ) and is_active = true
  );

-- Attendance records policies
alter table public.attendance_records enable row level security;
create policy "Students can mark their attendance" on public.attendance_records
  for insert with check (
    auth.uid() = student_id and
    exists (
      select 1 from public.attendance_sessions s
      join public.course_enrollments e on e.course_id = s.course_id
      where s.id = session_id 
      and e.student_id = auth.uid() 
      and e.status = 'approved'
      and s.is_active = true
    )
  );
create policy "Professors can manage attendance" on public.attendance_records
  for all using (
    exists (
      select 1 from public.attendance_sessions s
      join public.courses c on c.id = s.course_id
      where s.id = session_id and c.professor_id = auth.uid()
    )
  );
create policy "Students can view their attendance" on public.attendance_records
  for select using (
    auth.uid() = student_id
  );

-- Add indexes after all tables and policies are created
create index idx_profiles_user_type on profiles(user_type);
create index idx_courses_professor_id on courses(professor_id);
create index idx_courses_join_code on courses(join_code);
create index idx_course_enrollments_course_id on course_enrollments(course_id);
create index idx_course_enrollments_student_id on course_enrollments(student_id);
create index idx_course_enrollments_status on course_enrollments(status);
create index idx_schedules_course_id on schedules(course_id);
create index idx_attendance_sessions_course_id on attendance_sessions(course_id);
create index idx_attendance_sessions_schedule_id on attendance_sessions(schedule_id);
create index idx_attendance_sessions_is_active on attendance_sessions(is_active);
create index idx_attendance_records_session_id on attendance_records(session_id);
create index idx_attendance_records_student_id on attendance_records(student_id);
create index idx_attendance_records_status on attendance_records(status);

-- Functions
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, user_type, student_id)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'user_type',
    new.raw_user_meta_data->>'student_id'
  );
  return new;
end;
$$ language plpgsql security definer;

-- Trigger for new user creation
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();