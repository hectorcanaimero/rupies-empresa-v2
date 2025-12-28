import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/providers/provider_gold_widget/provider_gold_widget_widget.dart';
import '/providers/provider_premium_widget/provider_premium_widget_widget.dart';
import '/providers/provider_silver_widget/provider_silver_widget_widget.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'provider_id_page_model.dart';
export 'provider_id_page_model.dart';

class ProviderIdPageWidget extends StatefulWidget {
  const ProviderIdPageWidget({
    super.key,
    required this.uid,
  });

  final String? uid;

  static String routeName = 'ProviderIdPage';
  static String routePath = '/providerIdPage';

  @override
  State<ProviderIdPageWidget> createState() => _ProviderIdPageWidgetState();
}

class _ProviderIdPageWidgetState extends State<ProviderIdPageWidget> {
  late ProviderIdPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProviderIdPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'ProviderIdPage'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 30.0,
            ),
            onPressed: () async {
              logFirebaseEvent('PROVIDER_ID_arrow_back_rounded_ICN_ON_TA');
              logFirebaseEvent('IconButton_navigate_back');
              context.pop();
            },
          ),
          title: Text(
            'Fornecedores',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
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
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: FutureBuilder<List<ProvidersRow>>(
                    future: ProvidersTable().queryRows(
                      queryFn: (q) => q
                          .eqOrNull(
                            'type',
                            widget.uid,
                          )
                          .eqOrNull(
                            'status',
                            true,
                          )
                          .order('select', ascending: true)
                          .order('order', ascending: true),
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }
                      List<ProvidersRow> listViewProvidersRowList =
                          snapshot.data!;

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listViewProvidersRowList.length,
                        itemBuilder: (context, listViewIndex) {
                          final listViewProvidersRow =
                              listViewProvidersRowList[listViewIndex];
                          return Builder(
                            builder: (context) {
                              if (listViewProvidersRow.select ==
                                  TypeProvider.first.name) {
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 15.0),
                                  child: wrapWithModel(
                                    model: _model.providerPremiumWidgetModels
                                        .getModel(
                                      listViewIndex.toString(),
                                      listViewIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: ProviderPremiumWidgetWidget(
                                      key: Key(
                                        'Keyqnd_${listViewIndex.toString()}',
                                      ),
                                      data: listViewProvidersRow,
                                    ),
                                  ),
                                );
                              } else if (listViewProvidersRow.select ==
                                  TypeProvider.second.name) {
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 15.0),
                                  child: wrapWithModel(
                                    model: _model.providerGoldWidgetModels
                                        .getModel(
                                      listViewIndex.toString(),
                                      listViewIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: ProviderGoldWidgetWidget(
                                      key: Key(
                                        'Keykik_${listViewIndex.toString()}',
                                      ),
                                      data: listViewProvidersRow,
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 15.0),
                                  child: wrapWithModel(
                                    model: _model.providerSilverWidgetModels
                                        .getModel(
                                      listViewIndex.toString(),
                                      listViewIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: ProviderSilverWidgetWidget(
                                      key: Key(
                                        'Key74g_${listViewIndex.toString()}',
                                      ),
                                      data: listViewProvidersRow,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ].addToStart(SizedBox(height: 15.0)),
            ),
          ),
        ),
      ),
    );
  }
}
