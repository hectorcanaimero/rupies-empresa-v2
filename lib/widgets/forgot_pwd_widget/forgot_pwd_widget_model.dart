import '/flutter_flow/flutter_flow_util.dart';
import 'forgot_pwd_widget_widget.dart' show ForgotPwdWidgetWidget;
import 'package:flutter/material.dart';

class ForgotPwdWidgetModel extends FlutterFlowModel<ForgotPwdWidgetWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'E-mail obrigatorio.';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Inserir  e-mail valido.';
    }
    return null;
  }

  // Stores action output result for [Validate Form] action in Button widget.
  bool? validate;

  @override
  void initState(BuildContext context) {
    emailTextControllerValidator = _emailTextControllerValidator;
  }

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailTextController?.dispose();
  }
}
