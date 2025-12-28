import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'provider_silver_widget_model.dart';
export 'provider_silver_widget_model.dart';

class ProviderSilverWidgetWidget extends StatefulWidget {
  const ProviderSilverWidgetWidget({
    super.key,
    required this.data,
  });

  final ProvidersRow? data;

  @override
  State<ProviderSilverWidgetWidget> createState() =>
      _ProviderSilverWidgetWidgetState();
}

class _ProviderSilverWidgetWidgetState
    extends State<ProviderSilverWidgetWidget> {
  late ProviderSilverWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProviderSilverWidgetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.0,
      constraints: BoxConstraints(
        minHeight: 60.0,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(9.0),
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            logFirebaseEvent('PROVIDER_SILVER_WIDGET_Row_j17etpt0_ON_T');
            logFirebaseEvent('Row_launch_u_r_l');
            await launchURL(widget.data!.wa!);
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(),
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Text(
                      valueOrDefault<String>(
                        widget.data?.name,
                        'Nome da Empresa',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
              ),
              FlutterFlowIconButton(
                borderRadius: 25.0,
                buttonSize: 40.0,
                fillColor: Color(0xFF25D366),
                icon: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: FlutterFlowTheme.of(context).info,
                  size: 24.0,
                ),
                onPressed: () async {
                  logFirebaseEvent('PROVIDER_SILVER_WIDGET_whatsapp_ICN_ON_T');
                  logFirebaseEvent('IconButton_launch_u_r_l');
                  await launchURL(widget.data!.wa!);
                },
              ),
            ].divide(SizedBox(width: 9.0)),
          ),
        ),
      ),
    );
  }
}
