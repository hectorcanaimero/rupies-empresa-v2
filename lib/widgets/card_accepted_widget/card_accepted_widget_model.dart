import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/bubble_chat_widget/bubble_chat_widget_widget.dart';
import 'card_accepted_widget_widget.dart' show CardAcceptedWidgetWidget;
import 'package:flutter/material.dart';

class CardAcceptedWidgetModel
    extends FlutterFlowModel<CardAcceptedWidgetWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for BubbleChatWidget component.
  late BubbleChatWidgetModel bubbleChatWidgetModel;

  @override
  void initState(BuildContext context) {
    bubbleChatWidgetModel = createModel(context, () => BubbleChatWidgetModel());
  }

  @override
  void dispose() {
    bubbleChatWidgetModel.dispose();
  }
}
