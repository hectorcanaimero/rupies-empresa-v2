import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'dart:async';
import 'service_urgent_page_widget.dart' show ServiceUrgentPageWidget;
import 'package:flutter/material.dart';

class ServiceUrgentPageModel extends FlutterFlowModel<ServiceUrgentPageWidget> {
  ///  Local state fields for this page.

  List<String> list = [];
  void addToList(String item) => list.add(item);
  void removeFromList(String item) => list.remove(item);
  void removeAtIndexFromList(int index) => list.removeAt(index);
  void insertAtIndexInList(int index, String item) => list.insert(index, item);
  void updateListAtIndex(int index, Function(String) updateFn) =>
      list[index] = updateFn(list[index]);

  bool show = false;

  List<String> images = [];
  void addToImages(String item) => images.add(item);
  void removeFromImages(String item) => images.remove(item);
  void removeAtIndexFromImages(int index) => images.removeAt(index);
  void insertAtIndexInImages(int index, String item) =>
      images.insert(index, item);
  void updateImagesAtIndex(int index, Function(String) updateFn) =>
      images[index] = updateFn(images[index]);

  String? uid;

  DateTime? dateStart;

  DateTime? dateEnd;

  LatLng? location;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for Category widget.
  String? categoryValue;
  FormFieldController<String>? categoryValueController;
  // State field(s) for Title widget.
  FocusNode? titleFocusNode;
  TextEditingController? titleTextController;
  String? Function(BuildContext, String?)? titleTextControllerValidator;
  String? _titleTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo Obrigatorio';
    }

    return null;
  }

  // State field(s) for Description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;
  String? _descriptionTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo Origatorio';
    }

    return null;
  }

  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for HourArrived widget.
  String? hourArrivedValue;
  FormFieldController<String>? hourArrivedValueController;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<ServicesRow>? update1;
  // Stores action output result for [Validate Form] action in Button widget.
  bool? validateOne;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  ServicesRow? create;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<UsersRow>? upate;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  bool isDataUploading_field0001 = false;
  FFUploadedFile uploadedLocalFile_field0001 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_field0001 = '';

  // Stores action output result for [Backend Call - Insert Row] action in IconButton widget.
  ServicesImagesRow? createImage;
  Completer<List<ServicesImagesRow>>? requestCompleter2;
  // Stores action output result for [Backend Call - Delete Row(s)] action in Icon widget.
  List<ServicesImagesRow>? deleteImage;
  // State field(s) for skill widget.
  FocusNode? skillFocusNode;
  TextEditingController? skillTextController;
  String? Function(BuildContext, String?)? skillTextControllerValidator;
  // Stores action output result for [Backend Call - Insert Row] action in skill widget.
  ServicesSkillsRow? createServiceSkill;
  Completer<List<ServicesSkillsRow>>? requestCompleter1;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  ServicesSkillsRow? createSkill;
  // Stores action output result for [Backend Call - Delete Row(s)] action in Icon widget.
  List<ServicesSkillsRow>? delete;
  // Stores action output result for [Backend Call - Query Rows] action in button widget.
  List<ServicesImagesRow>? countImages;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // State field(s) for PlacePicker widget.
  FFPlace placePickerValue = FFPlace();
  // Stores action output result for [Backend Call - Update Row(s)] action in button widget.
  List<ServicesRow>? finaliza;
  // Stores action output result for [Backend Call - Insert Row] action in button widget.
  NotificationsNewServiceRow? notif;

  @override
  void initState(BuildContext context) {
    titleTextControllerValidator = _titleTextControllerValidator;
    descriptionTextControllerValidator = _descriptionTextControllerValidator;
  }

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleTextController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();

    tabBarController?.dispose();
    skillFocusNode?.dispose();
    skillTextController?.dispose();
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
