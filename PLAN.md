# Hadir - Attendance Management System Plan

## Project Overview

Hadir is a Flutter-based attendance management system with a desktop application for professors and a mobile application for students. The system uses Supabase as the backend and follows a lite Domain-Driven Design architecture.

## Project Structure

```
hadir/
├── melos.yaml
├── packages/
│   ├── hadir_core/          # Shared core functionality
│   │   ├── lib/
│   │   │   ├── domain/         
│   │   │   ├── infrastructure/
│   │   │   └── application/
│   │
│   ├── hadir_ui_desktop/    # Desktop-specific UI (Fluent UI)
│   │   ├── lib/
│   │   │   ├── theme/
│   │   │   │   ├── app_theme.dart
│   │   │   │   ├── colors.dart
│   │   │   │   └── typography.dart
│   │   │   └── widgets/
│   │   │       ├── buttons/
│   │   │       ├── cards/
│   │   │       └── inputs/
│   │
│   ├── hadir_ui_mobile/     # Mobile-specific UI (Material UI)
│   │   ├── lib/
│   │   │   ├── theme/
│   │   │   │   ├── app_theme.dart
│   │   │   │   ├── colors.dart
│   │   │   │   └── typography.dart
│   │   │   └── widgets/
│   │   │       ├── buttons/
│   │   │       ├── cards/
│   │   │       └── inputs/
│   │
├── apps/
    ├── desktop/                # Professor's desktop app
    │   └── lib/
    │       ├── features/
    │       │   ├── auth/
    │       │   ├── dashboard/
    │       │   ├── course_management/
    │       │   └── attendance/
    │
    └── mobile/                 # Student's mobile app
        └── lib/
            ├── features/
                ├── auth/
                ├── courses/
                └── attendance/
```

## Core Features Breakdown

### Domain Models (hadir_core)

#### Entities

```dart
// User Entity
class User extends Entity {
  final String id;
  final String fullName;
  final String email;
  final UserType userType;
  final String? studentId; // Only for students
}

// Course Entity
class Course extends Entity {
  final String id;
  final String name;
  final String professorId;
  final String courseCode;
  final List<Schedule> schedules;
}

// Schedule Entity
class Schedule extends Entity {
  final String id;
  final String courseId;
  final int dayOfWeek;
  final DateTime startTime;
  final DateTime endTime;
  final int attendanceWindow;   // Minutes allowed for marking attendance
}

// Attendance Session Entity
class AttendanceSession extends Entity {
  final String id;
  final String courseId;
  final String scheduleId;
  final String qrCode;
  final DateTime createdAt;
  final DateTime expiresAt; // typically 5-15 minutes from creation
  final bool isActive;  // Add this to easily check session status
}

// Attendance Record Entity
class AttendanceRecord extends Entity {
  final String sessionId;
  final String studentId;
  final DateTime markedAt;
  final AttendanceStatus status;
  final String? excuseNote;     // Optional excuse note
  final bool isExcused;         // Whether the absence is excused
  final DateTime? excusedAt;    // When the absence was excused
}

// Indexes for better performance
CREATE INDEX idx_course_enrollments_course_id ON course_enrollments(course_id);
CREATE INDEX idx_course_enrollments_student_id ON course_enrollments(student_id);
CREATE INDEX idx_attendance_records_session_id ON attendance_records(session_id);
CREATE INDEX idx_attendance_records_student_id ON attendance_records(student_id);
```

### Repository Interfaces

```dart
abstract class IAuthRepository {
  Future<Either<AuthFailure, User>> signIn(String email, String password);
  Future<Either<AuthFailure, Unit>> signOut();
  Future<Either<AuthFailure, User>> getCurrentUser();
  Future<Either<AuthFailure, User>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String? studentId,
    required UserType userType,
  });
}

abstract class ICourseRepository {
  Future<Either<CourseFailure, List<Course>>> getProfessorCourses();
  Future<Either<CourseFailure, List<Course>>> getStudentCourses();
  Future<Either<CourseFailure, Course>> createCourse(Course course);
  Future<Either<CourseFailure, Unit>> updateCourse(Course course);
  Future<Either<CourseFailure, Unit>> deleteCourse(String courseId);
  Future<Either<CourseFailure, Unit>> enrollStudent(String courseId, String studentId);
  Future<Either<CourseFailure, List<User>>> getEnrolledStudents(String courseId);
}

abstract class IScheduleRepository {
  Future<Either<ScheduleFailure, List<Schedule>>> getCourseSchedules(String courseId);
  Future<Either<ScheduleFailure, Schedule>> createSchedule(Schedule schedule);
  Future<Either<ScheduleFailure, Unit>> updateSchedule(Schedule schedule);
  Future<Either<ScheduleFailure, Unit>> deleteSchedule(String scheduleId);
}

abstract class IAttendanceRepository {
  Future<Either<AttendanceFailure, AttendanceSession>> createSession(String courseId, String scheduleId);
  Future<Either<AttendanceFailure, Unit>> markAttendance(String sessionId, String studentId);
  Future<Either<AttendanceFailure, List<AttendanceRecord>>> getSessionRecords(String sessionId);
  Future<Either<AttendanceFailure, List<AttendanceRecord>>> getStudentAttendance(String courseId, String studentId);
  Future<Either<AttendanceFailure, List<AttendanceSession>>> getCourseAttendanceSessions(String courseId);
  Future<Either<AttendanceFailure, AttendanceStats>> getCourseAttendanceStats(String courseId);
  Future<Either<AttendanceFailure, Unit>> submitExcuse(String recordId, String note);
  Future<Either<AttendanceFailure, Unit>> reviewExcuse(String recordId, bool isApproved);
  Future<Either<AttendanceFailure, String>> generateBackupCode(String sessionId); // For manual entry
}
```

### Failures

```dart
@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.serverError() = ServerError;
  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthFailure.invalidEmailAndPasswordCombination() = InvalidEmailAndPasswordCombination;
  const factory AuthFailure.invalidStudentId() = InvalidStudentId;
}

@freezed
class CourseFailure with _$CourseFailure {
  const factory CourseFailure.serverError() = ServerError;
  const factory CourseFailure.insufficientPermission() = InsufficientPermission;
  const factory CourseFailure.courseNotFound() = CourseNotFound;
  const factory CourseFailure.invalidJoinCode() = InvalidJoinCode;
}

@freezed
class ScheduleFailure with _$ScheduleFailure {
  const factory ScheduleFailure.serverError() = ServerError;
  const factory ScheduleFailure.scheduleConflict() = ScheduleConflict;
  const factory ScheduleFailure.scheduleNotFound() = ScheduleNotFound;
}

@freezed
class AttendanceFailure with _$AttendanceFailure {
  const factory AttendanceFailure.serverError() = ServerError;
  const factory AttendanceFailure.sessionExpired() = SessionExpired;
  const factory AttendanceFailure.invalidQRCode() = InvalidQRCode;
  const factory AttendanceFailure.alreadyMarked() = AlreadyMarked;
}
```

## Database Schema (Supabase)

```sql
-- Users table (handled by Supabase Auth)
profiles (
  id uuid references auth.users,
  full_name text,
  student_id text unique nullable, -- Only for students
  user_type text, -- 'professor' or 'student'
  created_at timestamp
)

courses (
  id uuid primary key,
  name text,
  professor_id uuid references profiles,
  join_code text unique,
  created_at timestamp
)

course_enrollments (
  course_id uuid references courses,
  student_id uuid references profiles,
  status text, -- 'pending', 'approved', 'rejected'
  enrolled_at timestamp
)

schedules (
  id uuid primary key,
  course_id uuid references courses,
  day_of_week int,
  start_time time,
  end_time time
)

attendance_sessions (
  id uuid primary key,
  course_id uuid references courses,
  schedule_id uuid references schedules,
  qr_code text,
  created_at timestamp,
  expires_at timestamp
)

attendance_records (
  session_id uuid references attendance_sessions,
  student_id uuid references profiles,
  marked_at timestamp,
  status text -- 'present', 'absent'
)
```

## UI Implementation Details

### Theme Specifications

#### Color Palette

```dart
// Shared Colors
const primaryColor = Color(0xFF1A73E8);     // Google Blue
const secondaryColor = Color(0xFF4285F4);   // Light Blue
const accentColor = Color(0xFF34A853);      // Green
const errorColor = Color(0xFFEA4335);       // Red
const warningColor = Color(0xFFFBBC05);     // Yellow

// Light Theme
const lightBackground = Color(0xFFFFFFFF);
const lightSurface = Color(0xFFF8F9FA);
const lightText = Color(0xFF202124);
const lightSubtext = Color(0xFF5F6368);

// Dark Theme
const darkBackground = Color(0xFF202124);
const darkSurface = Color(0xFF292A2D);
const darkText = Color(0xFFE8EAED);
const darkSubtext = Color(0xFF9AA0A6);
```

#### Typography

##### Desktop (Fluent UI)

```dart
// Use Segoe UI for Windows consistency
const typography = FluentThemeData.light().typography.copyWith(
  titleLarge: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: lightText,
  ),
  titleMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: lightText,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: lightText,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: lightSubtext,
  ),
);

final fluentTheme = FluentThemeData(
  accentColor: primaryColor,
  brightness: Brightness.light,
  visualDensity: VisualDensity.standard,
  scaffoldBackgroundColor: lightBackground,
  acrylicBackgroundColor: lightSurface,
  
  // Button styles
  buttonTheme: ButtonThemeData(
    defaultButtonStyle: ButtonStyle(
      padding: ButtonState.all(EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      )),
    ),
  ),
  
  // Card styles
  cardTheme: CardTheme(
    backgroundColor: lightSurface,
    elevation: 2,
    borderRadius: BorderRadius.circular(8),
  ),
);

final fluentThemeDark = FluentThemeData(
  accentColor: primaryColor,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.standard,
  scaffoldBackgroundColor: darkBackground,
  acrylicBackgroundColor: darkSurface,
  
  // Text styles with dark mode colors
  typography: typography.copyWith(
    titleLarge: typography.titleLarge.copyWith(color: darkText),
    titleMedium: typography.titleMedium.copyWith(color: darkText),
    bodyLarge: typography.bodyLarge.copyWith(color: darkText),
    bodyMedium: typography.bodyMedium.copyWith(color: darkSubtext),
  ),
  
  // Button styles
  buttonTheme: ButtonThemeData(
    defaultButtonStyle: ButtonStyle(
      padding: ButtonState.all(EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      )),
      backgroundColor: ButtonState.resolveWith((states) {
        if (states.isDisabled) return darkSurface.withOpacity(0.5);
        if (states.isPressed) return primaryColor.withOpacity(0.8);
        return primaryColor;
      }),
      foregroundColor: ButtonState.all(darkText),
    ),
  ),
  
  // Card styles
  cardTheme: CardTheme(
    backgroundColor: darkSurface,
    elevation: 2,
    borderRadius: BorderRadius.circular(8),
  ),
  
  // Navigation
  navigationPaneTheme: NavigationPaneThemeData(
    backgroundColor: darkBackground,
    selectedIconColor: primaryColor,
    unselectedIconColor: darkSubtext,
    selectedTextStyle: TextStyle(color: darkText),
    unselectedTextStyle: TextStyle(color: darkSubtext),
  ),
);
```

##### Mobile (Material)

```dart
// Use Roboto for Android consistency
final textTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: lightText,
  ),
  titleLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: lightText,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: lightText,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: lightSubtext,
  ),
);

final materialTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: lightSurface,
    background: lightBackground,
    error: errorColor,
  ),
  
  // Card styles
  cardTheme: CardTheme(
    color: lightSurface,
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  
  // AppBar style
  appBarTheme: AppBarTheme(
    backgroundColor: lightBackground,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: lightText),
  ),
  
  // Bottom Navigation
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: lightBackground,
    selectedItemColor: primaryColor,
    unselectedItemColor: lightSubtext,
  ),
);

final materialThemeDark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: darkSurface,
    background: darkBackground,
    error: errorColor,
    onPrimary: darkText,
    onSecondary: darkText,
    onSurface: darkText,
    onBackground: darkText,
    onError: darkText,
  ),
  
  // Text Theme
  textTheme: textTheme.apply(
    bodyColor: darkText,
    displayColor: darkText,
  ),
  
  // Card styles
  cardTheme: CardTheme(
    color: darkSurface,
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  
  // AppBar style
  appBarTheme: AppBarTheme(
    backgroundColor: darkBackground,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: darkText),
    titleTextStyle: TextStyle(
      color: darkText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  
  // Bottom Navigation
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: darkBackground,
    selectedItemColor: primaryColor,
    unselectedItemColor: darkSubtext,
    elevation: 8,
  ),
  
  // FAB Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: darkText,
    elevation: 4,
    highlightElevation: 8,
  ),
  
  // Dialog Theme
  dialogTheme: DialogTheme(
    backgroundColor: darkSurface,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
);
```

#### Component Themes

##### Desktop (Fluent UI)

```dart
// Button styles
ButtonThemeData(
  defaultButtonStyle: ButtonStyle(
    padding: ButtonState.all(EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    )),
  ),
)

// Card styles
CardTheme(
  backgroundColor: lightSurface,
  elevation: 2,
  borderRadius: BorderRadius.circular(8),
)
```

##### Mobile (Material)

```dart
// Card styles
CardTheme(
  color: lightSurface,
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
)

// AppBar style
AppBarTheme(
  backgroundColor: lightBackground,
  elevation: 0,
  centerTitle: true,
  iconTheme: IconThemeData(color: lightText),
)
```

### Desktop UI (Fluent UI)

#### Layout Structure

- NavigationView as main container
  - PaneDisplayMode.top for main navigation
  - CommandBar for actions
  - InfoBar for notifications

#### Screen Components

1. **Dashboard**
   - InfoBars for quick stats
   - ListView for today's schedule
   - DataTable for attendance overview
   - CommandBar for quick actions

2. **Course Management**
   - TabView for different sections
   - DataTable for student lists
   - CalendarView for schedule
   - ContentDialog for QR codes

3. **Attendance**
   - DataTable with sorting/filtering
   - Expander for excuse details
   - ContentDialog for backup codes

### Mobile UI (Material)

#### Layout Structure

- Material 3 NavigationBar
- FloatingActionButton for primary actions
- BottomSheet for additional options

#### Screen Components

1. **Dashboard**
   - Cards for course overview
   - ListTile for schedule items
   - MaterialBanner for notifications

2. **Course View**
   - TabBar for different sections
   - TableCalendar for schedule
   - ExpansionTile for course details

3. **Attendance**
   - QR Scanner with overlay
   - BottomSheet for manual entry
   - DataTable for history

## Wireframes

### Desktop App (Professor)

#### Login Screen

```
┌──────────────────────────────────────┐
│              Hadir                   │
├──────────────────────────────────────┤
│                                      │
│     ┌────────────────────────┐       │
│     │      Welcome Back      │       │
│     └────────────────────────┘       │
│                                      │
│     ┌────────────────────────┐       │
│     │ Email                  │       │
│     └────────────────────────┘       │
│                                      │
│     ┌────────────────────────┐       │
│     │ Password               │       │
│     └────────────────────────┘       │
│                                      │
│     ┌────────────────────────┐       │
│     │        Login           │       │
│     └────────────────────────┘       │
│                                      │
└──────────────────────────────────────┘
```

#### Dashboard

```
┌──────────────────────────────────────────────────────────────┐
│ Hadir           Courses  Schedule  Attendance  Profile        │
├──────────────────────────────────────────────────────────────┤
│ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────────────────┐ │
│ │ Active  │ │ Total   │ │ Today's │ │    Quick Actions    │ │
│ │ Courses │ │Students │ │ Classes │ │ ┌─────┐ ┌─────────┐ │ │
│ │   5     │ │   150   │ │    3    │ │ │ QR  │ │ Manual  │ │ │
│ └─────────┘ └─────────┘ └─────────┘ │ └─────┘ └─────────┘ │ │
│                                      └─────────────────────┘ │
├──────────────────────────┬───────────────────────────────────┤
│ Today's Schedule         │ Current Session                   │
│ ┌────────────────────┐  │ ┌─────────────────────────────┐  │
│ │ 08:00 - Math 101   │  │ │ Math 101 - Attendance       │  │
│ │ 10:30 - Physics    │  │ │ Present: 25  Absent: 5      │  │
│ │ 14:00 - Chemistry  │  │ │ [View Details]              │  │
│ └────────────────────┘  │ └─────────────────────────────┘  │
└──────────────────────────┴───────────────────────────────────┘
```

#### Course Management

```
┌──────────────────────────────────────────────────────────────┐
│ Hadir           [Course Name: Math 101]                      │
├──────────────────────────────────────────────────────────────┤
│ Details  Students  Schedule  Attendance                       │
├──────────────────────────────────────────────────────────────┤
│ Students List                        [+ Add Student]         │
│ ┌────────────────────────────────────────────────────────┐  │
│ │ ID    Name         Status    Attendance                 │  │
│ │ 001   John Doe     Active    85%                       │  │
│ │ 002   Jane Smith   Active    92%                       │  │
│ │ 003   Bob Johnson  Active    78%                       │  │
│ └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

### Mobile App (Student)

#### Login Screen

```
┌────────────────────┐
│     Hadir          │
├────────────────────┤
│   [University      │
│    Logo/Icon]      │
│                    │
│  ┌──────────────┐  │
│  │    Email     │  │
│  └──────────────┘  │
│                    │
│  ┌──────────────┐  │
│  │   Password   │  │
│  └──────────────┘  │
│                    │
│  ┌──────────────┐  │
│  │    Login     │  │
│  └──────────────┘  │
└────────────────────┘
```

#### Home Screen

```
┌────────────────────┐
│     Hadir          │
├────────────────────┤
│ Today's Classes    │
│ ┌──────────────┐   │
│ │ Math 101     │   │
│ │ 08:00-09:30  │   │
│ └──────────────┘   │
│                    │
│ ┌──────────────┐   │
│ │ Physics      │   │
│ │ 10:30-12:00  │   │
│ └──────────────┘   │
│                    │
│   [Scan QR Code]   │
├────────────────────┤
│ 🏠  📚  📷  👤    │
└────────────────────┘
```

#### QR Scanner

```
┌────────────────────┐
│   < Back           │
├────────────────────┤
│  ┌──────────────┐  │
│  │              │  │
│  │    Camera    │  │
│  │   Viewport   │  │
│  │              │  │
│  └──────────────┘  │
│                    │
│  Center QR Code    │
│  in the frame      │
│                    │
│  [Enter Code       │
│   Manually]        │
└────────────────────┘
```

These wireframes showcase:

- Clean, minimal design
- Clear hierarchy
- Easy navigation
- Essential information at a glance
- Consistent layout across screens

Would you like me to:

1. Add more specific screens?
2. Detail the interactions between screens?
3. Or focus on a particular screen's components?

## Implementation Phases

### Phase 1: Project Foundation

- Initialize melos monorepo
- Setup project structure
  - Core package
  - UI packages
  - Apps structure
- Configure basic CI/CD
- Setup Git repository

### Phase 2: Infrastructure Setup

- Setup Supabase project
  - Database schema
  - Authentication setup
  - Storage setup
- Configure environment variables
- Setup development tools

### Phase 3: Core Package Implementation

- Domain models
  - Entities
  - Value objects
  - Failures
- Repository interfaces
- Core providers
- Shared utilities

### Phase 4: UI Packages

- Desktop UI package (Fluent)
  - Theme implementation
  - Shared widgets
  - Navigation components
- Mobile UI package (Material)
  - Theme implementation
  - Shared widgets
  - Navigation components

### Phase 5: Authentication

- Implement auth repository
- Login/Register flows
- Profile management
- Session handling
- Error handling

### Phase 6: Desktop Features

1. Basic Structure
   - Navigation setup
   - Theme integration
   - Base layouts

2. Course Management
   - Course CRUD
   - Schedule management
   - Student enrollment

3. Attendance System
   - QR generation
   - Manual attendance
   - Backup codes
   - Excuse management

### Phase 7: Mobile Features

1. Basic Structure
   - Navigation setup
   - Theme integration
   - Base layouts

2. Course Features
   - Course joining
   - Schedule viewing
   - Calendar integration

3. Attendance Features
   - QR scanning
   - Manual code entry
   - Attendance history
   - Excuse submission

### Phase 8: Polish & Testing

- UI refinements
- Performance optimization
- Error handling improvements
- User feedback implementation
- Cross-platform testing

### Phase 9: Deployment

1. Desktop
   - Windows build setup
   - Installer creation
   - Auto-update system

2. Mobile
   - Android build
   - Play Store listing
   - Release management

3. Documentation
   - User guides
   - API documentation
   - Deployment guides

## Development Guidelines

### State Management

- Use Riverpod for state management
- Implement state notifiers for complex state
- Keep providers feature-scoped
- Use family providers for parameterized state

### Architecture

- Follow lite DDD principles
- Feature-first organization
- Clear separation of concerns
- SOLID principles

### Code Style

- Use Freezed for data classes
- Implement proper error handling
- Write meaningful comments
- Follow Flutter/Dart style guide
