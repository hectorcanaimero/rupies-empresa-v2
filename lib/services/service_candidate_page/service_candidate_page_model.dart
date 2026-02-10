import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/bubble_chat_widget/bubble_chat_widget_widget.dart';
import '/index.dart';
import 'service_candidate_page_widget.dart' show ServiceCandidatePageWidget;
import 'package:flutter/material.dart';

class ServiceCandidatePageModel
    extends FlutterFlowModel<ServiceCandidatePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for BubbleChatWidget dynamic component.
  late FlutterFlowDynamicModels<BubbleChatWidgetModel> bubbleChatWidgetModels;
  // Stores action output result for [Backend Call - Query Rows] action in BubbleChatWidget widget.
  List<ChatsRow>? exist;
  // Stores action output result for [Backend Call - Insert Row] action in BubbleChatWidget widget.
  ChatsRow? newChat;
  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<ServicesCandidatedRow>? aproved;

  @override
  void initState(BuildContext context) {
    bubbleChatWidgetModels =
        FlutterFlowDynamicModels(() => BubbleChatWidgetModel());
  }

  @override
  void dispose() {
    bubbleChatWidgetModels.dispose();
  }
}
