---
name: flutterflow
description: >
  FlutterFlow project conventions for ru-empresa. Loads when editing files under lib/ —
  especially custom_code/ (actions, widgets, functions), pages/ (page_widget.dart +
  page_model.dart pairs), components/, backend/supabase/, flutter_flow/, app_state.dart,
  or main.dart. Also triggers on /flutterflow. Codifies the DO NOT REMOVE barriers,
  Widget+Model pattern, Supabase Tables/Rows pattern, FFAppState singleton + GoRouter conventions.
license: Apache-2.0
metadata:
  author: hector-velasquez
  version: "1.0"
---

## When to Use

Load this skill when:
- Editing or creating any file under `lib/custom_code/` (actions, widgets, functions)
- Creating a new page (`lib/pages/[name]/[name]_widget.dart` + `[name]_model.dart`)
- Creating or editing a component under `lib/components/` or `lib/widgets/`
- Touching `lib/backend/supabase/` (tables, queries, schema)
- Modifying `lib/app_state.dart`, `lib/main.dart`, or anything under `lib/flutter_flow/`
- The user mentions: FlutterFlow, FFAppState, custom action/widget/function, Supabase table/row, page model
- The user invokes `/flutterflow`

---

## Project Stack (ru-empresa)

| Layer | Tool / Version |
|-------|---------------|
| Flutter SDK | `>=3.0.0 <4.0.0` |
| Backend (data) | `supabase_flutter 2.9.0` + `supabase 2.7.0` |
| Backend (analytics/crash) | `firebase_core 3.14.0`, `firebase_analytics 11.5.0`, `firebase_crashlytics 4.3.7` |
| State | `provider 6.1.5` + `ChangeNotifier` (FFAppState singleton) |
| Persistence | `flutter_secure_storage` (key prefix `ff_`) |
| Routing | `go_router` via `flutter_flow/nav/nav.dart` (FFRoute + AppStateNotifier) |
| i18n | `flutter_localizations` + `intl 0.20.2` (FFLocalizations) |
| Theme | local package `ff_theme` → `FlutterFlowTheme.of(context)` |
| Custom utils | local package `ff_commons`, `utility_functions_library_8g4bud` |

**The project uses Provider + ChangeNotifier. Do NOT introduce Riverpod, Bloc, GetX, or any other state management.**

---

## Critical Rules (NEVER violate)

1. **Never touch the auto-generated header in custom_code files.** The barrier line is sacred:
   ```dart
   // Begin custom action code   ← (or "custom widget code" for widgets)
   // DO NOT REMOVE OR MODIFY THE CODE ABOVE!
   ```
   All FlutterFlow auto-imports live ABOVE this barrier. Your code goes BELOW. If you remove or reorder anything above the barrier, the next FlutterFlow sync silently breaks the project.

2. **Page = Widget + Model (always paired).** Every page in `lib/pages/[name]/` is two files:
   - `[name]_widget.dart` — the `StatefulWidget` with `static routeName` (PascalCase) and `static routePath` (camelCase)
   - `[name]_model.dart` — `extends FlutterFlowModel<[Name]Widget>`, owns child component models, has `initState(context)` and `dispose()`
   The widget file MUST `import` AND `export` the model file.

3. **`flutter_flow/` is read-only**, with one exception:
   - ✅ Editable: `lib/flutter_flow/custom_functions.dart`
   - ❌ Read-only: everything else (`nav/`, `flutter_flow_util.dart`, `flutter_flow_theme.dart` from package, `flutter_flow_model.dart`, etc.)
   `analysis_options.yaml` already excludes `lib/custom_code/**` and `flutter_flow/custom_functions.dart` from analysis — confirming these are the only "user-owned" zones.

4. **Supabase is the data backend, Firebase is observability only.** Never store business data in Firestore. Never call Firebase Auth — use `lib/auth/supabase_auth/`.

5. **State changes go through `FFAppState().update(() { ... })` or via the typed setters.** Never bypass `notifyListeners()` by mutating `_user`, `_subscription`, etc. directly from outside.

---

## Pattern 1 — Custom Code Barriers

### Custom Action (`lib/custom_code/actions/[snake_name].dart`)

Real example structure (do NOT alter the top block):

```dart
// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import "package:utility_functions_library_8g4bud/backend/schema/structs/index.dart"
    as utility_functions_library_8g4bud_data_schema;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ↓↓↓ Your custom imports + function go here ↓↓↓
import 'package:http/http.dart' as http;

Future<void> mySnakeNameAction() async {
  // implementation
}
```

After creating an action, **register it in `lib/custom_code/actions/index.dart`** (also auto-managed but you add the export):

```dart
export 'my_snake_name.dart' show mySnakeNameAction;
```

Reference: see [lib/custom_code/actions/set_f_c_m_token.dart](lib/custom_code/actions/set_f_c_m_token.dart).

### Custom Widget (`lib/custom_code/widgets/[snake_name].dart`)

Same structure, but the barrier comment says `widget`:

```dart
// Automatic FlutterFlow imports
// ... (imports)
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ↓↓↓ Your StatefulWidget/StatelessWidget here ↓↓↓
class MySnakeName extends StatefulWidget {
  const MySnakeName({Key? key, this.width, this.height}) : super(key: key);
  final double? width;
  final double? height;
  // ...
}
```

Reference: see [lib/custom_code/widgets/moeda_b_r_field.dart](lib/custom_code/widgets/moeda_b_r_field.dart).

### Custom Function (`lib/flutter_flow/custom_functions.dart`)

Pure synchronous Dart helpers used inside FlutterFlow expressions. No barrier — but the file is excluded from analysis. Keep functions small, pure, and side-effect free.

---

## Pattern 2 — Page Widget + Model

### Widget skeleton

```dart
// (FlutterFlow auto-manages imports — match the order from existing pages)
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'settings_page_model.dart';
export 'settings_page_model.dart';

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({super.key});

  static String routeName = 'SettingsPage';   // PascalCase — referenced via context.goNamed
  static String routePath = 'settingsPage';   // camelCase — URL path

  @override
  State<SettingsPageWidget> createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  late SettingsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'SettingsPage'});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>(); // re-builds on state changes
    // ...
  }
}
```

### Model skeleton

```dart
import '/flutter_flow/flutter_flow_util.dart';
import 'settings_page_widget.dart' show SettingsPageWidget;
import 'package:flutter/material.dart';

class SettingsPageModel extends FlutterFlowModel<SettingsPageWidget> {
  // late component models go here
  // late ChildWidgetModel childWidgetModel;

  @override
  void initState(BuildContext context) {
    // childWidgetModel = createModel(context, () => ChildWidgetModel());
  }

  @override
  void dispose() {
    // childWidgetModel.dispose();
  }
}
```

**Rule of thumb**: state, controllers, query results, and child component models live in the **Model**. The Widget is just `build()` + lifecycle delegation.

Reference: [lib/pages/home_page/home_page_widget.dart](lib/pages/home_page/home_page_widget.dart) + [lib/pages/home_page/home_page_model.dart](lib/pages/home_page/home_page_model.dart).

---

## Pattern 3 — Supabase Tables / Rows

Each table = one file under `lib/backend/supabase/database/tables/[name].dart`:

```dart
import '../database.dart';

class FooTable extends SupabaseTable<FooRow> {
  @override
  String get tableName => 'foo';

  @override
  FooRow createRow(Map<String, dynamic> data) => FooRow(data);
}

class FooRow extends SupabaseDataRow {
  FooRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FooTable();

  // Required field (non-null with `!`)
  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  // Optional field
  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  // Always typed via getField<T> / setField<T>
  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
```

**Querying** (from a page or action):
```dart
final rows = await FooTable().queryRows(
  queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
);
```

Reference: [lib/backend/supabase/database/tables/menus.dart](lib/backend/supabase/database/tables/menus.dart).

---

## Pattern 4 — FFAppState + Routing

### Adding a persisted state field to `FFAppState`

```dart
// In lib/app_state.dart, inside class FFAppState:

// 1) Backing field
String _myValue = '';
String get myValue => _myValue;
set myValue(String value) {
  _myValue = value;
  secureStorage.setString('ff_myValue', value);
}
void deleteMyValue() {
  secureStorage.delete(key: 'ff_myValue');
}

// 2) Initialize in initializePersistedState():
await _safeInitAsync(() async {
  _myValue = await secureStorage.getString('ff_myValue') ?? _myValue;
});
```

**Conventions**:
- Storage keys MUST use the `ff_` prefix.
- Always provide a `delete[Field]()` method.
- Wrap async init in `_safeInitAsync()` to avoid corrupted-state crashes.
- For complex types (Struct), use `jsonDecode/Encode` + `fromSerializableMap` — see existing `_user`, `_subscription`.

### Routes

Routes live in `lib/flutter_flow/nav/nav.dart` (read-only — FlutterFlow regenerates this). Each page widget exposes:

```dart
static String routeName = 'SettingsPage';   // PascalCase
static String routePath = 'settingsPage';   // camelCase URL segment
```

Navigation uses `context.goNamed`/`context.pushNamed`:
```dart
context.goNamed(SettingsPageWidget.routeName);
```

---

## Decision Tree — Where does this code go?

```
Is it new UI?
├── A page (full screen)?            → lib/pages/[name]/  (widget + model pair)
├── A reusable Widget for FF builder? → lib/custom_code/widgets/  (with barrier)
└── A composed component?             → lib/components/ or lib/widgets/

Is it logic?
├── Reusable async/Future action?    → lib/custom_code/actions/  (with barrier)
├── Pure Dart helper?                → lib/flutter_flow/custom_functions.dart
└── Domain feature (subscription, lead, user)? → lib/{subscription,lead,users}/

Is it state?
├── Persistent global state?         → lib/app_state.dart  (FFAppState + ff_ prefix)
└── Page/component-local state?      → the page/component Model class

Is it data?
└── New Supabase table?              → lib/backend/supabase/database/tables/[name].dart
                                        + register in lib/backend/supabase/database/database.dart
```

---

## Anti-patterns (reject these)

- ❌ Editing imports above `// DO NOT REMOVE OR MODIFY THE CODE ABOVE!`
- ❌ Creating a page widget without its companion model
- ❌ Writing business logic inside the page widget instead of the model
- ❌ Using Riverpod / Bloc / GetX / Cubit / Mobx
- ❌ Reading state with `Provider.of(context, listen: false)` for reactive UI (use `context.watch<FFAppState>()`)
- ❌ Using Firestore / Firebase Realtime DB for app data (Supabase only)
- ❌ Creating files under `lib/flutter_flow/` (only edit `custom_functions.dart`)
- ❌ Mutating `FFAppState()` private fields directly from outside
- ❌ Hardcoded colors / fonts — always go through `FlutterFlowTheme.of(context)`
- ❌ Skipping `logFirebaseEvent('screen_view', ...)` on a new page

---

## When FlutterFlow regenerates (Sync Workflow)

FlutterFlow is generated code that gets re-emitted from the FlutterFlow web editor. Manual fixes in FF-managed zones get **silently overwritten** on every sync. This section is the operational playbook.

### Detection — how do I know a sync just happened?

A sync is identified by:
- A commit with the exact message `Updating to latest FlutterFlow output.` (this project's convention).
- Massive simultaneous changes across `lib/pages/`, `lib/services/`, `lib/components/`, `lib/widgets/`, `lib/backend/`, `lib/flutter_flow/` in a single commit.
- The user saying "the bug came back" or "I just synced".

When you detect a recent sync, **before doing anything else** run the Post-sync checklist below.

### Risk zones — what gets overwritten?

| Zone | Overwrite risk | Notes |
|------|----------------|-------|
| `lib/custom_code/**` | 🟢 Safe | Below the `// DO NOT REMOVE OR MODIFY` barrier. Edits survive sync. |
| `lib/flutter_flow/custom_functions.dart` | 🟢 Safe | Excluded from regeneration by convention. |
| `lib/pages/`, `lib/services/`, `lib/lead/`, `lib/users/` | 🔴 High | Widget+Model regenerated on every sync. |
| `lib/components/`, `lib/widgets/` | 🔴 High | FF-managed components. |
| `lib/backend/supabase/database/tables/` | 🔴 High | Schema regenerated from FF's data definition. |
| `lib/flutter_flow/` (rest) | 🔴 High | De facto read-only. |
| `lib/main.dart` | 🟡 Medium | FF can modify it partially; manual edits sometimes survive. |
| `lib/app_state.dart` | 🟡 Medium | Follows FF conventions; manual fields survive if `ff_` prefix + `_safeInitAsync` are respected. |

### Pre-sync checklist (BEFORE pulling the next FF output)

- [ ] List manually-modified files since the last sync: `git log --since=<last-sync-date> --name-only -- lib/`.
- [ ] For each fix in a 🔴 zone: confirm the fix is persisted in engram (`mem_search` for `flutterflow/bugfixes/...`) so it can be re-applied.
- [ ] Whenever possible, **port the fix to the FlutterFlow web editor BEFORE syncing** (e.g. fix a hardcoded string on a Text widget, change a Form's autovalidateMode property). That makes it permanent.
- [ ] If the fix can't be expressed in FF web (e.g. wrapping a Supabase insert in try/catch), consider moving the logic to `lib/custom_code/actions/` (🟢 zone) so it survives.

### Post-sync checklist (AFTER pulling/merging the FF output commit)

- [ ] Identify the pre-sync commit: `git log --oneline | rg -B1 'Updating to latest FlutterFlow output' | head`.
- [ ] For each file you previously fixed: `git diff <pre-sync-commit>..HEAD -- <file>`.
  - If FF re-introduced the bug → re-apply the fix (Edit) and update the engram entry.
  - If FF fixed it on its end → mark the engram entry as obsolete with `mem_update`.
- [ ] Run the recurring-fixes search across `lib/` (see registry below) and re-apply any pattern that came back.

### Recurring fixes registry (this project)

These bugs have been fixed at least once and tend to come back after syncs. Always sweep these patterns post-sync.

**pt_BR typos** (search: `rg 'Campo Obrigatorio|Campo Origatorio|obrigatoria|disponivel\.|Email não valido' lib/`):
- `Campo Obrigatorio` / `Campo Origatorio` → `Campo obrigatório`
- `obrigatoria` (in dialogs) → `obrigatória`
- `disponivel.` → `disponíveis.`
- `Email não valido.` → `E-mail inválido.`
- `Hora de chegada  é` (double space + missing accent) → `hora de chegada é`

**AutovalidateMode silent-fail** (search: `rg 'AutovalidateMode\.disabled' lib/`):
- `autovalidateMode: AutovalidateMode.disabled` on a `Form` makes `formKey.validate()` return false silently — the user taps a button and nothing visible happens. Always change to `AutovalidateMode.onUserInteraction` so red error messages appear under each field.

**Engram references**:
- `flutterflow/bugfixes/service-urgent-form` — original audit + fix on the urgent service flow.
- `flutterflow/bugfixes/ptbr-typos-batch` — extension to schedule + lead pages.

### Permanent fix strategy — decision tree

```
Can the fix be made in the FlutterFlow web editor?
├── YES → Apply it there, then sync. Done permanently.
└── NO  → Is the logic generic enough to live in custom_code/?
         ├── YES → Move it to lib/custom_code/actions/ or widgets/. 🟢 zone, survives sync.
         └── NO  → Apply locally, save to engram with topic_key flutterflow/bugfixes/<short-name>.
                   Re-apply after every sync via the post-sync checklist.
```

---

## Verification Checklist (before closing a change)

- [ ] If I touched custom_code → the `// DO NOT REMOVE OR MODIFY THE CODE ABOVE!` barrier is intact and all imports above it are unchanged.
- [ ] If I created a page → both `[name]_widget.dart` AND `[name]_model.dart` exist; widget exports the model.
- [ ] `static routeName` is PascalCase, `static routePath` is camelCase.
- [ ] If I added persisted state → key starts with `ff_`, getter/setter/`delete*()` all present, `_safeInitAsync` registered.
- [ ] If I added a Supabase table → file under `lib/backend/supabase/database/tables/`, `Table` + `Row` classes, `getField<T>`/`setField<T>`.
- [ ] No new dependency on Riverpod/Bloc/GetX/Firestore-for-data.
- [ ] `flutter_flow/` files (other than `custom_functions.dart`) untouched.
- [ ] If a recent commit was `Updating to latest FlutterFlow output.` → followed the post-sync checklist (diff + re-apply known recurring fixes from engram).

---

## Templates

Ready-to-copy skeletons live in [assets/templates/](assets/templates/):

- [custom_action_template.dart](assets/templates/custom_action_template.dart)
- [custom_widget_template.dart](assets/templates/custom_widget_template.dart)
- [page_widget_template.dart](assets/templates/page_widget_template.dart)
- [page_model_template.dart](assets/templates/page_model_template.dart)
- [supabase_table_template.dart](assets/templates/supabase_table_template.dart)

For the full project layout snapshot (counts, paths, key files): [references/architecture.md](references/architecture.md).
