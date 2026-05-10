import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_page_widget.dart' show ChatPageWidget;
import 'package:flutter/material.dart';
import 'dart:async';

class ChatPageModel extends FlutterFlowModel<ChatPageWidget> {
  ///  Local state fields for this page.

  bool typeText = false;
  bool isRecording = false;
  bool isOtherUserTyping = false;

  // ScrollController for auto-scroll after sending messages.
  ScrollController? chatListController;

  // Typing indicator channel and timer.
  RealtimeChannel? typingChannel;
  Timer? typingTimer;

  ///  State fields for stateful widgets in this page.

  // Supabase Realtime stream for chat messages.
  Stream<List<ChatsMessageRow>>? chatMessagesStream;

  // Stores action output result for [Backend Call - Update Row(s)] action in ChatPage widget.
  List<ChatsMessageRow>? update;
  // State field(s) for content widget.
  FocusNode? contentFocusNode;
  TextEditingController? contentTextController;
  String? Function(BuildContext, String?)? contentTextControllerValidator;
  // Stores action output result for [Backend Call - Insert Row] action in content widget.
  ChatsMessageRow? createCopy;
  // Stores action output result for [Backend Call - Insert Row] action in Icon widget.
  ChatsMessageRow? create;
  bool isDataUploading_uploadDataDgg = false;
  FFUploadedFile uploadedLocalFile_uploadDataDgg =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataDgg = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    contentFocusNode?.dispose();
    contentTextController?.dispose();
    chatListController?.dispose();
    typingTimer?.cancel();
    typingChannel?.unsubscribe();
  }
}
