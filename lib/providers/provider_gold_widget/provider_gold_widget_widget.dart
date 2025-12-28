import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'provider_gold_widget_model.dart';
export 'provider_gold_widget_model.dart';

class ProviderGoldWidgetWidget extends StatefulWidget {
  const ProviderGoldWidgetWidget({
    super.key,
    required this.data,
  });

  final ProvidersRow? data;

  @override
  State<ProviderGoldWidgetWidget> createState() =>
      _ProviderGoldWidgetWidgetState();
}

class _ProviderGoldWidgetWidgetState extends State<ProviderGoldWidgetWidget> {
  late ProviderGoldWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProviderGoldWidgetModel());

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
      height: 120.0,
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
            logFirebaseEvent('PROVIDER_GOLD_WIDGET_Row_9oidk19y_ON_TAP');
            logFirebaseEvent('Row_launch_u_r_l');
            await launchURL(widget.data!.wa!);
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 500),
                  fadeOutDuration: Duration(milliseconds: 500),
                  imageUrl: valueOrDefault<String>(
                    widget.data?.logo,
                    'https://picsum.photos/seed/951/600',
                  ),
                  width: 100.0,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: Text(
                          valueOrDefault<String>(
                            widget.data?.name,
                            'Nome da Empresa',
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      ),
                      Divider(
                        thickness: 2.0,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            children: [
                              if (widget.data?.wa != null &&
                                  widget.data?.wa != '')
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 9.0, 0.0),
                                  child: FlutterFlowIconButton(
                                    borderRadius: 25.0,
                                    buttonSize: 40.0,
                                    fillColor: Color(0xFF25D366),
                                    icon: FaIcon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'PROVIDER_GOLD_WIDGET_COMP_Whats_ON_TAP');
                                      logFirebaseEvent('Whats_launch_u_r_l');
                                      await launchURL(widget.data!.wa!);
                                    },
                                  ),
                                ),
                              if (widget.data?.fb != null &&
                                  widget.data?.fb != '')
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 9.0, 0.0),
                                  child: FlutterFlowIconButton(
                                    borderRadius: 25.0,
                                    buttonSize: 40.0,
                                    fillColor: Color(0xFF4267B2),
                                    icon: FaIcon(
                                      FontAwesomeIcons.facebookF,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 21.0,
                                    ),
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'PROVIDER_GOLD_WIDGET_COMP_FB_ON_TAP');
                                      logFirebaseEvent('FB_launch_u_r_l');
                                      await launchURL(widget.data!.fb!);
                                    },
                                  ),
                                ),
                              if (widget.data?.ig != null &&
                                  widget.data?.ig != '')
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 9.0, 0.0),
                                  child: FlutterFlowIconButton(
                                    borderRadius: 25.0,
                                    buttonSize: 40.0,
                                    fillColor: Color(0xFFE1306C),
                                    icon: FaIcon(
                                      FontAwesomeIcons.instagram,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'PROVIDER_GOLD_WIDGET_COMP_IG_ON_TAP');
                                      logFirebaseEvent('IG_launch_u_r_l');
                                      await launchURL(widget.data!.ig!);
                                    },
                                  ),
                                ),
                              if (widget.data?.web != null &&
                                  widget.data?.web != '')
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 9.0, 0.0),
                                  child: FlutterFlowIconButton(
                                    borderRadius: 25.0,
                                    buttonSize: 40.0,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    icon: Icon(
                                      Icons.web_asset_rounded,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      logFirebaseEvent(
                                          'PROVIDER_GOLD_WIDGET_COMP_WWW_ON_TAP');
                                      logFirebaseEvent('WWW_launch_u_r_l');
                                      await launchURL(widget.data!.web!);
                                    },
                                  ),
                                ),
                              if (widget.data?.phone != null &&
                                  widget.data?.phone != '')
                                FlutterFlowIconButton(
                                  borderColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  borderRadius: 25.0,
                                  borderWidth: 1.0,
                                  buttonSize: 40.0,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  icon: Icon(
                                    Icons.call_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    logFirebaseEvent(
                                        'PROVIDER_GOLD_WIDGET_COMP_PHONE_ON_TAP');
                                    if (!isWeb) {
                                      logFirebaseEvent('PHONE_call_number');
                                      await launchUrl(Uri(
                                        scheme: 'tel',
                                        path: widget.data!.phone!,
                                      ));
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ].divide(SizedBox(width: 9.0)),
          ),
        ),
      ),
    );
  }
}
