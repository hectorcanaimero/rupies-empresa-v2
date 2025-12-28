import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/banner_widget/banner_widget_widget.dart';
import '/widgets/card_accepted_widget/card_accepted_widget_widget.dart';
import '/widgets/card_openned_in_process_widget/card_openned_in_process_widget_widget.dart';
import '/widgets/menu_vertical_widget/menu_vertical_widget_widget.dart';
import '/widgets/nav_bar_widget/nav_bar_widget_widget.dart';
import '/widgets/user_widget/user_widget_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'HomePage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('HOME_PAGE_PAGE_HomePage_ON_INIT_STATE');
      await Future.wait([
        Future(() async {
          logFirebaseEvent('HomePage_backend_call');
          _model.profile = await UsersTable().queryRows(
            queryFn: (q) => q.eqOrNull(
              'id',
              currentUserUid,
            ),
          );
          if (_model.profile!.firstOrNull!.endRegister!) {
            logFirebaseEvent('HomePage_update_app_state');
            FFAppState().updateUserStruct(
              (e) => e..rating = _model.profile?.firstOrNull?.rating,
            );
            safeSetState(() {});
          } else {
            logFirebaseEvent('HomePage_navigate_to');

            context.goNamed(
              ProfilePageWidget.routeName,
              extra: <String, dynamic>{
                kTransitionInfoKey: TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.bottomToTop,
                ),
              },
            );
          }
        }),
        Future(() async {
          logFirebaseEvent('HomePage_custom_action');
          await actions.appReview(
            context,
          );
        }),
      ]);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            wrapWithModel(
                              model: _model.userWidgetModel,
                              updateCallback: () => safeSetState(() {}),
                              child: UserWidgetWidget(),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 15.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                child: wrapWithModel(
                                  model: _model.bannerWidgetModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: BannerWidgetWidget(
                                    position: 0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 18.0),
                                child: wrapWithModel(
                                  model: _model.menuVerticalWidgetModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: MenuVerticalWidgetWidget(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 9.0, 0.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Meus Serviços',
                                          style: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 20.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FutureBuilder<List<ViewServicesWithCategoriesRow>>(
                              future:
                                  ViewServicesWithCategoriesTable().queryRows(
                                queryFn: (q) => q
                                    .eqOrNull(
                                      'condition',
                                      Conditions.Accepted.name,
                                    )
                                    .eqOrNull(
                                      'userId',
                                      currentUserUid,
                                    )
                                    .order('created_at'),
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Color(0x004B39EF),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                List<ViewServicesWithCategoriesRow>
                                    listViewViewServicesWithCategoriesRowList =
                                    snapshot.data!;

                                return ListView.builder(
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    10.0,
                                    0,
                                    0,
                                  ),
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      listViewViewServicesWithCategoriesRowList
                                          .length,
                                  itemBuilder: (context, listViewIndex) {
                                    final listViewViewServicesWithCategoriesRow =
                                        listViewViewServicesWithCategoriesRowList[
                                            listViewIndex];
                                    return wrapWithModel(
                                      model: _model.cardAcceptedWidgetModels
                                          .getModel(
                                        listViewIndex.toString(),
                                        listViewIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: CardAcceptedWidgetWidget(
                                        key: Key(
                                          'Key7n1_${listViewIndex.toString()}',
                                        ),
                                        data:
                                            listViewViewServicesWithCategoriesRow,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            FutureBuilder<
                                List<ViewServicesWithCategoriesFilteredRow>>(
                              future: ViewServicesWithCategoriesFilteredTable()
                                  .queryRows(
                                queryFn: (q) => q
                                    .eqOrNull(
                                      'userId',
                                      currentUserUid,
                                    )
                                    .order('created_at'),
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Color(0x004B39EF),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                List<ViewServicesWithCategoriesFilteredRow>
                                    listViewFilteredViewServicesWithCategoriesFilteredRowList =
                                    snapshot.data!;

                                return ListView.builder(
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    0,
                                    48.0,
                                  ),
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      listViewFilteredViewServicesWithCategoriesFilteredRowList
                                          .length,
                                  itemBuilder:
                                      (context, listViewFilteredIndex) {
                                    final listViewFilteredViewServicesWithCategoriesFilteredRow =
                                        listViewFilteredViewServicesWithCategoriesFilteredRowList[
                                            listViewFilteredIndex];
                                    return wrapWithModel(
                                      model: _model
                                          .cardOpennedInProcessWidgetModels
                                          .getModel(
                                        listViewFilteredIndex.toString(),
                                        listViewFilteredIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: CardOpennedInProcessWidgetWidget(
                                        key: Key(
                                          'Keyi3n_${listViewFilteredIndex.toString()}',
                                        ),
                                        data:
                                            listViewFilteredViewServicesWithCategoriesFilteredRow,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ].addToStart(SizedBox(height: 12.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.navBarWidgetModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavBarWidgetWidget(
                    home: true,
                    jobs: false,
                    marketplace: false,
                    menu: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
