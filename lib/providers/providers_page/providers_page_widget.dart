import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/banner_widget/banner_widget_widget.dart';
import '/widgets/nav_bar_widget/nav_bar_widget_widget.dart';
import '/widgets/user_widget/user_widget_widget.dart';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers_page_model.dart';
export 'providers_page_model.dart';

class ProvidersPageWidget extends StatefulWidget {
  const ProvidersPageWidget({super.key});

  static String routeName = 'ProvidersPage';
  static String routePath = '/providersPage';

  @override
  State<ProvidersPageWidget> createState() => _ProvidersPageWidgetState();
}

class _ProvidersPageWidgetState extends State<ProvidersPageWidget>
    with TickerProviderStateMixin {
  late ProvidersPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProvidersPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'ProvidersPage'});
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

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
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      wrapWithModel(
                        model: _model.userWidgetModel,
                        updateCallback: () => safeSetState(() {}),
                        child: UserWidgetWidget(),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                        child: Container(
                          width: double.infinity,
                          height: 90.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: wrapWithModel(
                            model: _model.bannerWidgetModel,
                            updateCallback: () => safeSetState(() {}),
                            child: BannerWidgetWidget(
                              position: 1,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 100.0,
                          decoration: BoxDecoration(),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment(0.0, 0),
                                child: FlutterFlowButtonTabBar(
                                  useToggleButtonStyle: true,
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                  unselectedLabelStyle:
                                      FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                  labelColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  unselectedLabelColor:
                                      FlutterFlowTheme.of(context)
                                          .secondaryText,
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).tertiary,
                                  unselectedBackgroundColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  borderColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  unselectedBorderColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  borderWidth: 2.0,
                                  borderRadius: 8.0,
                                  elevation: 0.0,
                                  buttonMargin: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 8.0, 0.0),
                                  tabs: [
                                    Tab(
                                      text: 'VENDA',
                                    ),
                                    Tab(
                                      text: 'LOCAÇÃO',
                                    ),
                                  ],
                                  controller: _model.tabBarController,
                                  onTap: (i) async {
                                    [() async {}, () async {}][i]();
                                  },
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _model.tabBarController,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(),
                                      child:
                                          FutureBuilder<List<TypeProviderRow>>(
                                        future: TypeProviderTable().queryRows(
                                          queryFn: (q) => q
                                              .eqOrNull(
                                                'category',
                                                'Produtos para comprar',
                                              )
                                              .eqOrNull(
                                                'status',
                                                true,
                                              )
                                              .order('order', ascending: true),
                                        ),
                                        builder: (context, snapshot) {
                                          // Customize what your widget looks like when it's loading.
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          List<TypeProviderRow>
                                              staggeredComprarViewTypeProviderRowList =
                                              snapshot.data!;

                                          return MasonryGridView.builder(
                                            gridDelegate:
                                                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                            ),
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                            itemCount:
                                                staggeredComprarViewTypeProviderRowList
                                                    .length,
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              12.0,
                                              0,
                                              100.0,
                                            ),
                                            shrinkWrap: true,
                                            itemBuilder: (context,
                                                staggeredComprarViewIndex) {
                                              final staggeredComprarViewTypeProviderRow =
                                                  staggeredComprarViewTypeProviderRowList[
                                                      staggeredComprarViewIndex];
                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  logFirebaseEvent(
                                                      'PROVIDERS_Container_jdu1vtbf_ON_TAP');
                                                  logFirebaseEvent(
                                                      'Container_navigate_to');

                                                  context.pushNamed(
                                                    ProviderIdPageWidget
                                                        .routeName,
                                                    queryParameters: {
                                                      'uid': serializeParam(
                                                        staggeredComprarViewTypeProviderRow
                                                            .id,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: Container(
                                                  height: 90.0,
                                                  decoration: BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.network(
                                                          valueOrDefault<
                                                              String>(
                                                            staggeredComprarViewTypeProviderRow
                                                                .icon,
                                                            'https://images.unsplash.com/reserve/oIpwxeeSPy1cnwYpqJ1w_Dufer%20Collateral%20test.jpg?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw3fHx0b29sc3xlbnwwfHx8fDE3NDcxMTgzNTd8MA&ixlib=rb-4.1.0&q=80&w=400',
                                                          ),
                                                          width: 60.0,
                                                          height: 60.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          staggeredComprarViewTypeProviderRow
                                                              .name,
                                                          'name',
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(),
                                      child:
                                          FutureBuilder<List<TypeProviderRow>>(
                                        future: TypeProviderTable().queryRows(
                                          queryFn: (q) => q
                                              .eqOrNull(
                                                'status',
                                                true,
                                              )
                                              .eqOrNull(
                                                'category',
                                                'Produtos para Locação',
                                              )
                                              .order('order', ascending: true),
                                        ),
                                        builder: (context, snapshot) {
                                          // Customize what your widget looks like when it's loading.
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          List<TypeProviderRow>
                                              staggeredLocacaoViewTypeProviderRowList =
                                              snapshot.data!;

                                          return MasonryGridView.builder(
                                            gridDelegate:
                                                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                            ),
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                            itemCount:
                                                staggeredLocacaoViewTypeProviderRowList
                                                    .length,
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              12.0,
                                              0,
                                              100.0,
                                            ),
                                            shrinkWrap: true,
                                            itemBuilder: (context,
                                                staggeredLocacaoViewIndex) {
                                              final staggeredLocacaoViewTypeProviderRow =
                                                  staggeredLocacaoViewTypeProviderRowList[
                                                      staggeredLocacaoViewIndex];
                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  logFirebaseEvent(
                                                      'PROVIDERS_Container_3ty3mn8m_ON_TAP');
                                                  logFirebaseEvent(
                                                      'Container_navigate_to');

                                                  context.pushNamed(
                                                    ProviderIdPageWidget
                                                        .routeName,
                                                    queryParameters: {
                                                      'uid': serializeParam(
                                                        staggeredLocacaoViewTypeProviderRow
                                                            .id,
                                                        ParamType.String,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: Container(
                                                  height: 90.0,
                                                  decoration: BoxDecoration(),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.network(
                                                          valueOrDefault<
                                                              String>(
                                                            staggeredLocacaoViewTypeProviderRow
                                                                .icon,
                                                            'https://images.unsplash.com/reserve/oIpwxeeSPy1cnwYpqJ1w_Dufer%20Collateral%20test.jpg?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw3fHx0b29sc3xlbnwwfHx8fDE3NDcxMTgzNTd8MA&ixlib=rb-4.1.0&q=80&w=400',
                                                          ),
                                                          width: 60.0,
                                                          height: 60.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Text(
                                                        valueOrDefault<String>(
                                                          staggeredLocacaoViewTypeProviderRow
                                                              .name,
                                                          'name',
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                              ),
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .fontStyle,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ].addToStart(SizedBox(height: 15.0)),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Container(
                  height: 70.0,
                  decoration: BoxDecoration(),
                  child: wrapWithModel(
                    model: _model.navBarWidgetModel,
                    updateCallback: () => safeSetState(() {}),
                    child: NavBarWidgetWidget(
                      home: false,
                      jobs: false,
                      marketplace: false,
                      menu: false,
                      lead: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
