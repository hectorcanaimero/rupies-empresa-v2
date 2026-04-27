import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'termos_page_model.dart';
export 'termos_page_model.dart';

class TermosPageWidget extends StatefulWidget {
  const TermosPageWidget({super.key});

  static String routeName = 'TermosPage';
  static String routePath = 'termosPage';

  @override
  State<TermosPageWidget> createState() => _TermosPageWidgetState();
}

class _TermosPageWidgetState extends State<TermosPageWidget> {
  late TermosPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermosPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'TermosPage'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsersRow>>(
      future: UsersTable().querySingleRow(
        queryFn: (q) => q.eqOrNull(
          'id',
          currentUserUid,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 40.0,
                height: 40.0,
                child: SpinKitPulse(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 40.0,
                ),
              ),
            ),
          );
        }
        List<UsersRow> termosPageUsersRowList = snapshot.data!;

        final termosPageUsersRow = termosPageUsersRowList.isNotEmpty
            ? termosPageUsersRowList.first
            : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  logFirebaseEvent('TERMOS_arrow_back_rounded_ICN_ON_TAP');
                  if (termosPageUsersRow!.termos! ||
                      termosPageUsersRow.privacidade!) {
                    logFirebaseEvent('IconButton_navigate_back');
                    context.pop();
                  } else {
                    logFirebaseEvent('IconButton_alert_dialog');
                    var confirmDialogResponse = await showDialog<bool>(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text('Opa!'),
                              content: Text(
                                  'Para continuar, debe aceitar o termos de uso e/ou a política de privacidade'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, false),
                                  child: Text('Voltar'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, true),
                                  child: Text('Não quero aceitar'),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;
                    if (confirmDialogResponse) {
                      logFirebaseEvent('IconButton_alert_dialog');
                      confirmDialogResponse = await showDialog<bool>(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('Fica de olho'),
                                content: Text('Vamos a deslogar sua conta?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                        alertDialogContext, false),
                                    child: Text(
                                        'Não vou aceitar os termos e/ou a política de privacidade'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext, true),
                                    child: Text('Sim'),
                                  ),
                                ],
                              );
                            },
                          ) ??
                          false;
                      if (confirmDialogResponse) {
                        logFirebaseEvent('IconButton_update_app_state');
                        FFAppState().deleteUser();
                        FFAppState().user = UserStruct();

                        FFAppState().deleteServiceId();
                        FFAppState().serviceId = '';

                        FFAppState().deleteLeadId();
                        FFAppState().leadId = '';

                        safeSetState(() {});
                        logFirebaseEvent('IconButton_auth');
                        GoRouter.of(context).prepareAuthEvent();
                        await authManager.signOut();
                        GoRouter.of(context).clearRedirectLocation();
                      }
                    }
                  }
                },
              ),
              title: Text(
                'Documentos',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(context)
                          .headlineMedium
                          .fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 28.0),
                      child: Text(
                        ' Li e Concordo com os Termos de Uso e Política de Privacidade do Aplicativo',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                  lineHeight: 1.5,
                                ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 18.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).alternate,
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue1 ??=
                                  termosPageUsersRow!.termos!,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue1 = newValue!);
                                if (newValue!) {
                                  logFirebaseEvent(
                                      'TERMOS_Checkbox_6whu0idt_ON_TOGGLE_ON');
                                  logFirebaseEvent('Checkbox_backend_call');
                                  await UsersTable().update(
                                    data: {
                                      'termos': true,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      termosPageUsersRow?.id,
                                    ),
                                  );
                                } else {
                                  logFirebaseEvent(
                                      'TERMOS_Checkbox_6whu0idt_ON_TOGGLE_OFF');
                                  logFirebaseEvent('Checkbox_backend_call');
                                  await UsersTable().update(
                                    data: {
                                      'termos': false,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      termosPageUsersRow?.id,
                                    ),
                                  );
                                }
                              },
                              side: (FlutterFlowTheme.of(context).alternate !=
                                      null)
                                  ? BorderSide(
                                      width: 2,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'TERMOS_PAGE_PAGE_Text_rjtck824_ON_TAP');
                                logFirebaseEvent('Text_launch_u_r_l');
                                await launchURL(
                                    'https://rupies.com.br/termos-de-uso-e-servico-da-rupies/#');
                              },
                              child: Text(
                                'Termos de uso do Aplicativo.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).alternate,
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue2 ??=
                                  termosPageUsersRow!.privacidade!,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue2 = newValue!);
                                if (newValue!) {
                                  logFirebaseEvent(
                                      'TERMOS_Checkbox_ryti3j9d_ON_TOGGLE_ON');
                                  logFirebaseEvent('Checkbox_backend_call');
                                  await UsersTable().update(
                                    data: {
                                      'privacidade': true,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      currentUserUid,
                                    ),
                                  );
                                } else {
                                  logFirebaseEvent(
                                      'TERMOS_Checkbox_ryti3j9d_ON_TOGGLE_OFF');
                                  logFirebaseEvent('Checkbox_backend_call');
                                  await UsersTable().update(
                                    data: {
                                      'privacidade': false,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'id',
                                      currentUserUid,
                                    ),
                                  );
                                }
                              },
                              side: (FlutterFlowTheme.of(context).alternate !=
                                      null)
                                  ? BorderSide(
                                      width: 2,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'TERMOS_PAGE_PAGE_Text_xxtpj8xw_ON_TAP');
                                logFirebaseEvent('Text_launch_u_r_l');
                                await launchURL(
                                    'https://rupies.com.br/politica-de-privacidade-da-rupies/');
                              },
                              child: Text(
                                'Política de Privacidade.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                  ]
                      .addToStart(SizedBox(height: 18.0))
                      .addToEnd(SizedBox(height: 24.0)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
