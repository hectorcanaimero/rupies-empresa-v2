import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'sac_page_widget.dart' show SacPageWidget;
import 'package:flutter/material.dart';

class SacPageModel extends FlutterFlowModel<SacPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for RadioButton widget.
  FormFieldController<String>? radioButtonValueController;
  // State field(s) for MessageField widget.
  FocusNode? messageFieldFocusNode;
  TextEditingController? messageFieldTextController;
  String? Function(BuildContext, String?)? messageFieldTextControllerValidator;
  String? _messageFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo obrigatorio';
    }

    return null;
  }

  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  SacsRow? userCreate;

  @override
  void initState(BuildContext context) {
    messageFieldTextControllerValidator = _messageFieldTextControllerValidator;
  }

  @override
  void dispose() {
    messageFieldFocusNode?.dispose();
    messageFieldTextController?.dispose();
  }

  /// Additional helper methods.
  String? get radioButtonValue => radioButtonValueController?.value;
}
