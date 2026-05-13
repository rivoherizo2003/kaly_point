# Kaly Point Project Guide

This document provides an overview of the Kaly Point project, including its purpose, technical stack, development guidelines, and how to set up and run the application.

## Project Overview

Kaly Point is a cross-platform Flutter application designed to manage meal checkpoints. Its primary function is to track sessions, manage individuals, and record their service status at various checkpoints. The application uses a local SQLite database for data storage and `provider` for state management, enabling a robust and responsive user experience across desktop (Windows, Linux, macOS) and mobile (Android, iOS) platforms.

**Core Functionalities:**
*   **Session Management:** Create, Read, Update, Delete (CRUD) operations for sessions, with pagination for efficient listing.
*   **Checkpoint Management:** CRUD operations for checkpoints within each session, and navigation to a dedicated "pointage" (checking) page.
*   **Pointage Page:**
    *   Displays real-time statistics (e.g., number to serve, served, remaining).
    *   Separated views for persons "to serve" and "served."
    *   Search functionality for persons across different statuses.
    *   Ability to add new persons to a checkpoint (automatically adding them to the session and marking them as served).
    *   Functionality to remove a person's served status.
    *   Option to add an existing person from the session to the current checkpoint.
*   **Person Management:** Actions to modify or delete person information (planned for enhancement).
*   **Future Enhancements:** Integration with Firebase for data export and import for potential cloud synchronization.

## Technical Stack

*   **Framework:** Flutter (Dart)
*   **State Management:** `provider`
*   **Local Database:** SQLite (via `sqflite` and `sqflite_common_ffi` for desktop)
*   **Linting:** `flutter_lints`
*   **Utilities:** `path` for file system operations
*   **Assets:** `flutter_launcher_icons` and `flutter_native_splash` for managing application icons and splash screens.

## Building and Running

### Prerequisites

*   Flutter SDK installed and configured.
*   For desktop development, ensure `sqflite_common_ffi` prerequisites are met (e.g., SQLite3 development libraries).

### Database Setup

1.  Create an SQLite database named `kaly_point.db` in the `data` folder at the root of the project.
    *   _Note:_ The `DatabaseService` handles schema creation and upgrades automatically.

### Commands

*   **Get Dependencies:**
    ```bash
    flutter pub get
    ```
*   **Run the Application:**
    ```bash
    flutter run
    ```
    To run on a specific device or platform, use `flutter run -d <device_id>` (e.g., `flutter run -d chrome`, `flutter run -d windows`).

*   **Build the Application (e.g., for Android):**
    ```bash
    flutter build apk
    ```
    Refer to Flutter documentation for building for other platforms (`flutter build web`, `flutter build macos`, etc.).

*   **Rebuild Icons and Splash Screen:**
    ```bash
    dart run flutter_launcher_icons && dart run flutter_native_splash:create
    ```

### Testing

*   **Run Widget Tests:**
    ```bash
    flutter test
    ```

## Development Conventions

*   **Code Style:** Adheres to `flutter_lints` guidelines as configured in `analysis_options.yaml`.
*   **Project Structure:** Follows a standard Flutter project layout with clear separation of concerns:
    *   `lib/constants`: Application-wide constants.
    *   `lib/dto`: Data Transfer Objects.
    *   `lib/enums`: Enumerations.
    *   `lib/models`: Data models.
    *   `lib/services`: Database and business logic services.
    *   `lib/utils`: Utility functions.
    *   `lib/viewmodels`: Provider-based view models for state management.
    *   `lib/views`: UI pages/screens.
    *   `lib/widgets`: Reusable UI components.
*   **State Management:** `provider` is used for managing application state.
*   **Database Interactions:** Handled via `DatabaseService` for consistent and safe data operations.
