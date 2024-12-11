# Hadir UI Desktop

Desktop UI package for Hadir attendance management system, built with Flutter and Fluent UI.

## Features

### Theme System

- Fluent UI theme integration
- Light and dark mode support
- Consistent color scheme
- Typography system
- Spacing constants

### Components

#### Navigation

- Navigation pane with items
- Route management
- Nested navigation support

#### Buttons

- Primary button with loading state
- Icon support
- Proper sizing and spacing

#### Inputs

- Text input with error handling
- Search box with clear functionality
- Form styling

#### Cards

- Info card for statistics
- Schedule card for class listings
- Quick actions card for dashboard

## Usage

```dart
import 'package:hadir_ui_desktop/hadir_ui_desktop.dart';

// Use theme
FluentThemeData theme = HadirTheme.light();

// Use components
PrimaryButton(
  text: 'Click me',
  onPressed: () {},
);

TextInput(
  label: 'Email',
  placeholder: 'Enter your email',
);

InfoCard(
  title: 'Active Courses',
  value: '5',
  icon: FluentIcons.book_contacts,
);
