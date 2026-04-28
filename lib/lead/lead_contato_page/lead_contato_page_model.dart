import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'lead_contato_page_widget.dart' show LeadContatoPageWidget;
import 'package:flutter/material.dart';

class LeadContatoPageModel extends FlutterFlowModel<LeadContatoPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for NameEvento widget.
  FocusNode? nameEventoFocusNode;
  TextEditingController? nameEventoTextController;
  String? Function(BuildContext, String?)? nameEventoTextControllerValidator;
  String? _nameEventoTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  // State field(s) for Email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo obrigatório';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'E-mail inválido.';
    }
    return null;
  }

  // State field(s) for message widget.
  FocusNode? messageFocusNode;
  TextEditingController? messageTextController;
  String? Function(BuildContext, String?)? messageTextControllerValidator;
  String? _messageTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  // Stores action output result for [Validate Form] action in Button widget.
  bool? validate;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  LeadContactRow? create;

  @override
  void initState(BuildContext context) {
    nameEventoTextControllerValidator = _nameEventoTextControllerValidator;
    emailTextControllerValidator = _emailTextControllerValidator;
    messageTextControllerValidator = _messageTextControllerValidator;
  }

  @override
  void dispose() {
    nameEventoFocusNode?.dispose();
    nameEventoTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    messageFocusNode?.dispose();
    messageTextController?.dispose();
  }
}
