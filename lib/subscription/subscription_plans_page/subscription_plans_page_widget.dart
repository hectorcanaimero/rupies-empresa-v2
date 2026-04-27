import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'subscription_plans_page_model.dart';
export 'subscription_plans_page_model.dart';

class SubscriptionPlansPageWidget extends StatefulWidget {
  const SubscriptionPlansPageWidget({super.key});

  static String routeName = 'SubscriptionPlansPage';
  static String routePath = 'subscriptionPlansPage';

  @override
  State<SubscriptionPlansPageWidget> createState() =>
      _SubscriptionPlansPageWidgetState();
}

class _SubscriptionPlansPageWidgetState
    extends State<SubscriptionPlansPageWidget> {
  late SubscriptionPlansPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionPlansPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'SubscriptionPlansPage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('SUBSCRIPTION_PLANS_SubscriptionPlansPage');
      logFirebaseEvent('SubscriptionPlansPage_backend_call');
      _model.planos = await SubscriptionPlansTable().queryRows(
        queryFn: (q) => q,
      );
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
    return StreamBuilder<List<ViewSubsRow>>(
      stream: _model.subscriptionPlansPageSupabaseStream ??= SupaFlow.client
          .from("view_subs")
          .stream(primaryKey: ['id'])
          .eqOrNull(
            'user_id',
            currentUserUid,
          )
          .map((list) => list.map((item) => ViewSubsRow(item)).toList()),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<ViewSubsRow> subscriptionPlansPageViewSubsRowList = snapshot.data!;

        final subscriptionPlansPageViewSubsRow =
            subscriptionPlansPageViewSubsRowList.isNotEmpty
                ? subscriptionPlansPageViewSubsRowList.first
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
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  logFirebaseEvent('SUBSCRIPTION_PLANS_arrow_back_rounded_IC');
                  logFirebaseEvent('IconButton_navigate_back');
                  context.pop();
                },
              ),
              title: Text(
                'Clube dos 100',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
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
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Builder(
                builder: (context) {
                  if (subscriptionPlansPageViewSubsRow?.id != null &&
                      subscriptionPlansPageViewSubsRow?.id != '') {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(9.0),
                                  topRight: Radius.circular(9.0),
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  minHeight: 200.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2F1788),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(9.0),
                                    topRight: Radius.circular(9.0),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(9.0),
                                    topRight: Radius.circular(9.0),
                                  ),
                                  child: Image.network(
                                    subscriptionPlansPageViewSubsRow!.spImage2!,
                                    fit: BoxFit.cover,
                                    cacheHeight: 200,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 18.0),
                              child: FutureBuilder<List<SubscriptionPlansRow>>(
                                future: SubscriptionPlansTable().querySingleRow(
                                  queryFn: (q) => q.eqOrNull(
                                    'id',
                                    subscriptionPlansPageViewSubsRow.planId,
                                  ),
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  List<SubscriptionPlansRow>
                                      containerSubscriptionPlansRowList =
                                      snapshot.data!;

                                  // Return an empty Container when the item does not exist.
                                  if (snapshot.data!.isEmpty) {
                                    return Container();
                                  }
                                  final containerSubscriptionPlansRow =
                                      containerSubscriptionPlansRowList
                                              .isNotEmpty
                                          ? containerSubscriptionPlansRowList
                                              .first
                                          : null;

                                  return Material(
                                    color: Colors.transparent,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(9.0),
                                        bottomRight: Radius.circular(9.0),
                                      ),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2F1788),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(9.0),
                                          bottomRight: Radius.circular(9.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 24.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 6.0),
                                              child: Text(
                                                'Plan Contratado:',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 9.0),
                                              child: Text(
                                                subscriptionPlansPageViewSubsRow
                                                    .spName!,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.white,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 6.0, 0.0, 18.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Estado da subscrição: ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  Text(
                                                    subscriptionPlansPageViewSubsRow
                                                        .status!,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(width: 6.0)),
                                              ),
                                            ),
                                            if (subscriptionPlansPageViewSubsRow
                                                    .status ==
                                                'pending')
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    logFirebaseEvent(
                                                        'SUBSCRIPTION_PLANS_IR_PARA_O_LINK_DE_PAG');
                                                    logFirebaseEvent(
                                                        'Button_launch_u_r_l');
                                                    await launchURL(
                                                        getJsonField(
                                                      subscriptionPlansPageViewSubsRow
                                                          .metadata!,
                                                      r'''$.payment_link_url''',
                                                    ).toString());
                                                  },
                                                  text:
                                                      'Ir para o Link de pagamento',
                                                  options: FFButtonOptions(
                                                    width: 220.0,
                                                    height: 40.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 0.0,
                                                                16.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    textStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .interTight(
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                    elevation: 0.0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 18.0),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 1.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.campaign_sharp,
                                              color: Color(0xFFBABABA),
                                              size: 36.0,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Em caso de dúvidas, entre em contato com o suporte. Estamos aqui para ajudar.',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 16.0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  logFirebaseEvent(
                                      'SUBSCRIPTION_PLANS_ENTRA_EM_CONTATO_BTN_');
                                  logFirebaseEvent('Button_launch_u_r_l');
                                  await launchURL(
                                      'https://wa.me/5511965939170');
                                },
                                text: 'Entra em contato',
                                icon: FaIcon(
                                  FontAwesomeIcons.envelope,
                                  size: 15.0,
                                ),
                                options: FFButtonOptions(
                                  width: 229.0,
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 12.0, 0.0),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ]
                              .addToStart(SizedBox(height: 24.0))
                              .addToEnd(SizedBox(height: 24.0)),
                        ),
                      ),
                    );
                  } else {
                    return FutureBuilder<List<SubscriptionPlansRow>>(
                      future: SubscriptionPlansTable().queryRows(
                        queryFn: (q) => q,
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
                        List<SubscriptionPlansRow>
                            containerSubscriptionPlansRowList = snapshot.data!;

                        return Container(
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 6.0),
                                              child: RichText(
                                                textScaler:
                                                    MediaQuery.of(context)
                                                        .textScaler,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Escolha o',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineLarge
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 20.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineLarge
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                    TextSpan(
                                                      text: ' Plano Ideal ',
                                                      style: TextStyle(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: 'para você:',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )
                                                  ],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineLarge
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineLarge
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 20.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 36.0),
                                    child: Builder(
                                      builder: (context) {
                                        final ouro =
                                            containerSubscriptionPlansRowList
                                                .where((e) => e.type == 'ouro')
                                                .toList()
                                                .map((e) => e)
                                                .toList()
                                                .take(1)
                                                .toList();

                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: List.generate(ouro.length,
                                              (ouroIndex) {
                                            final ouroItem = ouro[ouroIndex];
                                            return Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 12.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image.network(
                                                            ouroItem.image!,
                                                            width:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                FFButtonWidget(
                                                  onPressed: () async {
                                                    logFirebaseEvent(
                                                        'SUBSCRIPTION_PLANS_COMEAR_O_PLANO_RECOME');
                                                    logFirebaseEvent(
                                                        'Button_update_page_state');
                                                    _model.isCreating = true;
                                                    safeSetState(() {});
                                                    logFirebaseEvent(
                                                        'Button_custom_action');
                                                    _model.createSubResult =
                                                        await actions
                                                            .createSubscription(
                                                      ouroItem.id,
                                                      'yearly',
                                                      'pix',
                                                    );
                                                    logFirebaseEvent(
                                                        'Button_wait__delay');
                                                    await Future.delayed(
                                                      Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    logFirebaseEvent(
                                                        'Button_backend_call');
                                                    _model.dtaSubs =
                                                        await SubscriptionsTable()
                                                            .queryRows(
                                                      queryFn: (q) =>
                                                          q.eqOrNull(
                                                        'user_id',
                                                        currentUserUid,
                                                      ),
                                                    );
                                                    logFirebaseEvent(
                                                        'Button_update_page_state');
                                                    _model.isCreating = false;
                                                    safeSetState(() {});
                                                    logFirebaseEvent(
                                                        'Button_launch_u_r_l');
                                                    await launchURL(
                                                        getJsonField(
                                                      _model
                                                          .dtaSubs!
                                                          .firstOrNull!
                                                          .metadata!,
                                                      r'''$.payment_link_url''',
                                                    ).toString());

                                                    safeSetState(() {});
                                                  },
                                                  text:
                                                      'Começar o plano recomendado',
                                                  options: FFButtonOptions(
                                                    height: 40.0,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 0.0,
                                                                16.0, 0.0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .tertiary,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                    elevation: 0.0,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 6.0),
                                      child: Text(
                                        'Prefere OUTRO PLANO?',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .headlineLarge
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 24.0),
                                      child: Text(
                                        'Veja as opções: ',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .headlineLarge
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 18.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            constraints: BoxConstraints(
                                              minHeight: 100.0,
                                            ),
                                            decoration: BoxDecoration(),
                                            child: Builder(
                                              builder: (context) {
                                                final prata =
                                                    containerSubscriptionPlansRowList
                                                        .where((e) =>
                                                            e.type == 'prata')
                                                        .toList()
                                                        .map((e) => e)
                                                        .toList()
                                                        .take(1)
                                                        .toList();

                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: List.generate(
                                                      prata.length,
                                                      (prataIndex) {
                                                    final prataItem =
                                                        prata[prataIndex];
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      12.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child:
                                                                Image.network(
                                                              prataItem.image!,
                                                              width: 200.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        FFButtonWidget(
                                                          onPressed: () async {
                                                            logFirebaseEvent(
                                                                'SUBSCRIPTION_PLANS_COMEAR_J_BTN_ON_TAP');
                                                            logFirebaseEvent(
                                                                'Button_update_page_state');
                                                            _model.isCreating =
                                                                true;
                                                            safeSetState(() {});
                                                            logFirebaseEvent(
                                                                'Button_custom_action');
                                                            _model.createSubResult1 =
                                                                await actions
                                                                    .createSubscription(
                                                              prataItem.id,
                                                              'semiannually',
                                                              'pix',
                                                            );
                                                            logFirebaseEvent(
                                                                'Button_wait__delay');
                                                            await Future
                                                                .delayed(
                                                              Duration(
                                                                milliseconds:
                                                                    700,
                                                              ),
                                                            );
                                                            logFirebaseEvent(
                                                                'Button_backend_call');
                                                            _model.dtaSubs1 =
                                                                await SubscriptionsTable()
                                                                    .queryRows(
                                                              queryFn: (q) =>
                                                                  q.eqOrNull(
                                                                'user_id',
                                                                currentUserUid,
                                                              ),
                                                            );
                                                            logFirebaseEvent(
                                                                'Button_update_page_state');
                                                            _model.isCreating =
                                                                false;
                                                            safeSetState(() {});
                                                            logFirebaseEvent(
                                                                'Button_launch_u_r_l');
                                                            await launchURL(
                                                                getJsonField(
                                                              _model
                                                                  .dtaSubs!
                                                                  .firstOrNull!
                                                                  .metadata!,
                                                              r'''$.payment_link_url''',
                                                            ).toString());

                                                            safeSetState(() {});
                                                          },
                                                          text: 'Começar Já!',
                                                          options:
                                                              FFButtonOptions(
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tertiary,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 0.0,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            constraints: BoxConstraints(
                                              minHeight: 100.0,
                                            ),
                                            decoration: BoxDecoration(),
                                            child: Builder(
                                              builder: (context) {
                                                final basic =
                                                    containerSubscriptionPlansRowList
                                                        .where((e) =>
                                                            e.type == 'basic')
                                                        .toList()
                                                        .map((e) => e)
                                                        .toList()
                                                        .take(1)
                                                        .toList();

                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: List.generate(
                                                      basic.length,
                                                      (basicIndex) {
                                                    final basicItem =
                                                        basic[basicIndex];
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      12.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child:
                                                                Image.network(
                                                              basicItem.image!,
                                                              width: 200.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        FFButtonWidget(
                                                          onPressed: () async {
                                                            logFirebaseEvent(
                                                                'SUBSCRIPTION_PLANS_COMEAR_J_BTN_ON_TAP');
                                                            logFirebaseEvent(
                                                                'Button_update_page_state');
                                                            _model.isCreating =
                                                                true;
                                                            safeSetState(() {});
                                                            logFirebaseEvent(
                                                                'Button_custom_action');
                                                            _model.createSubResult2 =
                                                                await actions
                                                                    .createSubscription(
                                                              basicItem.id,
                                                              'monthly',
                                                              'pix',
                                                            );
                                                            logFirebaseEvent(
                                                                'Button_wait__delay');
                                                            await Future
                                                                .delayed(
                                                              Duration(
                                                                milliseconds:
                                                                    500,
                                                              ),
                                                            );
                                                            logFirebaseEvent(
                                                                'Button_backend_call');
                                                            _model.dtaSubs2 =
                                                                await SubscriptionsTable()
                                                                    .queryRows(
                                                              queryFn: (q) =>
                                                                  q.eqOrNull(
                                                                'user_id',
                                                                currentUserUid,
                                                              ),
                                                            );
                                                            logFirebaseEvent(
                                                                'Button_update_page_state');
                                                            _model.isCreating =
                                                                false;
                                                            safeSetState(() {});
                                                            logFirebaseEvent(
                                                                'Button_launch_u_r_l');
                                                            await launchURL(
                                                                getJsonField(
                                                              _model
                                                                  .dtaSubs2!
                                                                  .firstOrNull!
                                                                  .metadata!,
                                                              r'''$.payment_link_url''',
                                                            ).toString());

                                                            safeSetState(() {});
                                                          },
                                                          text: 'Começar Já!',
                                                          options:
                                                              FFButtonOptions(
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        0.0,
                                                                        16.0,
                                                                        0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tertiary,
                                                            textStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                            elevation: 0.0,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 15.0)),
                                    ),
                                  ),
                                ]
                                    .addToStart(SizedBox(height: 12.0))
                                    .addToEnd(SizedBox(height: 24.0)),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
