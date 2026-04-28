# Architecture Snapshot — ru-empresa

> Last verified: 2026-04-28. If FlutterFlow regenerates the project significantly (the recurring `Updating to latest FlutterFlow output.` commits), re-verify this file.

## Top-level `lib/` layout

```
lib/
├── auth/                       Supabase Auth providers and helpers
├── backend/
│   ├── firebase/               Firebase config (analytics + crashlytics only)
│   ├── schema/                 FF struct + enum definitions
│   └── supabase/
│       ├── database/
│       │   ├── database.dart   Central DB import
│       │   └── tables/         One file per Supabase table
│       └── supabase.dart       SupaFlow init
├── components/                 Composed components (FF-managed)
├── custom_code/
│   ├── actions/                Custom Future<...> actions (12 files)
│   │   └── index.dart          Registry of exported actions
│   └── widgets/                Custom widgets (1 file + index.dart)
├── flutter_flow/               READ-ONLY (except custom_functions.dart)
│   ├── nav/nav.dart            GoRouter + AppStateNotifier
│   ├── flutter_flow_util.dart
│   ├── flutter_flow_model.dart  base class FlutterFlowModel<T>
│   ├── custom_functions.dart   ✏️ user-editable
│   └── ...
├── lead/                       Lead domain (provider + models)
├── pages/                      Page widgets (7 pages, each = widget + model)
├── providers/                  Provider-based state (domain)
├── services/                   Domain services
├── subscription/               Subscription flow
├── users/                      User domain
├── widgets/                    Reusable widgets (FF-managed)
├── app_state.dart              FFAppState singleton
├── index.dart                  Re-exports for FF builder
└── main.dart                   Entry — Supabase → Firebase → FFAppState → custom actions
```

## Counts (as of 2026-04-28)

| Area | Count | Notes |
|------|-------|-------|
| Pages | 7 | `appointment_page`, `candidate_portfolio_page`, `candidate_profile_page`, `home_page`, `menu_page`, `sac_page`, `termos_page` |
| Custom actions | 12 | `app_review`, `app_tracking`, `cancel_subscription`, `check_subscription`, `create_subscription`, `get_subscription_status`, `in_app_update`, `link_to`, `lock_orientation`, `set_f_c_m_token`, `update_password` (+ `index.dart`) |
| Custom widgets | 1 | `moeda_b_r_field` (BR currency input) |
| Components | 2 | Reusable composed components |
| Supabase tables | ~15+ | `banners`, `categories`, `chats`, `chats_message`, `external_banner`, `lead_attachment`, `lead_contact`, `leads`, `menus`, `message_comment`, … |

## Initialization order (`lib/main.dart`)

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `GoRouter.optionURLReflectsImperativeAPIs = true`
3. `usePathUrlStrategy()`
4. `await initFirebase()`
5. `await SupaFlow.initialize()`  (Supabase)
6. `final appState = FFAppState();`
7. `await appState.initializePersistedState();`
8. `FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;` (non-web)
9. Custom actions in order: `setFCMToken` → `appTracking` → `inAppUpdate` → `lockOrientation`
10. `runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_) => appState)], child: MyApp()))`

## Local / private packages

These are not on pub.dev — they live in the FlutterFlow account:

- `ff_commons` — shared FlutterFlow commons
- `ff_theme` — `FlutterFlowTheme` source (`FlutterFlowTheme.of(context)`)
- `utility_functions_library_8g4bud` — utility library; even initializes routes (`initializeRoutes(...)` called inside `createRouter`)

## Key files (cheat sheet)

| Path | Role |
|------|------|
| [lib/main.dart](../../../lib/main.dart) | Entry point + bootstrap |
| [lib/app_state.dart](../../../lib/app_state.dart) | FFAppState singleton + persisted state |
| [lib/flutter_flow/nav/nav.dart](../../../lib/flutter_flow/nav/nav.dart) | GoRouter + AppStateNotifier |
| [lib/flutter_flow/custom_functions.dart](../../../lib/flutter_flow/custom_functions.dart) | ✏️ User-editable pure helpers |
| [lib/custom_code/actions/index.dart](../../../lib/custom_code/actions/index.dart) | Custom action registry (exports) |
| [lib/custom_code/actions/set_f_c_m_token.dart](../../../lib/custom_code/actions/set_f_c_m_token.dart) | Reference for action barrier |
| [lib/custom_code/widgets/moeda_b_r_field.dart](../../../lib/custom_code/widgets/moeda_b_r_field.dart) | Reference for widget barrier |
| [lib/pages/home_page/home_page_widget.dart](../../../lib/pages/home_page/home_page_widget.dart) | Reference page widget |
| [lib/pages/home_page/home_page_model.dart](../../../lib/pages/home_page/home_page_model.dart) | Reference page model |
| [lib/backend/supabase/database/tables/menus.dart](../../../lib/backend/supabase/database/tables/menus.dart) | Reference Supabase Table/Row |
| [analysis_options.yaml](../../../analysis_options.yaml) | Confirms exclusions: `custom_code/**` + `custom_functions.dart` |

## Dependencies of note (`pubspec.yaml`)

- `supabase_flutter: 2.9.0`, `supabase: 2.7.0`
- `firebase_core: 3.14.0`, `firebase_analytics: 11.5.0`, `firebase_crashlytics: 4.3.7`
- `provider: 6.1.5`, `rxdart: 0.27.7`
- `go_router` (via re-export from `nav.dart`)
- `flutter_secure_storage`
- `google_maps_flutter: 2.12.2`, `geolocator: 14.0.1`
- `flutter_localizations` + `intl: 0.20.2`
- Lottie, image_picker, file_picker, webview_flutter, video_player, cached_network_image
- Local: `ff_commons`, `ff_theme`, `utility_functions_library_8g4bud`

## What is and is NOT user-editable

| Zone | Status |
|------|--------|
| `lib/custom_code/**` | ✏️ Fully editable (excluded from analysis) |
| `lib/flutter_flow/custom_functions.dart` | ✏️ Editable (excluded from analysis) |
| `lib/app_state.dart` | ✏️ Editable but follow `ff_` + `_safeInitAsync` conventions |
| `lib/main.dart` | ⚠️ Editable but FlutterFlow regenerates — keep changes minimal |
| `lib/pages/`, `lib/components/`, `lib/widgets/` | ⚠️ FF-managed; safer to add new files than edit existing |
| `lib/backend/supabase/database/tables/` | ⚠️ FF regenerates from schema — match the existing pattern exactly |
| `lib/flutter_flow/` (rest) | 🔒 Read-only |
| `lib/index.dart` | 🔒 Auto-generated re-exports |
