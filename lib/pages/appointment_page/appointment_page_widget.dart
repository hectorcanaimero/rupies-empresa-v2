import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/card_accepted_widget/card_accepted_widget_widget.dart';
import '/widgets/card_openned_in_process_widget/card_openned_in_process_widget_widget.dart';
import '/widgets/load_widget/load_widget_widget.dart';
import '/widgets/nav_bar_widget/nav_bar_widget_widget.dart';
import '/widgets/user_widget/user_widget_widget.dart';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'appointment_page_model.dart';
export 'appointment_page_model.dart';

class AppointmentPageWidget extends StatefulWidget {
  const AppointmentPageWidget({super.key});

  static String routeName = 'AppointmentPage';
  static String routePath = '/appointmentPage';

  @override
  State<AppointmentPageWidget> createState() => _AppointmentPageWidgetState();
}

class _AppointmentPageWidgetState extends State<AppointmentPageWidget>
    with TickerProviderStateMixin {
  late AppointmentPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppointmentPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'AppointmentPage'});
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
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
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(),
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
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 100.0,
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment(0.0, 0),
                                  child: TabBar(
                                    isScrollable: true,
                                    labelColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    unselectedLabelColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                    unselectedLabelStyle: TextStyle(),
                                    indicatorColor: Color(0xFFFFA500),
                                    padding: EdgeInsets.all(4.0),
                                    tabs: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 6.0, 0.0),
                                            child: Icon(
                                              Icons.timer_sharp,
                                              size: 22.0,
                                            ),
                                          ),
                                          Tab(
                                            text: 'Em Processo',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 6.0, 0.0),
                                            child: Icon(
                                              Icons.work_history_sharp,
                                              size: 22.0,
                                            ),
                                          ),
                                          Tab(
                                            text: 'Aceitos',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 6.0, 0.0),
                                            child: Icon(
                                              Icons.check_circle_sharp,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              size: 22.0,
                                            ),
                                          ),
                                          Tab(
                                            text: 'Finalizados',
                                          ),
                                        ],
                                      ),
                                    ],
                                    controller: _model.tabBarController,
                                    onTap: (i) async {
                                      [
                                        () async {},
                                        () async {},
                                        () async {}
                                      ][i]();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _model.tabBarController,
                                    children: [
                                      FutureBuilder<
                                          List<
                                              ViewServicesWithCategoriesFilteredRow>>(
                                        future:
                                            ViewServicesWithCategoriesFilteredTable()
                                                .queryRows(
                                          queryFn: (q) => q
                                              .eqOrNull(
                                                'condition',
                                                Conditions.InProcess.name,
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
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    Color(0x004B39EF),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          List<ViewServicesWithCategoriesFilteredRow>
                                              listViewViewServicesWithCategoriesFilteredRowList =
                                              snapshot.data!;

                                          if (listViewViewServicesWithCategoriesFilteredRowList
                                              .isEmpty) {
                                            return LoadWidgetWidget(
                                              height: 300.0,
                                            );
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              15.0,
                                              0,
                                              30.0,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                listViewViewServicesWithCategoriesFilteredRowList
                                                    .length,
                                            itemBuilder:
                                                (context, listViewIndex) {
                                              final listViewViewServicesWithCategoriesFilteredRow =
                                                  listViewViewServicesWithCategoriesFilteredRowList[
                                                      listViewIndex];
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 0.0, 12.0, 0.0),
                                                child: wrapWithModel(
                                                  model: _model
                                                      .cardOpennedInProcessWidgetModels
                                                      .getModel(
                                                    listViewIndex.toString(),
                                                    listViewIndex,
                                                  ),
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child:
                                                      CardOpennedInProcessWidgetWidget(
                                                    key: Key(
                                                      'Keyhfr_${listViewIndex.toString()}',
                                                    ),
                                                    data:
                                                        listViewViewServicesWithCategoriesFilteredRow,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      FutureBuilder<
                                          List<ViewServicesWithCategoriesRow>>(
                                        future:
                                            ViewServicesWithCategoriesTable()
                                                .queryRows(
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
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    Color(0x004B39EF),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          List<ViewServicesWithCategoriesRow>
                                              listViewViewServicesWithCategoriesRowList =
                                              snapshot.data!;

                                          if (listViewViewServicesWithCategoriesRowList
                                              .isEmpty) {
                                            return LoadWidgetWidget(
                                              height: 300.0,
                                            );
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              15.0,
                                              0,
                                              30.0,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                listViewViewServicesWithCategoriesRowList
                                                    .length,
                                            itemBuilder:
                                                (context, listViewIndex) {
                                              final listViewViewServicesWithCategoriesRow =
                                                  listViewViewServicesWithCategoriesRowList[
                                                      listViewIndex];
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 0.0, 12.0, 0.0),
                                                child: wrapWithModel(
                                                  model: _model
                                                      .cardAcceptedWidgetModels
                                                      .getModel(
                                                    listViewIndex.toString(),
                                                    listViewIndex,
                                                  ),
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child:
                                                      CardAcceptedWidgetWidget(
                                                    key: Key(
                                                      'Keyujv_${listViewIndex.toString()}',
                                                    ),
                                                    data:
                                                        listViewViewServicesWithCategoriesRow,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 12.0, 0.0, 0.0),
                                                child: Text(
                                                  'Serviços Concluidos',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmall
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: FutureBuilder<
                                                  List<
                                                      ViewServicesWithCategoriesRow>>(
                                                future:
                                                    ViewServicesWithCategoriesTable()
                                                        .queryRows(
                                                  queryFn: (q) => q
                                                      .eqOrNull(
                                                        'userId',
                                                        currentUserUid,
                                                      )
                                                      .eqOrNull(
                                                        'condition',
                                                        Conditions
                                                            .Finished.name,
                                                      ),
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
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<ViewServicesWithCategoriesRow>
                                                      listViewViewServicesWithCategoriesRowList =
                                                      snapshot.data!;

                                                  if (listViewViewServicesWithCategoriesRowList
                                                      .isEmpty) {
                                                    return Center(
                                                      child: LoadWidgetWidget(
                                                        height: 300.0,
                                                      ),
                                                    );
                                                  }

                                                  return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    primary: false,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        listViewViewServicesWithCategoriesRowList
                                                            .length,
                                                    itemBuilder: (context,
                                                        listViewIndex) {
                                                      final listViewViewServicesWithCategoriesRow =
                                                          listViewViewServicesWithCategoriesRowList[
                                                              listViewIndex];
                                                      return Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    15.0),
                                                        child: Material(
                                                          color: Colors
                                                              .transparent,
                                                          elevation: 0.0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9.0),
                                                          ),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          9.0),
                                                              border:
                                                                  Border.all(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          15.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -1.0,
                                                                            0.0),
                                                                    child:
                                                                        InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        logFirebaseEvent(
                                                                            'APPOINTMENT_Container_g16u9dme_ON_TAP');
                                                                        logFirebaseEvent(
                                                                            'Container_navigate_to');

                                                                        context
                                                                            .pushNamed(
                                                                          ServiceIdPageWidget
                                                                              .routeName,
                                                                          queryParameters:
                                                                              {
                                                                            'uid':
                                                                                serializeParam(
                                                                              listViewViewServicesWithCategoriesRow.id,
                                                                              ParamType.String,
                                                                            ),
                                                                          }.withoutNulls,
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                                                                                        child: Text(
                                                                                          valueOrDefault<String>(
                                                                                            listViewViewServicesWithCategoriesRow.name,
                                                                                            'name',
                                                                                          ),
                                                                                          maxLines: 2,
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                font: GoogleFonts.urbanist(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                ),
                                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                                fontSize: 16.0,
                                                                                                letterSpacing: 0.0,
                                                                                                fontWeight: FontWeight.bold,
                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                                                                                        child: RichText(
                                                                                          textScaler: MediaQuery.of(context).textScaler,
                                                                                          text: TextSpan(
                                                                                            children: [
                                                                                              TextSpan(
                                                                                                text: valueOrDefault<String>(
                                                                                                  listViewViewServicesWithCategoriesRow.jobType,
                                                                                                  'Job',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      fontSize: 13.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                              TextSpan(
                                                                                                text: '/Categoria: ',
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                              TextSpan(
                                                                                                text: valueOrDefault<String>(
                                                                                                  listViewViewServicesWithCategoriesRow.categoryName,
                                                                                                  'categoria',
                                                                                                ),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FontWeight.w300,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      fontSize: 13.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.w300,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              )
                                                                                            ],
                                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                  font: GoogleFonts.inter(
                                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                  ),
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                                                                                        child: FutureBuilder<List<UsersRow>>(
                                                                                          future: UsersTable().querySingleRow(
                                                                                            queryFn: (q) => q.eqOrNull(
                                                                                              'id',
                                                                                              listViewViewServicesWithCategoriesRow.userAproved,
                                                                                            ),
                                                                                          ),
                                                                                          builder: (context, snapshot) {
                                                                                            // Customize what your widget looks like when it's loading.
                                                                                            if (!snapshot.hasData) {
                                                                                              return Center(
                                                                                                child: SizedBox(
                                                                                                  width: 40.0,
                                                                                                  height: 40.0,
                                                                                                  child: CircularProgressIndicator(
                                                                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                                                                      Color(0x004B39EF),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            }
                                                                                            List<UsersRow> richTextUsersRowList = snapshot.data!;

                                                                                            final richTextUsersRow = richTextUsersRowList.isNotEmpty ? richTextUsersRowList.first : null;

                                                                                            return RichText(
                                                                                              textScaler: MediaQuery.of(context).textScaler,
                                                                                              text: TextSpan(
                                                                                                children: [
                                                                                                  TextSpan(
                                                                                                    text: 'Prestador: ',
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          font: GoogleFonts.inter(
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                          fontSize: 13.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.bold,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                        ),
                                                                                                  ),
                                                                                                  TextSpan(
                                                                                                    text: valueOrDefault<String>(
                                                                                                      richTextUsersRow?.displayName,
                                                                                                      'Prestador.',
                                                                                                    ),
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                          font: GoogleFonts.inter(
                                                                                                            fontWeight: FontWeight.w300,
                                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                          fontSize: 13.0,
                                                                                                          letterSpacing: 0.0,
                                                                                                          fontWeight: FontWeight.w300,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                        ),
                                                                                                  )
                                                                                                ],
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      font: GoogleFonts.inter(
                                                                                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                    ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Row(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                children: [
                                                                                                  Icon(
                                                                                                    Icons.calendar_month,
                                                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                                                    size: 24.0,
                                                                                                  ),
                                                                                                  RichText(
                                                                                                    textScaler: MediaQuery.of(context).textScaler,
                                                                                                    text: TextSpan(
                                                                                                      children: [
                                                                                                        TextSpan(
                                                                                                          text: dateTimeFormat(
                                                                                                            "d/M/y",
                                                                                                            listViewViewServicesWithCategoriesRow.dateStart!,
                                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                                          ),
                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                font: GoogleFonts.inter(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 13.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                        TextSpan(
                                                                                                          text: ' - ',
                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                font: GoogleFonts.inter(
                                                                                                                  fontWeight: FontWeight.bold,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                ),
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                              ),
                                                                                                        ),
                                                                                                        TextSpan(
                                                                                                          text: dateTimeFormat(
                                                                                                            "d/M/y",
                                                                                                            listViewViewServicesWithCategoriesRow.dateEnd!,
                                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                                          ),
                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                                font: GoogleFonts.inter(
                                                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                                ),
                                                                                                                fontSize: 13.0,
                                                                                                                letterSpacing: 0.0,
                                                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                              ),
                                                                                                        )
                                                                                                      ],
                                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                            font: GoogleFonts.inter(
                                                                                                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                            ),
                                                                                                            letterSpacing: 0.0,
                                                                                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                          ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ].divide(SizedBox(width: 6.0)),
                                                                                              ),
                                                                                            ),
                                                                                            Row(
                                                                                              mainAxisSize: MainAxisSize.max,
                                                                                              children: [
                                                                                                FaIcon(
                                                                                                  FontAwesomeIcons.clock,
                                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                  size: 18.0,
                                                                                                ),
                                                                                                Text(
                                                                                                  valueOrDefault<String>(
                                                                                                    listViewViewServicesWithCategoriesRow.time,
                                                                                                    '12:00',
                                                                                                  ),
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        font: GoogleFonts.urbanist(
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                        ),
                                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                                        fontSize: 14.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                                      ),
                                                                                                ),
                                                                                              ].divide(SizedBox(width: 6.0)),
                                                                                            ),
                                                                                          ].divide(SizedBox(width: 8.0)),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ].divide(SizedBox(height: 16.0)),
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
                wrapWithModel(
                  model: _model.navBarWidgetModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavBarWidgetWidget(
                    home: false,
                    jobs: true,
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
