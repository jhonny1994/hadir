# Hadir Core

Core package for the Hadir attendance management system.

## Features

### Domain Layer

- Entities (User, Course, Schedule, AttendanceSession)
- Value Objects (Email, CourseCode, UniqueId)
- Repository Interfaces

### Infrastructure Layer

- Repository Implementations
- Supabase Integration

### Application Layer

- Providers (Auth, Course, Attendance, Schedule)
- Utilities (DateTime, QR)

## Architecture

This package follows Domain-Driven Design principles:

1. **Domain Layer**: Contains business logic and interfaces
2. **Infrastructure Layer**: Implements interfaces and handles external services
3. **Application Layer**: Manages state and provides utilities

## Usage

Import the package in your `pubspec.yaml`:

```yaml
dependencies:
  hadir_core:
    path: ../packages/hadir_core
