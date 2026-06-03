import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/components/services_external_widget_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/services_refresh_notifier.dart';
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
import 'package:shimmer/shimmer.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = 'homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<(List<ViewServicesWithCategoriesRow>, Map<String, UsersRow>)>?
      _acceptedServicesWithContractorsFuture;
  Future<List<ViewServicesWithCategoriesFilteredRow>>? _filteredServicesFuture;

  void _loadServices() {
    final _uid = currentUserUid;
    _acceptedServicesWithContractorsFuture = _uid.isEmpty
        ? Future.value((<ViewServicesWithCategoriesRow>[], <String, UsersRow>{}))
        : ViewServicesWithCategoriesTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'condition',
                  Conditions.Accepted.name,
                )
                .eqOrNull(
                  'userId',
                  _uid,
                )
                .order('created_at'),
          ).then((services) async {
            final userIds = services
                .map((s) => s.userAproved)
                .whereType<String>()
                .toSet()
                .toList();
            if (userIds.isEmpty) {
              return (services, <String, UsersRow>{});
            }
            final contractorResults = await Future.wait(
              userIds.map(
                (id) => UsersTable().querySingleRow(
                  queryFn: (q) => q.eqOrNull('id', id),
                ),
              ),
            );
            return (
              services,
              <String, UsersRow>{
                for (int i = 0; i < userIds.length; i++)
                  if (contractorResults[i].isNotEmpty)
                    userIds[i]: contractorResults[i].first
              },
            );
          });
    _filteredServicesFuture = _uid.isEmpty
        ? Future.value(<ViewServicesWithCategoriesFilteredRow>[])
        : ViewServicesWithCategoriesFilteredTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'userId',
                  _uid,
                )
                .order('created_at'),
          );
  }

  void _refreshServices() {
    if (!mounted) return;
    safeSetState(_loadServices);
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    _loadServices();
    ServicesRefreshNotifier.instance.addListener(_refreshServices);

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'HomePage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('HOME_PAGE_PAGE_HomePage_ON_INIT_STATE');
      if (currentUserUid.isEmpty) return;
      await Future.wait([
        Future(() async {
          logFirebaseEvent('HomePage_backend_call');
          _model.profile = await UsersTable().queryRows(
            queryFn: (q) => q.eqOrNull(
              'id',
              currentUserUid,
            ),
          );
          final _userProfile = _model.profile?.firstOrNull;
          if (_userProfile != null &&
              _userProfile.endRegister == true) {
            logFirebaseEvent('HomePage_update_app_state');
            FFAppState().updateUserStruct(
              (e) => e
                ..rating = _userProfile.rating
                ..photoUrl = _userProfile.photoUrl,
            );
            FFAppState().trial = _userProfile.trial ?? 0;
            safeSetState(() {});
            return;
          } else {
            logFirebaseEvent('HomePage_navigate_to');

            context.goNamed(
              ProfilePageWidget.routeName,
              extra: <String, dynamic>{
                '__transition_info__': TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.bottomToTop,
                ),
              },
            );

            return;
          }
        }),
        Future(() async {
          logFirebaseEvent('HomePage_backend_call');
          _model.subs = await ViewSubsTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'user_id',
                  currentUserUid,
                )
                .eqOrNull(
                  'status',
                  'active',
                ),
          );
          logFirebaseEvent('HomePage_update_app_state');
          FFAppState().updateSubscriptionStruct(
            (e) => e
              ..status = _model.subs?.firstOrNull?.status
              ..typePlan = _model.subs?.firstOrNull?.spImage3
              ..id = _model.subs?.firstOrNull?.id
              ..planId = _model.subs?.firstOrNull?.planId
              ..creditsRemaining = _model.subs?.firstOrNull?.creditsRemaining
              ..creditsGranted = _model.subs?.firstOrNull?.creditsGranted
              ..isUnlimited = _model.subs?.firstOrNull?.cbIsUnlimited ??
                  _model.subs?.firstOrNull?.spIsUnlimited
              ..planType = _model.subs?.firstOrNull?.spPlanType,
          );
          safeSetState(() {});
        }),
        Future(() async {
          logFirebaseEvent('HomePage_backend_call');
          await UsersTable().update(
            data: {
              'fcm_token': FFAppState().fcmToken,
            },
            matchingRows: (rows) => rows.eqOrNull(
              'id',
              currentUserUid,
            ),
          );
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
    ServicesRefreshNotifier.instance.removeListener(_refreshServices);
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
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _loadServices();
                        safeSetState(() {});
                        await Future.wait([
                          _acceptedServicesWithContractorsFuture ?? Future.value(),
                          _filteredServicesFuture ?? Future.value(),
                        ]);
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: wrapWithModel(
                              model: _model.userWidgetModel,
                              updateCallback: () => safeSetState(() {}),
                              child: UserWidgetWidget(),
                            ),
                          ),
                          wrapWithModel(
                            model: _model.bannerWidgetModel,
                            updateCallback: () => safeSetState(() {}),
                            child: BannerWidgetWidget(
                              position: 0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 12.0),
                                child: wrapWithModel(
                                  model: _model.servicesExternalWidgetModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: ServicesExternalWidgetWidget(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 12.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(),
                              child: wrapWithModel(
                                model: _model.menuVerticalWidgetModel,
                                updateCallback: () => safeSetState(() {}),
                                child: MenuVerticalWidgetWidget(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 9.0, 12.0, 0.0),
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
                                                    FlutterFlowTheme.of(context)
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
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: FutureBuilder<
                                (List<ViewServicesWithCategoriesRow>,
                                    Map<String, UsersRow>)>(
                              future:
                                  _acceptedServicesWithContractorsFuture,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Shimmer.fromColors(
                                    baseColor: FlutterFlowTheme.of(context)
                                        .alternate,
                                    highlightColor:
                                        FlutterFlowTheme.of(context)
                                            .alternate
                                            .withValues(alpha: 0.4),
                                    child: Column(
                                      children: List.generate(
                                        2,
                                        (_) => Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 8.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                final (services, contractorMap) =
                                    snapshot.data!;

                                if (services.isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.work_outline_rounded,
                                          size: 48.0,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        SizedBox(height: 12.0),
                                        Text(
                                          'Nenhum serviço aceito ainda',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

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
                                  itemCount: services.length,
                                  itemBuilder: (context, listViewIndex) {
                                    final row = services[listViewIndex];
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
                                        data: row,
                                        contractor: contractorMap[
                                            row.userAproved ?? ''],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: FutureBuilder<
                                List<ViewServicesWithCategoriesFilteredRow>>(
                              future: _filteredServicesFuture,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Column(
                                    children: List.generate(
                                      2,
                                      (_) => Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 80.0,
                                          decoration: BoxDecoration(
                                            color:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                List<ViewServicesWithCategoriesFilteredRow>
                                    listViewFilteredViewServicesWithCategoriesFilteredRowList =
                                    snapshot.data!;

                                if (listViewFilteredViewServicesWithCategoriesFilteredRowList
                                    .isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.inbox_outlined,
                                          size: 48.0,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        SizedBox(height: 12.0),
                                        Text(
                                          'Nenhum serviço em aberto',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

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
