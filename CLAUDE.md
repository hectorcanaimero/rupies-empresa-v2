# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Rupies Empresas is a Flutter mobile application for businesses, built using FlutterFlow and running on Flutter stable. The app uses Supabase as the backend database and authentication provider, with Firebase integration for analytics, crashlytics, and cloud functions.

## Tech Stack

- **Flutter**: Version 3.32.4+ (Flutter stable channel required)
- **Dart**: SDK >=3.0.0 <4.0.0
- **Backend**: Supabase (database, auth, storage)
- **Analytics & Monitoring**: Firebase Analytics, Firebase Crashlytics, Firebase Performance
- **Cloud Functions**: Firebase Cloud Functions (Node.js 20)
- **State Management**: Provider pattern with FFAppState
- **Navigation**: go_router (v12.1.3)
- **Secure Storage**: flutter_secure_storage for persisted app state
- **Maps**: Google Maps integration
- **Localization**: Portuguese (pt) - single language app

## Development Commands

### Flutter Application

```bash
# Install dependencies
flutter pub get

# Run the app (development)
flutter run

# Build for Android
flutter build apk
flutter build appbundle

# Build for iOS
flutter build ios

# Run tests
flutter test

# Analyze code
flutter analyze

# Clean build artifacts
flutter clean
```

### Firebase Cloud Functions

```bash
cd firebase/functions

# Install dependencies
npm install

# Run linter
npm run lint

# Start local emulator
npm run serve

# View function logs
npm run logs

# Deploy functions
firebase deploy --only functions
```

### Local Dependencies

This project uses local path dependencies that need to be updated when the main project version changes:

```bash
# After updating version in pubspec.yaml, also update:
# - dependencies/ff_commons/pubspec.yaml
# - dependencies/ff_theme/pubspec.yaml
# - dependencies/utility_functions_library_8g4bud/pubspec.yaml
```

## Architecture

### Directory Structure

- **lib/**: Main application code
  - **auth/**: Authentication logic with Supabase
    - `supabase_auth/`: Supabase authentication implementation
  - **backend/**: Data layer
    - `supabase/`: Supabase client setup and exports
      - `database/`: Database row models and table definitions
      - `storage/`: File storage helpers
    - `schema/`: Data structures and enums
      - `structs/`: Dart data structures (e.g., UserStruct)
      - `enums/`: Enum definitions
    - `firebase/`: Firebase configuration
  - **flutter_flow/**: FlutterFlow-generated utilities
    - UI components (buttons, dropdowns, icons, etc.)
    - Navigation helpers
    - Internationalization
    - Custom functions
  - **pages/**: Screen implementations (each page has its own directory)
    - appointment_page/
    - candidate_portfolio_page/
    - candidate_profile_page/
    - home_page/
    - menu_page/
    - sac_page/
  - **widgets/**: Reusable UI components
  - **custom_code/**: Custom Flutter code outside FlutterFlow
    - `actions/`: Custom actions (app review, tracking, FCM, etc.)
    - `widgets/`: Custom widget implementations
  - **providers/**: Provider classes for state management
  - **services/**: Service layer implementations
  - **lead/**: Lead management functionality
  - **users/**: User-related functionality
  - **app_state.dart**: Global app state with Provider
  - **main.dart**: Application entry point

- **dependencies/**: Local package dependencies
  - **ff_commons/**: FlutterFlow common utilities
  - **ff_theme/**: Theme definitions
  - **utility_functions_library_8g4bud/**: Custom utility functions

- **firebase/**: Firebase configuration
  - **functions/**: Node.js Cloud Functions
    - Includes integrations: Stripe, Braintree, Mux, Razorpay, OneSignal
    - LangChain support (OpenAI, Google GenAI, Anthropic)

- **assets/**: Static assets (images, fonts, videos, audios, animations, PDFs, JSONs)

### Key Architectural Patterns

**State Management**:
- Global app state managed via `FFAppState` (Provider-based)
- Persistent state stored in `flutter_secure_storage`
- Key state fields: user, serviceId, leadId, fcmToken, typecompany
- Request caching via `FutureRequestManager` for API calls

**Authentication**:
- Supabase Auth with implicit flow (`AuthFlowType.implicit`)
- User stream: `rupiesEmpresasSupabaseUserStream()`
- JWT token management
- Auth state managed by `AppStateNotifier`

**Navigation**:
- go_router with route serialization/deserialization
- URL reflects imperative APIs (`GoRouter.optionURLReflectsImperativeAPIs = true`)
- Path-based URL strategy for web

**Database**:
- Supabase backend at `https://supa.rupies.com.br`
- Type-safe row models for each table (e.g., `LeadsRow`, `ServicesRow`, `ProvidersRow`)
- Database tables include: leads, services, providers, categories, chats, notifications, users, profiles, etc.
- View tables for complex queries (e.g., `ViewServicesWithCategoriesRow`)

**Firebase Integration**:
- Firebase Crashlytics for error reporting (non-web only)
- Firebase Analytics and Performance monitoring
- Cloud Functions for serverless backend operations

**Localization**:
- Single language support: Portuguese (pt)
- Uses Flutter's localization delegates
- Custom FFLocalizationsDelegate

## FlutterFlow Integration

This is a FlutterFlow-managed project. Important considerations:

- Many files in `lib/flutter_flow/` are auto-generated
- Database table models in `lib/backend/supabase/database/tables/` are generated
- The serialization utilities in `lib/flutter_flow/nav/serialization_util.dart` handle all Supabase row types
- When adding new database tables, they must be registered in the deserialization switch statement
- FlutterFlow generates code on the stable Flutter channel

## Common Workflows

### Adding a New Database Table

1. Create the table in Supabase
2. FlutterFlow will generate the row model in `lib/backend/supabase/database/tables/`
3. Add the row type to `serialization_util.dart` in the `ParamType.SupabaseRow` switch case
4. Export the new table from `lib/backend/supabase/database/database.dart`

### Working with Custom Actions

Custom actions are in `lib/custom_code/actions/`:
- `app_review.dart`: Trigger in-app review prompts
- `app_tracking.dart`: Request app tracking permission (iOS)
- `in_app_update.dart`: Handle in-app updates (Android)
- `set_f_c_m_token.dart`: Manage Firebase Cloud Messaging tokens
- `lock_orientation.dart`: Control screen orientation
- `link_to.dart`: Handle deep linking

### Modifying App State

When adding new persistent state:
1. Add field to `FFAppState` class in `lib/app_state.dart`
2. Add getter/setter with secure storage integration
3. Add initialization in `initializePersistedState()`
4. Add delete method for cleanup

### Firebase Cloud Functions

Functions are written in JavaScript (Node.js 20) and located in `firebase/functions/`:
- Main handler: `index.js`
- API manager: `api_manager.js`
- Available integrations: Stripe, Braintree, Mux, Razorpay, OneSignal, LangChain

## Important Notes

- **FlutterFlow Sync**: Certain files are managed by FlutterFlow and will be overwritten on sync. Custom modifications should go in `lib/custom_code/`
- **Supabase Credentials**: The Supabase URL and anon key are committed in `lib/backend/supabase/supabase.dart` (public anon key is safe to commit)
- **Version Coordination**: Keep version numbers in sync across main pubspec.yaml and local dependencies
- **Flutter Channel**: Always use Flutter stable channel for this project
- **Material Design**: App uses Material 2 (`useMaterial3: false`)
- **Dependency Overrides**: Several package versions are pinned via `dependency_overrides` to ensure compatibility
