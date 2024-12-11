# Hadir - Attendance Management System

A modern, cross-platform attendance management system built with Flutter. Hadir provides a desktop interface for professors and a mobile interface for students, utilizing Supabase as the backend.

## Features

### For Professors (Desktop)

- Course management
- Schedule management
- QR code generation for attendance
- Real-time attendance tracking
- Excuse management
- Attendance statistics and reports

### For Students (Mobile)

- Course enrollment
- QR code scanning for attendance
- Attendance history
- Excuse submission
- Schedule viewing

## Project Structure

```
hadir/
├── packages/
│   ├── hadir_core/          # Shared core functionality
│   ├── hadir_ui_desktop/    # Desktop-specific UI (Fluent UI)
│   └── hadir_ui_mobile/     # Mobile-specific UI (Material UI)
│
└── apps/
    ├── desktop/             # Professor's desktop app
    └── mobile/              # Student's mobile app
```

## Architecture

The project follows a lite Domain-Driven Design architecture with:

1. **Domain Layer**
   - Entities and value objects
   - Repository interfaces
   - Domain events and failures

2. **Infrastructure Layer**
   - Repository implementations
   - External services integration
   - Data persistence

3. **Application Layer**
   - Use cases
   - State management
   - Event handling

4. **Presentation Layer**
   - UI components
   - View models
   - Navigation

## Technology Stack

- **Frontend**: Flutter
- **Backend**: Supabase
- **State Management**: Riverpod
- **Database**: PostgreSQL
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage

## Getting Started

### Prerequisites

- Flutter
- Dart
- Supabase

### Setup

1. Clone the repository:

```bash
git clone https://github.com/jhonny/hadir.git
cd hadir
```

2. Install dependencies:

```bash
dart pub global activate melos
melos bootstrap
```

3. Configure environment variables:
   - Create `.env` file in both app directories
   - Add Supabase credentials

4. Run the desired app:

```bash
# For desktop
cd apps/desktop
flutter run

# For mobile
cd apps/mobile
flutter run
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
