import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'create_lead_page_widget.dart' show CreateLeadPageWidget;
import 'dart:async';
import 'package:flutter/material.dart';

class CreateLeadPageModel extends FlutterFlowModel<CreateLeadPageWidget> {
  ///  Local state fields for this page.

  DateTime? dateEvent;

  DateTime? dateRetorno;

  Future<List<LeadsRow>>? leadFuture;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for typefornecedor widget.
  String? typefornecedorValue;
  FormFieldController<String>? typefornecedorValueController;
  // State field(s) for NameEvento widget.
  FocusNode? nameEventoFocusNode;
  TextEditingController? nameEventoTextController;
  String? Function(BuildContext, String?)? nameEventoTextControllerValidator;
  String? _nameEventoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo Obrigatorio';
    }

    return null;
  }

  DateTime? datePicked1;
  // State field(s) for QtdPessoa widget.
  FocusNode? qtdPessoaFocusNode;
  TextEditingController? qtdPessoaTextController;
  String? Function(BuildContext, String?)? qtdPessoaTextControllerValidator;
  // State field(s) for perfil widget.
  String? perfilValue;
  FormFieldController<String>? perfilValueController;
  // State field(s) for esperaFornecedor widget.
  FocusNode? esperaFornecedorFocusNode;
  TextEditingController? esperaFornecedorTextController;
  String? Function(BuildContext, String?)?
      esperaFornecedorTextControllerValidator;
  String? _esperaFornecedorTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo Obrigatorio';
    }

    return null;
  }

  // State field(s) for faixaDinheiro widget.
  String? faixaDinheiroValue;
  FormFieldController<String>? faixaDinheiroValueController;
  DateTime? datePicked2;
  // State field(s) for contact widget.
  FocusNode? contactFocusNode;
  TextEditingController? contactTextController;
  String? Function(BuildContext, String?)? contactTextControllerValidator;
  String? _contactTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo Obrigatorio';
    }

    return null;
  }

  // Stores action output result for [Validate Form] action in Button widget.
  bool? validate;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<LeadsRow>? update;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  LeadsRow? create;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<UsersRow>? upate;
  bool isDataUploading_uploadStand = false;
  FFUploadedFile uploadedLocalFile_uploadStand =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadStand = '';

  // Stores action output result for [Backend Call - Insert Row] action in IconImage widget.
  ServicesImagesRow? createImage;
  Completer<List<ServicesImagesRow>>? requestCompleter2;
  // Stores action output result for [Backend Call - Delete Row(s)] action in Icon widget.
  List<ServicesImagesRow>? deleteImage;
  bool isDataUploading_uploadDataPj4 = false;
  FFUploadedFile uploadedLocalFile_uploadDataPj4 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataPj4 = '';

  // Stores action output result for [Backend Call - Insert Row] action in IconFile widget.
  LeadAttachmentRow? createFile;
  Completer<List<LeadAttachmentRow>>? requestCompleter1;
  // Stores action output result for [Backend Call - Delete Row(s)] action in Icon widget.
  List<LeadAttachmentRow>? deleteFile;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue = FFPlace();
  // Stores action output result for [Backend Call - Update Row(s)] action in button widget.
  List<LeadsRow>? finaliza;

  @override
  void initState(BuildContext context) {
    nameEventoTextControllerValidator = _nameEventoTextControllerValidator;
    esperaFornecedorTextControllerValidator =
        _esperaFornecedorTextControllerValidator;
    contactTextControllerValidator = _contactTextControllerValidator;
  }

  @override
  void dispose() {
    nameEventoFocusNode?.dispose();
    nameEventoTextController?.dispose();

    qtdPessoaFocusNode?.dispose();
    qtdPessoaTextController?.dispose();

    esperaFornecedorFocusNode?.dispose();
    esperaFornecedorTextController?.dispose();

    contactFocusNode?.dispose();
    contactTextController?.dispose();
  }

  /// Additional helper methods.
  Future waitForRequestCompleted2({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleter2?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  Future waitForRequestCompleted1({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleter1?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
