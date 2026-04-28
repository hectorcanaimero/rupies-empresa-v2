---
description: Activates the FlutterFlow conventions skill for ru-empresa
---

Cargá el skill `flutterflow` (`.claude/skills/flutterflow/SKILL.md`) y aplicá sus reglas durante el resto de esta conversación.

Confirmá brevemente al usuario:
- Stack detectado (Supabase + Firebase analytics + Provider + GoRouter + FlutterFlowTheme)
- Las 5 reglas críticas que vas a respetar (barreras de custom_code, Widget+Model pareado, `flutter_flow/` read-only excepto `custom_functions.dart`, Supabase = data / Firebase = analytics, FFAppState con prefijo `ff_`)
- En qué archivo / área quiere trabajar el usuario

Después esperá la próxima instrucción.
