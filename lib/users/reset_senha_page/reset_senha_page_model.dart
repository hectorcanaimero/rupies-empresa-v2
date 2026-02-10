import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'reset_senha_page_widget.dart' show ResetSenhaPageWidget;
import 'package:flutter/material.dart';

class ResetSenhaPageModel extends FlutterFlowModel<ResetSenhaPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for pwd widget.
  FocusNode? pwdFocusNode;
  TextEditingController? pwdTextController;
  late bool pwdVisibility;
  String? Function(BuildContext, String?)? pwdTextControllerValidator;
  // State field(s) for pwd2 widget.
  FocusNode? pwd2FocusNode;
  TextEditingController? pwd2TextController;
  late bool pwd2Visibility;
  String? Function(BuildContext, String?)? pwd2TextControllerValidator;

  @override
  void initState(BuildContext context) {
    pwdVisibility = false;
    pwd2Visibility = false;
  }

  @override
  void dispose() {
    pwdFocusNode?.dispose();
    pwdTextController?.dispose();

    pwd2FocusNode?.dispose();
    pwd2TextController?.dispose();
  }
}
