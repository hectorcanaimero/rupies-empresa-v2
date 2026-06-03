import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'termos_page_model.dart';
export 'termos_page_model.dart';

class TermosPageWidget extends StatefulWidget {
  const TermosPageWidget({super.key, this.from});

  final String? from;

  static String routeName = 'TermosPage';
  static String routePath = 'termosPage';

  @override
  State<TermosPageWidget> createState() => _TermosPageWidgetState();
}

class _TermosPageWidgetState extends State<TermosPageWidget> {
  late TermosPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// True when the page was opened from the menu (read-only mode):
  /// user already accepted and just wants to re-read the documents.
  /// Determined from the `from=menu` query parameter OR from the
  /// cached acceptance flags on `AppStateNotifier`.
  bool get _isReadOnlyMode {
    if (widget.from == 'menu') return true;
    final n = AppStateNotifier.instance;
    return n.termosAccepted == true && n.privacidadeAccepted == true;
  }

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

  Future<void> _onAcceptPressed() async {
    if (_model.isSubmitting) return;
    final uid = currentUserUid;
    if (uid.isEmpty) return;

    safeSetState(() => _model.isSubmitting = true);
    logFirebaseEvent('TERMOS_PAGE_aceitar_e_continuar_ON_TAP');

    try {
      logFirebaseEvent('AceitarContinuar_backend_call');
      await UsersTable().update(
        data: {
          'termos': true,
          'privacidade': true,
        },
        matchingRows: (rows) => rows.eqOrNull('id', uid),
      );

      // Update cached flags BEFORE navigating so the top-level redirect
      // doesn't bounce the user back to /termosPage.
      AppStateNotifier.instance
          .markAcceptance(termos: true, privacidade: true);

      if (!mounted) return;
      logFirebaseEvent('AceitarContinuar_navigate_to');
      context.goNamedAuth(HomePageWidget.routeName, context.mounted);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao salvar sua aceitação. Tente novamente.',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).info,
            ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        safeSetState(() => _model.isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final readOnly = _isReadOnlyMode;

    return PopScope(
      // When mandatory acceptance is pending, block the system back gesture
      // and the AppBar back button. The only way out is "Aceitar e Continuar".
      // In read-only mode (came from the menu), allow popping normally.
      canPop: readOnly,
      child: GestureDetector(
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
            leading: readOnly
                ? FlutterFlowIconButton(
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
                      context.safePop();
                    },
                  )
                : const SizedBox.shrink(),
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
            actions: const [],
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 18.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 28.0),
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
                  _DocumentLink(
                    label: 'Ler os Termos de Uso do Aplicativo',
                    url:
                        'https://rupies.com.br/termos-de-uso-e-servico-da-rupies/#',
                    logEvent: 'TERMOS_PAGE_PAGE_Text_rjtck824_ON_TAP',
                  ),
                  const SizedBox(height: 12.0),
                  _DocumentLink(
                    label: 'Ler a Política de Privacidade',
                    url:
                        'https://rupies.com.br/politica-de-privacidade-da-rupies/',
                    logEvent: 'TERMOS_PAGE_PAGE_Text_xxtpj8xw_ON_TAP',
                  ),
                  const Spacer(),
                  if (!readOnly)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 16.0, 0.0, 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: FFButtonWidget(
                          onPressed:
                              _model.isSubmitting ? null : _onAcceptPressed,
                          text: _model.isSubmitting
                              ? 'Aguarde...'
                              : 'Aceitar e Continuar',
                          options: FFButtonOptions(
                            height: 52.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 12.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(12.0),
                            disabledColor: FlutterFlowTheme.of(context)
                                .primary
                                .withValues(alpha: 0.6),
                            disabledTextColor:
                                FlutterFlowTheme.of(context).info,
                          ),
                        ),
                      ),
                    ),
                  if (!readOnly && _model.isSubmitting)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 8.0, 0.0, 8.0),
                      child: SizedBox(
                        width: 28.0,
                        height: 28.0,
                        child: SpinKitPulse(
                          color: FlutterFlowTheme.of(context).primary,
                          size: 28.0,
                        ),
                      ),
                    ),
                  if (readOnly)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 16.0, 0.0, 8.0),
                      child: Text(
                        'Já aceito ✓',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).success,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DocumentLink extends StatelessWidget {
  const _DocumentLink({
    required this.label,
    required this.url,
    required this.logEvent,
  });

  final String label;
  final String url;
  final String logEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () async {
          logFirebaseEvent(logEvent);
          logFirebaseEvent('Text_launch_u_r_l');
          await launchURL(url);
        },
        child: Padding(
          padding:
              const EdgeInsetsDirectional.fromSTEB(16.0, 14.0, 16.0, 14.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.description_outlined,
                color: FlutterFlowTheme.of(context).primary,
                size: 22.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontStyle: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
