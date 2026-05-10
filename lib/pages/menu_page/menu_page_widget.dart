import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/nav_bar_widget/nav_bar_widget_widget.dart';
import '/widgets/user_widget/user_widget_widget.dart';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'menu_page_model.dart';
export 'menu_page_model.dart';

class MenuPageWidget extends StatefulWidget {
  const MenuPageWidget({super.key});

  static String routeName = 'MenuPage';
  static String routePath = 'menuPage';

  @override
  State<MenuPageWidget> createState() => _MenuPageWidgetState();
}

class _MenuPageWidgetState extends State<MenuPageWidget> {
  late MenuPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuPageModel());
    logFirebaseEvent('screen_view', parameters: {'screen_name': 'MenuPage'});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    logFirebaseEvent('MENU_PAGE_PAGE_Row_nkra97ug_ON_TAP');
    logFirebaseEvent('Row_alert_dialog');

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (alertDialogContext) => AlertDialog(
            title: const Text('Opa!'),
            content: const Text('Tem certeza que quer sair?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext, false),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext, true),
                child: const Text('Sim'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    logFirebaseEvent('Row_update_app_state');
    FFAppState().deleteUser();
    FFAppState().user = UserStruct();
    FFAppState().deleteServiceId();
    FFAppState().serviceId = '';
    FFAppState().deleteLeadId();
    FFAppState().leadId = '';
    safeSetState(() {});

    logFirebaseEvent('Row_auth');
    GoRouter.of(context).prepareAuthEvent();
    await authManager.signOut();
    GoRouter.of(context).clearRedirectLocation();

    if (context.mounted) {
      context.goNamedAuth(SignPageWidget.routeName, context.mounted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      12.0, 0.0, 12.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 15.0),
                        wrapWithModel(
                          model: _model.userWidgetModel,
                          updateCallback: () => safeSetState(() {}),
                          child: UserWidgetWidget(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0, bottom: 100.0),
                          child: Column(
                            children: [
                              _MenuItem(
                                icon: Icon(
                                  Icons.person,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                label: 'Perfil',
                                onTap: () {
                                  logFirebaseEvent(
                                      'MENU_PAGE_PAGE_Row_8kcv31p9_ON_TAP');
                                  logFirebaseEvent('Row_navigate_to');
                                  context.pushNamed(
                                      ProfilePageWidget.routeName);
                                },
                              ),
                              _MenuItem(
                                icon: Icon(
                                  Icons.star_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                label: 'Minhas Avaliações',
                                onTap: () {
                                  logFirebaseEvent(
                                      'MENU_PAGE_PAGE_Row_rpdhcmjs_ON_TAP');
                                  logFirebaseEvent('Row_navigate_to');
                                  context.pushNamed(
                                      MinhaAvaliacaoPageWidget.routeName);
                                },
                              ),
                              _MenuItem(
                                icon: Icon(
                                  Icons.design_services_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                label: 'Serviços',
                                onTap: () {
                                  logFirebaseEvent(
                                      'MENU_PAGE_PAGE_Row_izafoy8e_ON_TAP');
                                  logFirebaseEvent('Row_navigate_to');
                                  context.pushNamed(
                                      AppointmentPageWidget.routeName);
                                },
                              ),
                              _MenuItem(
                                icon: Icon(
                                  // request_quote comunica mejor "cotización"
                                  Icons.request_quote_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                label: 'Cotação',
                                onTap: () {
                                  logFirebaseEvent(
                                      'MENU_PAGE_PAGE_Row_e7owiwof_ON_TAP');
                                  logFirebaseEvent('Row_navigate_to');
                                  context
                                      .pushNamed(LeadPageWidget.routeName);
                                },
                              ),
                              _MenuItem(
                                icon: Icon(
                                  // business comunica mejor "proveedores" que compressAlt
                                  Icons.business_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                label: 'Fornecedores',
                                onTap: () {
                                  logFirebaseEvent(
                                      'MENU_PAGE_PAGE_Row_32d8cdj4_ON_TAP');
                                  logFirebaseEvent('Row_navigate_to');
                                  context.pushNamed(
                                      ProvidersPageWidget.routeName);
                                },
                              ),
                              // Future cached en el model — no re-fetches en cada rebuild
                              FutureBuilder<List<SettingsRow>>(
                                future: _model.subscriptionSettingFuture,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    // Sin spinner — no hay layout shift
                                    return const SizedBox.shrink();
                                  }
                                  final row = snapshot.data!.isNotEmpty
                                      ? snapshot.data!.first
                                      : null;
                                  // Mismo comportamiento que el original: sin row → visible
                                  final visible = row?.active ?? true;
                                  if (!visible) return const SizedBox.shrink();
                                  return _MenuItem(
                                    icon: Icon(
                                      Icons.nature,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24.0,
                                    ),
                                    label: 'Clube dos 100',
                                    onTap: () {
                                      logFirebaseEvent(
                                          'MENU_PAGE_PAGE_Row_5kybd4qj_ON_TAP');
                                      logFirebaseEvent('Row_navigate_to');
                                      context.pushNamed(
                                          SubscriptionPlansPageWidget.routeName);
                                    },
                                  );
                                },
                              ),
                              _MenuItem(
                                icon: Icon(
                                  Icons.support_agent_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                label: 'Fale Conosco',
                                onTap: () {
                                  logFirebaseEvent(
                                      'MENU_PAGE_PAGE_Row_rsda88p1_ON_TAP');
                                  logFirebaseEvent('Row_launch_u_r_l');
                                  launchURL(
                                      'https://api.whatsapp.com/send/?phone=%2B5511965939170&text&type=phone_number&app_absent=0');
                                },
                              ),
                              _MenuItem(
                                icon: Icon(
                                  Icons.document_scanner_outlined,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                label: 'Termos de uso/Política de privacidade',
                                onTap: () {
                                  logFirebaseEvent(
                                      'MENU_PAGE_PAGE_Row_zs3b4nw8_ON_TAP');
                                  logFirebaseEvent('Row_navigate_to');
                                  context
                                      .pushNamed(TermosPageWidget.routeName);
                                },
                              ),
                              _MenuItem(
                                icon: Icon(
                                  Icons.logout_rounded,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                label: 'Sair do Sistema',
                                onTap: () => _handleLogout(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.navBarWidgetModel,
                updateCallback: () => safeSetState(() {}),
                child: NavBarWidgetWidget(
                  home: false,
                  jobs: false,
                  marketplace: false,
                  menu: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Item de menú reutilizable. Reemplaza el patrón repetido de InkWell+Row+Divider
/// que antes se copiaba ~8 veces con ~50 líneas cada uno.
class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            // Feedback visual sutil — antes todos los colores eran transparent
            splashColor:
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.08),
            highlightColor:
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(4.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  icon,
                  const SizedBox(width: 9.0),
                  Expanded(
                    child: Text(
                      label,
                      style: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .copyWith(letterSpacing: 0.0),
                    ),
                  ),
                  // Chevron — indica que el item es navegable
                  Icon(
                    Icons.chevron_right_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2.0,
            color: FlutterFlowTheme.of(context).alternate,
          ),
        ],
      ),
    );
  }
}
