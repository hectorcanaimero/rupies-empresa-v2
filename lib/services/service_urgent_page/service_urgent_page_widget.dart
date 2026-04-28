import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_place_picker.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:async';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'service_urgent_page_model.dart';
export 'service_urgent_page_model.dart';

class ServiceUrgentPageWidget extends StatefulWidget {
  const ServiceUrgentPageWidget({super.key});

  static String routeName = 'ServiceUrgentPage';
  static String routePath = 'serviceUrgentPage';

  @override
  State<ServiceUrgentPageWidget> createState() =>
      _ServiceUrgentPageWidgetState();
}

class _ServiceUrgentPageWidgetState extends State<ServiceUrgentPageWidget>
    with TickerProviderStateMixin {
  late ServiceUrgentPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ServiceUrgentPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'ServiceUrgentPage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('SERVICE_URGENT_ServiceUrgentPage_ON_INIT');
      await Future.wait([
        Future(() async {
          if (FFAppState().serviceId != '') {
            logFirebaseEvent('ServiceUrgentPage_alert_dialog');
            var confirmDialogResponse = await showDialog<bool>(
                  context: context,
                  builder: (alertDialogContext) {
                    return AlertDialog(
                      title: Text('Opa!'),
                      content: Text('Ainda não finalizou o serviço. '),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(alertDialogContext, false),
                          child: Text('Quero finalizar o atual'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(alertDialogContext, true),
                          child: Text('Iniciar um Serviço novo'),
                        ),
                      ],
                    );
                  },
                ) ??
                false;
            if (confirmDialogResponse) {
              logFirebaseEvent('ServiceUrgentPage_update_app_state');
              FFAppState().deleteServiceId();
              FFAppState().serviceId = '';

              safeSetState(() {});
              logFirebaseEvent('ServiceUrgentPage_update_page_state');
              _model.dateStart = null;
              _model.uid = null;
              _model.images = [];
              _model.show = false;
              _model.list = [];
              safeSetState(() {});
            } else {
              return;
            }

            return;
          } else {
            return;
          }
        }),
      ]);
    });

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));

    _model.titleFocusNode ??= FocusNode();

    _model.descriptionFocusNode ??= FocusNode();

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.skillTextController ??= TextEditingController();
    _model.skillFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      logFirebaseEvent('SERVICE_URGENT_ServiceUrgentPage_ON_DISP');
      logFirebaseEvent('ServiceUrgentPage_update_page_state');
      _model.list = [];
      _model.show = false;
      _model.images = [];
      _model.uid = null;
      _model.dateStart = null;
      _model.dateEnd = null;
      safeSetState(() {});
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: FutureBuilder<List<ServicesRow>>(
            future: ServicesTable().querySingleRow(
              queryFn: (q) => q.eqOrNull(
                'id',
                FFAppState().serviceId,
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }
              List<ServicesRow> stackServicesRowList = snapshot.data!;

              final stackServicesRow = stackServicesRowList.isNotEmpty
                  ? stackServicesRowList.first
                  : null;

              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _model.pageViewController ??=
                          PageController(initialPage: 0),
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 100.0,
                                  decoration: BoxDecoration(),
                                  child: Form(
                                    key: _model.formKey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      child: SingleChildScrollView(
                                        primary: false,
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
                                                  'Dados do Serviço Urgente',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmall
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              thickness: 2.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 12.0, 0.0, 21.0),
                                              child: FutureBuilder<
                                                  List<CategoriesRow>>(
                                                future: FFAppState().categories(
                                                  requestFn: () =>
                                                      CategoriesTable()
                                                          .queryRows(
                                                    queryFn: (q) => q.eqOrNull(
                                                      'status',
                                                      true,
                                                    ),
                                                  ),
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
                                                  List<CategoriesRow>
                                                      categoryCategoriesRowList =
                                                      snapshot.data!;

                                                  return FlutterFlowDropDown<
                                                      String>(
                                                    controller: _model
                                                            .categoryValueController ??=
                                                        FormFieldController<
                                                            String>(
                                                      _model.categoryValue ??=
                                                          stackServicesRow
                                                              ?.categoryId,
                                                    ),
                                                    options: List<String>.from(
                                                        categoryCategoriesRowList
                                                            .map((e) => e.id)
                                                            .toList()),
                                                    optionLabels:
                                                        categoryCategoriesRowList
                                                            .map((e) => e.name)
                                                            .withoutNulls
                                                            .toList(),
                                                    onChanged: (val) =>
                                                        safeSetState(() => _model
                                                                .categoryValue =
                                                            val),
                                                    width: double.infinity,
                                                    height: 50.0,
                                                    searchHintTextStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                              ),
                                                              color:
                                                                  Colors.black,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                    searchTextStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              letterSpacing:
                                                                  0.0,
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
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
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
                                                    hintText:
                                                        'Selecionar categoria',
                                                    searchHintText:
                                                        'Busca pela categoria...',
                                                    icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_rounded,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 24.0,
                                                    ),
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    elevation: 2.0,
                                                    borderColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .alternate,
                                                    borderWidth: 2.0,
                                                    borderRadius: 8.0,
                                                    margin:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(16.0, 4.0,
                                                                16.0, 4.0),
                                                    hidesUnderline: true,
                                                    isOverButton: true,
                                                    isSearchable: true,
                                                    isMultiSelect: false,
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 21.0),
                                              child: Container(
                                                width: double.infinity,
                                                child: TextFormField(
                                                  controller: _model
                                                          .titleTextController ??=
                                                      TextEditingController(
                                                    text:
                                                        stackServicesRow?.name,
                                                  ),
                                                  focusNode:
                                                      _model.titleFocusNode,
                                                  autofocus: false,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Digite o titulo da vaga',
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
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
                                                  validator: _model
                                                      .titleTextControllerValidator
                                                      .asValidator(context),
                                                  inputFormatters: [
                                                    if (!isAndroid && !isiOS)
                                                      TextInputFormatter
                                                          .withFunction(
                                                              (oldValue,
                                                                  newValue) {
                                                        return TextEditingValue(
                                                          selection: newValue
                                                              .selection,
                                                          text: newValue.text
                                                              .toCapitalization(
                                                                  TextCapitalization
                                                                      .words),
                                                        );
                                                      }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 15.0),
                                              child: Container(
                                                width: double.infinity,
                                                child: TextFormField(
                                                  controller: _model
                                                          .descriptionTextController ??=
                                                      TextEditingController(
                                                    text: stackServicesRow
                                                        ?.description,
                                                  ),
                                                  focusNode: _model
                                                      .descriptionFocusNode,
                                                  autofocus: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Digite detalhes da vaga.',
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                    alignLabelWithHint: true,
                                                    hintText:
                                                        '(Informe se a vaga é  por dia ou por empreita.)',
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
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
                                                  maxLines: 6,
                                                  validator: _model
                                                      .descriptionTextControllerValidator
                                                      .asValidator(context),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 15.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 46.0,
                                                child:
                                                    custom_widgets.MoedaBRField(
                                                  width: double.infinity,
                                                  height: 46.0,
                                                  initialValue:
                                                      valueOrDefault<String>(
                                                    stackServicesRow?.price
                                                        ?.toString(),
                                                    '0',
                                                  ),
                                                  labelText:
                                                      'Digite o Preço ao oferecer do serviço',
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 15.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        2.0,
                                                                        0.0,
                                                                        0.0,
                                                                        4.0),
                                                            child: Text(
                                                              'Data Inicio',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 44.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9.0),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                    if (_model
                                                                            .dateStart !=
                                                                        null) {
                                                                      return Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          dateTimeFormat(
                                                                            "dd/MM/yy",
                                                                            _model.dateStart,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      return Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            _model.dateStart != null
                                                                                ? _model.dateStart?.toString()
                                                                                : valueOrDefault<String>(
                                                                                    dateTimeFormat(
                                                                                      "d/M/y",
                                                                                      stackServicesRow?.dateStart,
                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                    ),
                                                                                    '...',
                                                                                  ),
                                                                            '...',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                              FlutterFlowIconButton(
                                                                borderRadius:
                                                                    8.0,
                                                                buttonSize:
                                                                    44.0,
                                                                fillColor: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                icon: Icon(
                                                                  Icons
                                                                      .calendar_month,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .info,
                                                                  size: 24.0,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  logFirebaseEvent(
                                                                      'SERVICE_URGENT_calendar_month_ICN_ON_TAP');
                                                                  // Data Entrada
                                                                  logFirebaseEvent(
                                                                      'IconButton_DataEntrada');
                                                                  final _datePicked1Date =
                                                                      await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        getCurrentTimestamp,
                                                                    firstDate:
                                                                        getCurrentTimestamp,
                                                                    lastDate:
                                                                        DateTime(
                                                                            2050),
                                                                    builder:
                                                                        (context,
                                                                            child) {
                                                                      return wrapInMaterialDatePickerTheme(
                                                                        context,
                                                                        child!,
                                                                        headerBackgroundColor:
                                                                            FlutterFlowTheme.of(context).primary,
                                                                        headerForegroundColor:
                                                                            FlutterFlowTheme.of(context).info,
                                                                        headerTextStyle: FlutterFlowTheme.of(context)
                                                                            .headlineLarge
                                                                            .override(
                                                                              font: GoogleFonts.interTight(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                                                                              ),
                                                                              fontSize: 32.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                                                                            ),
                                                                        pickerBackgroundColor:
                                                                            FlutterFlowTheme.of(context).secondaryBackground,
                                                                        pickerForegroundColor:
                                                                            FlutterFlowTheme.of(context).primaryText,
                                                                        selectedDateTimeBackgroundColor:
                                                                            FlutterFlowTheme.of(context).primary,
                                                                        selectedDateTimeForegroundColor:
                                                                            FlutterFlowTheme.of(context).info,
                                                                        actionButtonForegroundColor:
                                                                            FlutterFlowTheme.of(context).primaryText,
                                                                        iconSize:
                                                                            24.0,
                                                                      );
                                                                    },
                                                                  );

                                                                  if (_datePicked1Date !=
                                                                      null) {
                                                                    safeSetState(
                                                                        () {
                                                                      _model.datePicked1 =
                                                                          DateTime(
                                                                        _datePicked1Date
                                                                            .year,
                                                                        _datePicked1Date
                                                                            .month,
                                                                        _datePicked1Date
                                                                            .day,
                                                                      );
                                                                    });
                                                                  } else if (_model
                                                                          .datePicked1 !=
                                                                      null) {
                                                                    safeSetState(
                                                                        () {
                                                                      _model.datePicked1 =
                                                                          getCurrentTimestamp;
                                                                    });
                                                                  }
                                                                  logFirebaseEvent(
                                                                      'IconButton_update_page_state');
                                                                  _model.dateStart =
                                                                      _model
                                                                          .datePicked1;
                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 9.0)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -1.0, 0.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        2.0,
                                                                        0.0,
                                                                        0.0,
                                                                        4.0),
                                                            child: Text(
                                                              'Data Fim',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 44.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9.0),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                    if (_model
                                                                            .dateEnd !=
                                                                        null) {
                                                                      return Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          dateTimeFormat(
                                                                            "dd/MM/yy",
                                                                            _model.dateEnd,
                                                                            locale:
                                                                                FFLocalizations.of(context).languageCode,
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      return Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          valueOrDefault<
                                                                              String>(
                                                                            _model.dateEnd != null
                                                                                ? _model.dateEnd?.toString()
                                                                                : valueOrDefault<String>(
                                                                                    dateTimeFormat(
                                                                                      "d/M/y",
                                                                                      stackServicesRow?.dateEnd,
                                                                                      locale: FFLocalizations.of(context).languageCode,
                                                                                    ),
                                                                                    '...',
                                                                                  ),
                                                                            '...',
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.inter(
                                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                fontSize: 14.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                              FlutterFlowIconButton(
                                                                borderRadius:
                                                                    8.0,
                                                                buttonSize:
                                                                    44.0,
                                                                fillColor: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                icon: Icon(
                                                                  Icons
                                                                      .calendar_month_sharp,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .info,
                                                                  size: 24.0,
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  logFirebaseEvent(
                                                                      'SERVICE_URGENT_calendar_month_sharp_ICN_');
                                                                  if (_model
                                                                          .dateStart !=
                                                                      null) {
                                                                    // Data Entrada
                                                                    logFirebaseEvent(
                                                                        'IconButton_DataEntrada');
                                                                    final _datePicked2Date =
                                                                        await showDatePicker(
                                                                      context:
                                                                          context,
                                                                      initialDate:
                                                                          getCurrentTimestamp,
                                                                      firstDate: (_model
                                                                              .dateStart ??
                                                                          DateTime(
                                                                              1900)),
                                                                      lastDate:
                                                                          DateTime(
                                                                              2050),
                                                                      builder:
                                                                          (context,
                                                                              child) {
                                                                        return wrapInMaterialDatePickerTheme(
                                                                          context,
                                                                          child!,
                                                                          headerBackgroundColor:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          headerForegroundColor:
                                                                              FlutterFlowTheme.of(context).info,
                                                                          headerTextStyle: FlutterFlowTheme.of(context)
                                                                              .headlineLarge
                                                                              .override(
                                                                                font: GoogleFonts.interTight(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontStyle: FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                                                                                ),
                                                                                fontSize: 32.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                                                                              ),
                                                                          pickerBackgroundColor:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          pickerForegroundColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          selectedDateTimeBackgroundColor:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          selectedDateTimeForegroundColor:
                                                                              FlutterFlowTheme.of(context).info,
                                                                          actionButtonForegroundColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          iconSize:
                                                                              24.0,
                                                                        );
                                                                      },
                                                                    );

                                                                    if (_datePicked2Date !=
                                                                        null) {
                                                                      safeSetState(
                                                                          () {
                                                                        _model.datePicked2 =
                                                                            DateTime(
                                                                          _datePicked2Date
                                                                              .year,
                                                                          _datePicked2Date
                                                                              .month,
                                                                          _datePicked2Date
                                                                              .day,
                                                                        );
                                                                      });
                                                                    } else if (_model
                                                                            .datePicked2 !=
                                                                        null) {
                                                                      safeSetState(
                                                                          () {
                                                                        _model.datePicked2 =
                                                                            getCurrentTimestamp;
                                                                      });
                                                                    }
                                                                    logFirebaseEvent(
                                                                        'IconButton_update_page_state');
                                                                    _model.dateEnd =
                                                                        _model
                                                                            .datePicked2;
                                                                    safeSetState(
                                                                        () {});
                                                                  } else {
                                                                    logFirebaseEvent(
                                                                        'IconButton_alert_dialog');
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (alertDialogContext) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text('Opa!'),
                                                                          content:
                                                                              Text('Escolha a data de inicio!'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 9.0)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 14.0)),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 15.0),
                                              child:
                                                  FlutterFlowDropDown<String>(
                                                controller: _model
                                                        .hourArrivedValueController ??=
                                                    FormFieldController<String>(
                                                  _model.hourArrivedValue ??=
                                                      stackServicesRow?.time,
                                                ),
                                                options: functions.parseHour(),
                                                onChanged: (val) =>
                                                    safeSetState(() => _model
                                                            .hourArrivedValue =
                                                        val),
                                                width: double.infinity,
                                                height: 50.0,
                                                searchHintTextStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                searchTextStyle:
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
                                                textStyle:
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
                                                hintText: 'Hora de chegada',
                                                searchHintText:
                                                    'Busca pela categoria...',
                                                icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 24.0,
                                                ),
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                elevation: 2.0,
                                                borderColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                borderWidth: 2.0,
                                                borderRadius: 8.0,
                                                margin: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 4.0, 16.0, 4.0),
                                                hidesUnderline: true,
                                                isOverButton: true,
                                                isSearchable: true,
                                                isMultiSelect: false,
                                              ),
                                            ),
                                          ]
                                              .divide(SizedBox(height: 5.0))
                                              .addToStart(
                                                  SizedBox(height: 12.0))
                                              .addToEnd(SizedBox(height: 24.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 12.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FFButtonWidget(
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'SERVICE_URGENT_VOLTAR_BTN_ON_TAP');
                                        logFirebaseEvent(
                                            'Button_navigate_back');
                                        context.safePop();
                                      },
                                      text: 'Voltar',
                                      options: FFButtonOptions(
                                        width: 120.0,
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                      ),
                                    ),
                                    FFButtonWidget(
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'SERVICE_URGENT_SEGUINTE_BTN_ON_TAP');
                                        var _shouldSetState = false;
                                        if (FFAppState().serviceId != '') {
                                          logFirebaseEvent(
                                              'Button_backend_call');
                                          await ServicesTable().update(
                                            data: {
                                              'userId': currentUserUid,
                                              'name': _model
                                                  .titleTextController.text,
                                              'description': _model
                                                  .descriptionTextController
                                                  .text,
                                              'dateStart':
                                                  supaSerialize<DateTime>(
                                                      _model.dateStart != null
                                                          ? _model.dateStart
                                                          : stackServicesRow
                                                              ?.dateStart),
                                              'dateEnd':
                                                  supaSerialize<DateTime>(
                                                      _model.dateEnd != null
                                                          ? _model.dateEnd
                                                          : stackServicesRow
                                                              ?.dateEnd),
                                              'price': FFAppState().propPrice,
                                              'categoryId':
                                                  _model.categoryValue,
                                              'time': _model.hourArrivedValue,
                                            },
                                            matchingRows: (rows) =>
                                                rows.eqOrNull(
                                              'id',
                                              FFAppState().serviceId,
                                            ),
                                          );
                                          _shouldSetState = true;
                                          logFirebaseEvent('Button_page_view');
                                          await _model.pageViewController
                                              ?.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                          if (_shouldSetState)
                                            safeSetState(() {});
                                          return;
                                        } else {
                                          if (FFAppState().typecompany != '') {
                                            logFirebaseEvent(
                                                'Button_backend_call');
                                            _model.create1 =
                                                await ServicesTable().insert({
                                              'userId': currentUserUid,
                                              'name': _model
                                                  .titleTextController.text,
                                              'description': _model
                                                  .descriptionTextController
                                                  .text,
                                              'dateStart':
                                                  supaSerialize<DateTime>(
                                                      _model.dateStart),
                                              'dateEnd':
                                                  supaSerialize<DateTime>(
                                                      _model.dateEnd),
                                              'price': FFAppState().propPrice,
                                              'categoryId':
                                                  _model.categoryValue,
                                              'time': _model.hourArrivedValue,
                                              'condition':
                                                  Conditions.Openned.name,
                                              'jobType': JobTypes.Urgente.name,
                                            });
                                            _shouldSetState = true;
                                            logFirebaseEvent(
                                                'Button_update_app_state');
                                            FFAppState().serviceId =
                                                _model.create1!.id;
                                            safeSetState(() {});
                                            logFirebaseEvent(
                                                'Button_page_view');
                                            await _model.pageViewController
                                                ?.nextPage(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.ease,
                                            );
                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          } else {
                                            logFirebaseEvent(
                                                'Button_validate_form');
                                            _model.validateOne = true;
                                            if (_model.formKey.currentState ==
                                                    null ||
                                                !_model.formKey.currentState!
                                                    .validate()) {
                                              safeSetState(() =>
                                                  _model.validateOne = false);
                                              return;
                                            }
                                            if (_model.categoryValue == null) {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Erro'),
                                                    content: Text(
                                                        'A categoria é obrigatória.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              _model.validateOne = false;
                                              safeSetState(() {});
                                              return;
                                            }
                                            if (_model.hourArrivedValue ==
                                                null) {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Erro'),
                                                    content: Text(
                                                        'A hora de chegada é obrigatória.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                alertDialogContext),
                                                        child: Text('Ok'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              _model.validateOne = false;
                                              safeSetState(() {});
                                              return;
                                            }
                                            _shouldSetState = true;
                                            if (_model.validateOne!) {
                                              if ((_model.dateStart != null) &&
                                                  (_model.dateEnd != null)) {
                                                if (functions.validateTrial(
                                                    FFAppState().trial)) {
                                                  logFirebaseEvent(
                                                      'Button_backend_call');
                                                  _model.create =
                                                      await ServicesTable()
                                                          .insert({
                                                    'userId': currentUserUid,
                                                    'name': _model
                                                        .titleTextController
                                                        .text,
                                                    'description': _model
                                                        .descriptionTextController
                                                        .text,
                                                    'dateStart':
                                                        supaSerialize<DateTime>(
                                                            _model.dateStart),
                                                    'dateEnd':
                                                        supaSerialize<DateTime>(
                                                            _model.dateEnd),
                                                    'price':
                                                        FFAppState().propPrice,
                                                    'categoryId':
                                                        _model.categoryValue,
                                                    'time':
                                                        _model.hourArrivedValue,
                                                    'condition':
                                                        Conditions.Openned.name,
                                                    'jobType':
                                                        JobTypes.Urgente.name,
                                                  });
                                                  _shouldSetState = true;
                                                  logFirebaseEvent(
                                                      'Button_update_app_state');
                                                  FFAppState().serviceId =
                                                      _model.create!.id;
                                                  FFAppState().trial =
                                                      functions.newValuetrial(
                                                          FFAppState().trial,
                                                          1);
                                                  safeSetState(() {});
                                                  logFirebaseEvent(
                                                      'Button_backend_call');
                                                  await UsersTable().update(
                                                    data: {
                                                      'trial':
                                                          FFAppState().trial,
                                                    },
                                                    matchingRows: (rows) =>
                                                        rows.eqOrNull(
                                                      'id',
                                                      currentUserUid,
                                                    ),
                                                  );
                                                  _shouldSetState = true;
                                                  logFirebaseEvent(
                                                      'Button_page_view');
                                                  await _model
                                                      .pageViewController
                                                      ?.nextPage(
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.ease,
                                                  );
                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                } else {
                                                  logFirebaseEvent(
                                                      'Button_alert_dialog');
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text('Opa!'),
                                                        content: Text(
                                                            'Você não tem créditos disponíveis.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext),
                                                            child: Text('Ok'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  logFirebaseEvent(
                                                      'Button_navigate_to');

                                                  context.pushNamed(
                                                      HomePageWidget.routeName);

                                                  if (_shouldSetState)
                                                    safeSetState(() {});
                                                  return;
                                                }
                                              } else {
                                                logFirebaseEvent(
                                                    'Button_alert_dialog');
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text('Opa!'),
                                                      content: Text(
                                                          'Selecione a data de início e a data de fim para continuar.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext),
                                                          child: Text('Ok'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                if (_shouldSetState)
                                                  safeSetState(() {});
                                                return;
                                              }
                                            } else {
                                              if (_shouldSetState)
                                                safeSetState(() {});
                                              return;
                                            }
                                          }
                                        }

                                        if (_shouldSetState)
                                          safeSetState(() {});
                                      },
                                      text: 'Seguinte',
                                      options: FFButtonOptions(
                                        width: 160.0,
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 15.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 12.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 100.0,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment(0.0, 0),
                                          child: TabBar(
                                            labelColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            unselectedLabelColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            labelStyle: FlutterFlowTheme.of(
                                                    context)
                                                .titleMedium
                                                .override(
                                                  font: GoogleFonts.interTight(
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
                                            unselectedLabelStyle:
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
                                            indicatorColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            tabs: [
                                              Tab(
                                                text: 'Imagens',
                                              ),
                                              Tab(
                                                text: 'Mais Info',
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
                                                height: double.infinity,
                                                decoration: BoxDecoration(),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        constraints:
                                                            BoxConstraints(
                                                          minHeight: 500.0,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      12.0,
                                                                      0.0,
                                                                      12.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            -1.0,
                                                                            0.0),
                                                                    child: Text(
                                                                      'Imagens do Serviço',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .headlineSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.interTight(
                                                                              fontWeight: FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                            ),
                                                                            fontSize:
                                                                                20.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  FlutterFlowIconButton(
                                                                    borderRadius:
                                                                        25.0,
                                                                    buttonSize:
                                                                        40.0,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .camera_alt,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .alternate,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      logFirebaseEvent(
                                                                          'SERVICE_URGENT_camera_alt_ICN_ON_TAP');
                                                                      logFirebaseEvent(
                                                                          'IconButton_upload_media_to_supabase');
                                                                      final selectedMedia =
                                                                          await selectMediaWithSourceBottomSheet(
                                                                        context:
                                                                            context,
                                                                        storageFolderPath:
                                                                            '',
                                                                        imageQuality:
                                                                            70,
                                                                        allowPhoto:
                                                                            true,
                                                                        includeDimensions:
                                                                            true,
                                                                        includeBlurHash:
                                                                            true,
                                                                      );
                                                                      if (selectedMedia !=
                                                                              null &&
                                                                          selectedMedia.every((m) => validateFileFormat(
                                                                              m.storagePath,
                                                                              context))) {
                                                                        safeSetState(() =>
                                                                            _model.isDataUploading_field0001 =
                                                                                true);
                                                                        var selectedUploadedFiles =
                                                                            <FFUploadedFile>[];

                                                                        var downloadUrls =
                                                                            <String>[];
                                                                        try {
                                                                          selectedUploadedFiles = selectedMedia
                                                                              .map((m) => FFUploadedFile(
                                                                                    name: m.storagePath.split('/').last,
                                                                                    bytes: m.bytes,
                                                                                    height: m.dimensions?.height,
                                                                                    width: m.dimensions?.width,
                                                                                    blurHash: m.blurHash,
                                                                                    originalFilename: m.originalFilename,
                                                                                  ))
                                                                              .toList();

                                                                          downloadUrls =
                                                                              await uploadSupabaseStorageFiles(
                                                                            bucketName:
                                                                                'App',
                                                                            selectedFiles:
                                                                                selectedMedia,
                                                                          );
                                                                        } finally {
                                                                          _model.isDataUploading_field0001 =
                                                                              false;
                                                                        }
                                                                        if (selectedUploadedFiles.length == selectedMedia.length &&
                                                                            downloadUrls.length ==
                                                                                selectedMedia.length) {
                                                                          safeSetState(
                                                                              () {
                                                                            _model.uploadedLocalFile_field0001 =
                                                                                selectedUploadedFiles.first;
                                                                            _model.uploadedFileUrl_field0001 =
                                                                                downloadUrls.first;
                                                                          });
                                                                        } else {
                                                                          safeSetState(
                                                                              () {});
                                                                          return;
                                                                        }
                                                                      }

                                                                      logFirebaseEvent(
                                                                          'IconButton_backend_call');
                                                                      _model.createImage =
                                                                          await ServicesImagesTable()
                                                                              .insert({
                                                                        'serviceId':
                                                                            FFAppState().serviceId,
                                                                        'image':
                                                                            _model.uploadedFileUrl_field0001,
                                                                      });
                                                                      logFirebaseEvent(
                                                                          'IconButton_update_page_state');
                                                                      _model.addToImages(
                                                                          _model
                                                                              .uploadedFileUrl_field0001);
                                                                      safeSetState(
                                                                          () {});
                                                                      logFirebaseEvent(
                                                                          'IconButton_refresh_database_request');
                                                                      safeSetState(() =>
                                                                          _model.requestCompleter2 =
                                                                              null);
                                                                      await _model
                                                                          .waitForRequestCompleted2();

                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              Divider(
                                                                thickness: 2.0,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  constraints:
                                                                      BoxConstraints(
                                                                    minHeight:
                                                                        240.0,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            12.0,
                                                                            0.0,
                                                                            24.0),
                                                                    child: FutureBuilder<
                                                                        List<
                                                                            ServicesImagesRow>>(
                                                                      future: (_model
                                                                              .requestCompleter2 ??= Completer<List<ServicesImagesRow>>()
                                                                            ..complete(ServicesImagesTable().queryRows(
                                                                              queryFn: (q) => q
                                                                                  .eqOrNull(
                                                                                    'serviceId',
                                                                                    FFAppState().serviceId,
                                                                                  )
                                                                                  .order('created_at'),
                                                                            )))
                                                                          .future,
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        // Customize what your widget looks like when it's loading.
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return Center(
                                                                            child:
                                                                                SizedBox(
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
                                                                        List<ServicesImagesRow>
                                                                            staggeredViewServicesImagesRowList =
                                                                            snapshot.data!;

                                                                        return MasonryGridView
                                                                            .builder(
                                                                          gridDelegate:
                                                                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                                                            crossAxisCount:
                                                                                4,
                                                                          ),
                                                                          crossAxisSpacing:
                                                                              10.0,
                                                                          mainAxisSpacing:
                                                                              10.0,
                                                                          itemCount:
                                                                              staggeredViewServicesImagesRowList.length,
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemBuilder:
                                                                              (context, staggeredViewIndex) {
                                                                            final staggeredViewServicesImagesRow =
                                                                                staggeredViewServicesImagesRowList[staggeredViewIndex];
                                                                            return Container(
                                                                              height: 90.0,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                borderRadius: BorderRadius.circular(9.0),
                                                                                border: Border.all(
                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  width: 2.0,
                                                                                ),
                                                                              ),
                                                                              child: Stack(
                                                                                alignment: AlignmentDirectional(1.0, -1.0),
                                                                                children: [
                                                                                  InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    focusColor: Colors.transparent,
                                                                                    hoverColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    onTap: () async {
                                                                                      logFirebaseEvent('SERVICE_URGENT_PAGE_PAGE_Image1_ON_TAP');
                                                                                      logFirebaseEvent('Image1_expand_image');
                                                                                      await Navigator.push(
                                                                                        context,
                                                                                        PageTransition(
                                                                                          type: PageTransitionType.fade,
                                                                                          child: FlutterFlowExpandedImageView(
                                                                                            image: Image.network(
                                                                                              staggeredViewServicesImagesRow.image!,
                                                                                              fit: BoxFit.contain,
                                                                                            ),
                                                                                            allowRotation: false,
                                                                                            tag: staggeredViewServicesImagesRow.image!,
                                                                                            useHeroAnimation: true,
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                    child: Hero(
                                                                                      tag: staggeredViewServicesImagesRow.image!,
                                                                                      transitionOnUserGestures: true,
                                                                                      child: ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                        child: Image.network(
                                                                                          staggeredViewServicesImagesRow.image!,
                                                                                          width: double.infinity,
                                                                                          height: double.infinity,
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Align(
                                                                                    alignment: AlignmentDirectional(1.0, -1.0),
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 2.0, 0.0),
                                                                                      child: InkWell(
                                                                                        splashColor: Colors.transparent,
                                                                                        focusColor: Colors.transparent,
                                                                                        hoverColor: Colors.transparent,
                                                                                        highlightColor: Colors.transparent,
                                                                                        onTap: () async {
                                                                                          logFirebaseEvent('SERVICE_URGENT_Icon_tf43gjxt_ON_TAP');
                                                                                          logFirebaseEvent('Icon_backend_call');
                                                                                          await ServicesImagesTable().delete(
                                                                                            matchingRows: (rows) => rows.eqOrNull(
                                                                                              'id',
                                                                                              staggeredViewServicesImagesRow.id,
                                                                                            ),
                                                                                          );
                                                                                          logFirebaseEvent('Icon_delete_data');
                                                                                          await deleteSupabaseFileFromPublicUrl(staggeredViewServicesImagesRow.image!);
                                                                                          logFirebaseEvent('Icon_refresh_database_request');
                                                                                          safeSetState(() => _model.requestCompleter2 = null);
                                                                                          await _model.waitForRequestCompleted2();

                                                                                          safeSetState(() {});
                                                                                        },
                                                                                        child: Icon(
                                                                                          Icons.close_rounded,
                                                                                          color: FlutterFlowTheme.of(context).error,
                                                                                          size: 18.0,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                                .addToStart(
                                                                    SizedBox(
                                                                        height:
                                                                            24.0))
                                                                .addToEnd(SizedBox(
                                                                    height:
                                                                        24.0)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 100.0,
                                                height: 100.0,
                                                decoration: BoxDecoration(),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          16.0, 0.0, 16.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        child: Text(
                                                          'Equipamentos, documentos \nou habilidades',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmall
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 20.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: 2.0,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    12.0,
                                                                    0.0,
                                                                    18.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                width: 200.0,
                                                                child:
                                                                    TextFormField(
                                                                  controller: _model
                                                                      .skillTextController,
                                                                  focusNode: _model
                                                                      .skillFocusNode,
                                                                  onFieldSubmitted:
                                                                      (_) async {
                                                                    logFirebaseEvent(
                                                                        'SERVICE_URGENT_skill_ON_TEXTFIELD_SUBMIT');
                                                                    logFirebaseEvent(
                                                                        'skill_backend_call');
                                                                    _model.createServiceSkill =
                                                                        await ServicesSkillsTable()
                                                                            .insert({
                                                                      'serviceId':
                                                                          FFAppState()
                                                                              .serviceId,
                                                                      'name': _model
                                                                          .skillTextController
                                                                          .text,
                                                                    });
                                                                    logFirebaseEvent(
                                                                        'skill_refresh_database_request');
                                                                    safeSetState(() =>
                                                                        _model.requestCompleter1 =
                                                                            null);
                                                                    await _model
                                                                        .waitForRequestCompleted1();

                                                                    safeSetState(
                                                                        () {});
                                                                  },
                                                                  autofocus:
                                                                      false,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    isDense:
                                                                        true,
                                                                    labelStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                    hintText:
                                                                        'Digite as habilidades...',
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0x00000000),
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(8.0),
                                                                        bottomLeft:
                                                                            Radius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color(
                                                                            0x00000000),
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(8.0),
                                                                        bottomLeft:
                                                                            Radius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(8.0),
                                                                        bottomLeft:
                                                                            Radius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(8.0),
                                                                        bottomLeft:
                                                                            Radius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                  cursorColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                  validator: _model
                                                                      .skillTextControllerValidator
                                                                      .asValidator(
                                                                          context),
                                                                ),
                                                              ),
                                                            ),
                                                            FFButtonWidget(
                                                              onPressed:
                                                                  () async {
                                                                logFirebaseEvent(
                                                                    'SERVICE_URGENT_PAGE_PAGE__BTN_ON_TAP');
                                                                logFirebaseEvent(
                                                                    'Button_backend_call');
                                                                _model.createSkill =
                                                                    await ServicesSkillsTable()
                                                                        .insert({
                                                                  'serviceId':
                                                                      FFAppState()
                                                                          .serviceId,
                                                                  'name': _model
                                                                      .skillTextController
                                                                      .text,
                                                                });
                                                                logFirebaseEvent(
                                                                    'Button_refresh_database_request');
                                                                safeSetState(() =>
                                                                    _model.requestCompleter1 =
                                                                        null);
                                                                await _model
                                                                    .waitForRequestCompleted1();
                                                                logFirebaseEvent(
                                                                    'Button_clear_text_fields_pin_codes');
                                                                safeSetState(
                                                                    () {
                                                                  _model
                                                                      .skillTextController
                                                                      ?.clear();
                                                                });

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              text: '',
                                                              icon: Icon(
                                                                Icons
                                                                    .check_rounded,
                                                                size: 24.0,
                                                              ),
                                                              options:
                                                                  FFButtonOptions(
                                                                width: 60.0,
                                                                height: 40.0,
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                iconPadding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                textStyle: FlutterFlowTheme.of(
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
                                                                      color: Colors
                                                                          .white,
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
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          8.0),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      18.0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: FutureBuilder<
                                                                List<
                                                                    ServicesSkillsRow>>(
                                                              future: (_model.requestCompleter1 ??= Completer<
                                                                      List<
                                                                          ServicesSkillsRow>>()
                                                                    ..complete(
                                                                        ServicesSkillsTable()
                                                                            .queryRows(
                                                                      queryFn: (q) => q
                                                                          .eqOrNull(
                                                                            'serviceId',
                                                                            FFAppState().serviceId,
                                                                          )
                                                                          .order('created_at'),
                                                                    )))
                                                                  .future,
                                                              builder: (context,
                                                                  snapshot) {
                                                                // Customize what your widget looks like when it's loading.
                                                                if (!snapshot
                                                                    .hasData) {
                                                                  return Center(
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          40.0,
                                                                      height:
                                                                          40.0,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(
                                                                          Color(
                                                                              0x004B39EF),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                List<ServicesSkillsRow>
                                                                    staggeredSkillViewServicesSkillsRowList =
                                                                    snapshot
                                                                        .data!;

                                                                return MasonryGridView
                                                                    .builder(
                                                                  gridDelegate:
                                                                      SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        2,
                                                                  ),
                                                                  crossAxisSpacing:
                                                                      10.0,
                                                                  mainAxisSpacing:
                                                                      10.0,
                                                                  itemCount:
                                                                      staggeredSkillViewServicesSkillsRowList
                                                                          .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          staggeredSkillViewIndex) {
                                                                    final staggeredSkillViewServicesSkillsRow =
                                                                        staggeredSkillViewServicesSkillsRowList[
                                                                            staggeredSkillViewIndex];
                                                                    return Container(
                                                                      height:
                                                                          30.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        borderRadius:
                                                                            BorderRadius.circular(9.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            6.0,
                                                                            3.0,
                                                                            6.0,
                                                                            3.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              valueOrDefault<String>(
                                                                                staggeredSkillViewServicesSkillsRow.name,
                                                                                'Skil',
                                                                              ),
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    font: GoogleFonts.inter(
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                                    fontSize: 12.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                  ),
                                                                            ),
                                                                            InkWell(
                                                                              splashColor: Colors.transparent,
                                                                              focusColor: Colors.transparent,
                                                                              hoverColor: Colors.transparent,
                                                                              highlightColor: Colors.transparent,
                                                                              onTap: () async {
                                                                                logFirebaseEvent('SERVICE_URGENT_Icon_s43mowqj_ON_TAP');
                                                                                logFirebaseEvent('Icon_backend_call');
                                                                                await ServicesSkillsTable().delete(
                                                                                  matchingRows: (rows) => rows.eqOrNull(
                                                                                    'id',
                                                                                    staggeredSkillViewServicesSkillsRow.id,
                                                                                  ),
                                                                                );
                                                                                logFirebaseEvent('Icon_refresh_database_request');
                                                                                safeSetState(() => _model.requestCompleter1 = null);
                                                                                await _model.waitForRequestCompleted1();

                                                                                safeSetState(() {});
                                                                              },
                                                                              child: Icon(
                                                                                Icons.close_rounded,
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                size: 18.0,
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
                                                        ),
                                                      ),
                                                    ]
                                                        .addToStart(SizedBox(
                                                            height: 24.0))
                                                        .addToEnd(SizedBox(
                                                            height: 24.0)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 12.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FFButtonWidget(
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'SERVICE_URGENT_ANTERIOR_BTN_ON_TAP');
                                        logFirebaseEvent('Button_page_view');
                                        await _model.pageViewController
                                            ?.previousPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );
                                      },
                                      text: 'Anterior',
                                      options: FFButtonOptions(
                                        width: 140.0,
                                        height: 44.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: Colors.white,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    FFButtonWidget(
                                      onPressed: () async {
                                        logFirebaseEvent(
                                            'SERVICE_URGENT_PAGE_PAGE_button_ON_TAP');
                                        logFirebaseEvent('button_backend_call');
                                        _model.countImages =
                                            await ServicesImagesTable()
                                                .queryRows(
                                          queryFn: (q) => q.eqOrNull(
                                            'serviceId',
                                            FFAppState().serviceId,
                                          ),
                                        );
                                        if (_model.countImages!.length > 0) {
                                          logFirebaseEvent('button_page_view');
                                          await _model.pageViewController
                                              ?.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                        } else {
                                          logFirebaseEvent(
                                              'button_alert_dialog');
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Erro'),
                                                content: Text(
                                                    'PAra continuar é necessario subir uma imagem do serviço'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }

                                        safeSetState(() {});
                                      },
                                      text: 'Seguinte',
                                      options: FFButtonOptions(
                                        width: 160.0,
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        elevation: 0.0,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Builder(builder: (context) {
                              final _googleMapMarker =
                                  (_model.placePickerValue.latLng);
                              return FlutterFlowGoogleMap(
                                controller: _model.googleMapsController,
                                onCameraIdle: (latLng) => safeSetState(
                                    () => _model.googleMapsCenter = latLng),
                                initialLocation: _model.googleMapsCenter ??=
                                    currentUserLocationValue!,
                                markers: [
                                  FlutterFlowMarker(
                                    _googleMapMarker.serialize(),
                                    _googleMapMarker,
                                  ),
                                ],
                                markerColor: GoogleMarkerColor.green,
                                mapType: MapType.normal,
                                style: GoogleMapStyle.standard,
                                initialZoom: 15.0,
                                allowInteraction: true,
                                allowZoom: true,
                                showZoomControls: true,
                                showLocation: true,
                                showCompass: false,
                                showMapToolbar: false,
                                showTraffic: false,
                                centerMapOnMarkerTap: true,
                                mapTakesGesturePreference: false,
                              );
                            }),
                            Align(
                              alignment: AlignmentDirectional(0.0, -1.0),
                              child: PointerInterceptor(
                                intercepting: isWeb,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 70.0, 0.0, 0.0),
                                  child: FlutterFlowPlacePicker(
                                    iOSGoogleMapsApiKey:
                                        'AIzaSyDyp9tahhSNSauP8JfcPtbICsiz1UqutN8',
                                    androidGoogleMapsApiKey:
                                        'AIzaSyDyp9tahhSNSauP8JfcPtbICsiz1UqutN8',
                                    webGoogleMapsApiKey:
                                        'AIzaSyDyp9tahhSNSauP8JfcPtbICsiz1UqutN8',
                                    onSelect: (place) async {
                                      safeSetState(() =>
                                          _model.placePickerValue = place);
                                      (await _model.googleMapsController.future)
                                          .animateCamera(CameraUpdate.newLatLng(
                                              place.latLng.toGoogleMaps()));
                                    },
                                    defaultText: 'Digite seu Endereço',
                                    icon: Icon(
                                      Icons.place,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 16.0,
                                    ),
                                    buttonOptions: FFButtonOptions(
                                      width: 200.0,
                                      height: 40.0,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .info,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: PointerInterceptor(
                                intercepting: isWeb,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 80.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: Color(0x67000000),
                                    ),
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, -1.0),
                                      child: Padding(
                                        padding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                12.0, 12.0, 12.0, 12.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            _model.placePickerValue.address,
                                            'Address',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: PointerInterceptor(
                                intercepting: isWeb,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 12.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FFButtonWidget(
                                        onPressed: () async {
                                          logFirebaseEvent(
                                              'SERVICE_URGENT_ANTERIOR_BTN_ON_TAP');
                                          logFirebaseEvent('Button_page_view');
                                          await _model.pageViewController
                                              ?.previousPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                        },
                                        text: 'Anterior',
                                        options: FFButtonOptions(
                                          width: 140.0,
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
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
                                                color: Colors.black,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          logFirebaseEvent(
                                              'SERVICE_URGENT_PAGE_PAGE_button_ON_TAP');
                                          logFirebaseEvent(
                                              'button_backend_call');
                                          await ServicesTable().update(
                                            data: {
                                              'endRegister': true,
                                              'cep': _model
                                                  .placePickerValue.zipCode,
                                              'latLng': _model
                                                  .placePickerValue.latLng
                                                  .toString(),
                                              'address': _model
                                                  .placePickerValue.address,
                                              'condition':
                                                  Conditions.Openned.name,
                                            },
                                            matchingRows: (rows) =>
                                                rows.eqOrNull(
                                              'id',
                                              FFAppState().serviceId,
                                            ),
                                          );
                                          logFirebaseEvent(
                                              'button_update_app_state');
                                          FFAppState().deleteServiceId();
                                          FFAppState().serviceId = '';

                                          safeSetState(() {});
                                          logFirebaseEvent(
                                              'button_alert_dialog');
                                          await showDialog(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Show!'),
                                                content: Text(
                                                    'O Serviço foi  criado com o sucesso.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext),
                                                    child: Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          logFirebaseEvent(
                                              'button_navigate_to');

                                          context.goNamed(
                                              HomePageWidget.routeName);

                                          safeSetState(() {});
                                        },
                                        text: 'Finalizar',
                                        options: FFButtonOptions(
                                          width: 140.0,
                                          height: 40.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
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
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 15.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
