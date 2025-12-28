import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/bubble_chat_widget/bubble_chat_widget_widget.dart';
import 'card_accepted_widget_widget.dart' show CardAcceptedWidgetWidget;
import 'package:flutter/material.dart';

class CardAcceptedWidgetModel
    extends FlutterFlowModel<CardAcceptedWidgetWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for BubbleChatWidget component.
  late BubbleChatWidgetModel bubbleChatWidgetModel1;
  // Model for BubbleChatWidget component.
  late BubbleChatWidgetModel bubbleChatWidgetModel2;

  @override
  void initState(BuildContext context) {
    bubbleChatWidgetModel1 =
        createModel(context, () => BubbleChatWidgetModel());
    bubbleChatWidgetModel2 =
        createModel(context, () => BubbleChatWidgetModel());
  }

  @override
  void dispose() {
    bubbleChatWidgetModel1.dispose();
    bubbleChatWidgetModel2.dispose();
  }
}
