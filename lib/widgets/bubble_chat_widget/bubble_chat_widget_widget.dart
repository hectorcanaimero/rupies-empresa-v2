import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bubble_chat_widget_model.dart';
export 'bubble_chat_widget_model.dart';

class BubbleChatWidgetWidget extends StatefulWidget {
  const BubbleChatWidgetWidget({
    super.key,
    required this.serviceId,
    this.userCandidate,
  });

  final String? serviceId;
  final String? userCandidate;

  @override
  State<BubbleChatWidgetWidget> createState() => _BubbleChatWidgetWidgetState();
}

class _BubbleChatWidgetWidgetState extends State<BubbleChatWidgetWidget> {
  late BubbleChatWidgetModel _model;
  Future<(ChatsRow?, List<ViewChatsMessageWithDetailsRow>)>? _chatDataFuture;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BubbleChatWidgetModel());

    _chatDataFuture = ChatsTable()
        .querySingleRow(
          queryFn: (q) => q
              .eqOrNull('serviceId', widget.serviceId)
              .eqOrNull('userCandidate', widget.userCandidate)
              .eqOrNull('userId', currentUserUid),
        )
        .then((chatList) async {
      final chat = chatList.isNotEmpty ? chatList.first : null;
      if (chat == null) {
        return (null as ChatsRow?,
            <ViewChatsMessageWithDetailsRow>[]);
      }
      final messages = await ViewChatsMessageWithDetailsTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('chatId', chat.id)
            .eqOrNull('typeMessage', MessageSendType.Prestador.name)
            .eqOrNull('readMessage', false),
      );
      return (chat, messages);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(ChatsRow?, List<ViewChatsMessageWithDetailsRow>)>(
      future: _chatDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            width: 40.0,
            height: 40.0,
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 25.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).accent3,
              icon: Icon(
                Icons.wechat_rounded,
                color: FlutterFlowTheme.of(context).alternate,
                size: 24.0,
              ),
              onPressed: null,
            ),
          );
        }

        final (chat, messages) = snapshot.data!;

        if (messages.isNotEmpty) {
          return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
            child: badges.Badge(
              badgeContent: Text(
                messages.length.toString(),
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.interTight(
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                      color: Colors.white,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
              ),
              showBadge: true,
              shape: badges.BadgeShape.circle,
              badgeColor: FlutterFlowTheme.of(context).primary,
              elevation: 4.0,
              padding: EdgeInsets.all(6.0),
              position: badges.BadgePosition.topEnd(),
              animationType: badges.BadgeAnimationType.scale,
              toAnimate: true,
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 25.0,
                borderWidth: 1.0,
                buttonSize: 40.0,
                fillColor: FlutterFlowTheme.of(context).accent3,
                icon: Icon(
                  Icons.wechat_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  logFirebaseEvent(
                      'BUBBLE_CHAT_WIDGET_wechat_rounded_ICN_ON');
                  logFirebaseEvent('IconButton_navigate_to');
                  context.pushNamed(
                    ChatPageWidget.routeName,
                    queryParameters: {
                      'chatId': serializeParam(
                        chat?.id,
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );
                },
              ),
            ),
          );
        }

        return FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 25.0,
          borderWidth: 1.0,
          buttonSize: 40.0,
          fillColor: FlutterFlowTheme.of(context).accent3,
          icon: Icon(
            Icons.wechat_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 24.0,
          ),
          onPressed: () async {
            logFirebaseEvent('BUBBLE_CHAT_WIDGET_wechat_rounded_ICN_ON');
            if (chat?.id != null && chat?.id != '') {
              logFirebaseEvent('IconButton_navigate_to');
              context.pushNamed(
                ChatPageWidget.routeName,
                queryParameters: {
                  'chatId': serializeParam(chat?.id, ParamType.String),
                }.withoutNulls,
              );
            } else {
              logFirebaseEvent('IconButton_backend_call');
              _model.newChat = await ChatsTable().insert({
                'serviceId': widget.serviceId,
                'userId': currentUserUid,
                'userCandidate': widget.userCandidate,
              });
              logFirebaseEvent('IconButton_navigate_to');
              context.pushNamed(
                ChatPageWidget.routeName,
                queryParameters: {
                  'chatId':
                      serializeParam(_model.newChat?.id, ParamType.String),
                }.withoutNulls,
              );
            }
            safeSetState(() {});
          },
        );
      },
    );
  }
}
