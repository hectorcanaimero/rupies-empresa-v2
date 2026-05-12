import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/custom_code/actions/record_audio.dart';
import '/custom_code/widgets/audio_message_player.dart';
import 'dart:async';
import 'dart:io';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'chat_page_model.dart';
export 'chat_page_model.dart';

class ChatPageWidget extends StatefulWidget {
  const ChatPageWidget({
    super.key,
    required this.chatId,
  });

  final String? chatId;

  static String routeName = 'ChatPage';
  static String routePath = 'chatPage';

  @override
  State<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {
  late ChatPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'ChatPage'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('CHAT_PAGE_PAGE_ChatPage_ON_INIT_STATE');
      logFirebaseEvent('ChatPage_backend_call');
      await ChatsMessageTable().update(
        data: {
          'readMessage': true,
        },
        matchingRows: (rows) => rows
            .eqOrNull(
              'chatId',
              widget.chatId,
            )
            .eqOrNull(
              'typeMessage',
              MessageSendType.Prestador.name,
            )
            .eqOrNull(
              'readMessage',
              false,
            ),
      );
    });

    _model.contentTextController ??= TextEditingController();
    _model.contentFocusNode ??= FocusNode();

    // Subscribe to typing broadcast channel.
    _model.typingChannel = SupaFlow.client.channel('chat:${widget.chatId}');
    _model.typingChannel!
        .onBroadcast(
          event: 'typing',
          callback: (payload) {
            if (mounted) {
              safeSetState(() {
                _model.isOtherUserTyping = true;
              });
              _model.typingTimer?.cancel();
              _model.typingTimer = Timer(
                const Duration(seconds: 3),
                () {
                  if (mounted) {
                    safeSetState(() {
                      _model.isOtherUserTyping = false;
                    });
                  }
                },
              );
            }
          },
        )
        .subscribe();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFECE5DD),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 30.0,
            ),
            onPressed: () async {
              logFirebaseEvent('CHAT_arrow_back_rounded_ICN_ON_TAP');
              logFirebaseEvent('IconButton_navigate_back');
              context.pop();
            },
          ),
          title: FutureBuilder<List<ChatsRow>>(
            future: ChatsTable().querySingleRow(
              queryFn: (q) => q.eqOrNull('id', widget.chatId),
            ),
            builder: (context, chatSnapshot) {
              if (!chatSnapshot.hasData ||
                  chatSnapshot.data!.isEmpty) {
                return Text(
                  'Chat',
                  style: FlutterFlowTheme.of(context)
                      .headlineMedium
                      .override(
                        font: GoogleFonts.interTight(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                      ),
                );
              }
              final chatRow = chatSnapshot.data!.first;
              return FutureBuilder<List<UsersRow>>(
                future: UsersTable().querySingleRow(
                  queryFn: (q) =>
                      q.eqOrNull('id', chatRow.userCandidate),
                ),
                builder: (context, userSnapshot) {
                  final userName = userSnapshot.data?.firstOrNull
                          ?.displayName ??
                      'Chat';
                  final userPhoto =
                      userSnapshot.data?.firstOrNull?.photoUrl;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundColor:
                            FlutterFlowTheme.of(context).accent3,
                        backgroundImage: userPhoto != null &&
                                userPhoto.isNotEmpty
                            ? NetworkImage(userPhoto)
                            : null,
                        child: userPhoto == null || userPhoto.isEmpty
                            ? Text(
                                userName.isNotEmpty
                                    ? userName[0].toUpperCase()
                                    : '?',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      letterSpacing: 0.0,
                                    ),
                              )
                            : null,
                      ),
                      SizedBox(width: 12.0),
                      Flexible(
                        child: Text(
                          userName,
                          overflow: TextOverflow.ellipsis,
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: FlutterFlowTheme.of(context)
                                    .primaryText,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: FutureBuilder<List<ChatsRow>>(
            future: ChatsTable().querySingleRow(
              queryFn: (q) => q.eqOrNull(
                'id',
                widget.chatId,
              ),
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0x004B39EF),
                      ),
                    ),
                  ),
                );
              }
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: StreamBuilder<List<ChatsMessageRow>>(
                        stream: _model.chatMessagesStream ??= SupaFlow.client
                            .from("chats_message")
                            .stream(primaryKey: ['id'])
                            .eq('chatId', widget.chatId!)
                            .order('created_at')
                            .map((list) => list
                                .map((e) => ChatsMessageRow(e))
                                .toList()),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }
                          List<ChatsMessageRow> containerChatsMessageRowList =
                              snapshot.data!;

                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Builder(
                              builder: (context) {
                                if (containerChatsMessageRowList.length > 0) {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final containerVar =
                                            containerChatsMessageRowList
                                                .toList();

                                        return ListView.separated(
                                          controller: _model.chatListController ??= ScrollController(),
                                          padding: EdgeInsets.fromLTRB(
                                            0,
                                            24.0,
                                            0,
                                            24.0,
                                          ),
                                          reverse: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: containerVar.length,
                                          separatorBuilder: (_, __) =>
                                              SizedBox(height: 4.0),
                                          itemBuilder:
                                              (context, containerVarIndex) {
                                            final containerVarItem =
                                                containerVar[containerVarIndex];
                                            return Align(
                                              alignment: AlignmentDirectional(
                                                  valueOrDefault<double>(
                                                    containerVarItem
                                                                .typeMessage ==
                                                            MessageSendType
                                                                .Contractor.name
                                                        ? 1.0
                                                        : -1.0,
                                                    1.0,
                                                  ),
                                                  0.0),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.75,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: containerVarItem
                                                              .typeMessage ==
                                                          MessageSendType
                                                              .Contractor.name
                                                      ? Color(0xFFDCF8C6)
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12.0),
                                                    topRight:
                                                        Radius.circular(12.0),
                                                    bottomLeft: containerVarItem
                                                                .typeMessage ==
                                                            MessageSendType
                                                                .Contractor.name
                                                        ? Radius.circular(12.0)
                                                        : Radius.circular(4.0),
                                                    bottomRight: containerVarItem
                                                                .typeMessage ==
                                                            MessageSendType
                                                                .Contractor.name
                                                        ? Radius.circular(4.0)
                                                        : Radius.circular(12.0),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(alpha: 0.05),
                                                      blurRadius: 3.0,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(9.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        child: Builder(
                                                          builder: (context) {
                                                            if (containerVarItem
                                                                    .sendType ==
                                                                TypeMessage
                                                                    .image
                                                                    .name) {
                                                              return InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  logFirebaseEvent(
                                                                      'CHAT_PAGE_PAGE_Image_joh448di_ON_TAP');
                                                                  logFirebaseEvent(
                                                                      'Image_expand_image');
                                                                  await Navigator
                                                                      .push(
                                                                    context,
                                                                    PageTransition(
                                                                      type: PageTransitionType
                                                                          .fade,
                                                                      child:
                                                                          FlutterFlowExpandedImageView(
                                                                        image:
                                                                            OctoImage(
                                                                          placeholderBuilder: (_) =>
                                                                              SizedBox.expand(
                                                                            child:
                                                                                Image(
                                                                              image: BlurHashImage(_model.uploadedLocalFile_uploadDataDgg.blurHash!),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          image:
                                                                              NetworkImage(
                                                                            functions.parseTextToImage(containerVarItem.content!),
                                                                          ),
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                        allowRotation:
                                                                            false,
                                                                        tag: functions
                                                                            .parseTextToImage(containerVarItem.content!),
                                                                        useHeroAnimation:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Hero(
                                                                  tag: functions
                                                                      .parseTextToImage(
                                                                          containerVarItem
                                                                              .content!),
                                                                  transitionOnUserGestures:
                                                                      true,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            9.0),
                                                                    child:
                                                                        OctoImage(
                                                                      placeholderBuilder: _model
                                                                                  .uploadedLocalFile_uploadDataDgg
                                                                                  .blurHash !=
                                                                              null
                                                                          ? (_) =>
                                                                              SizedBox.expand(
                                                                                child: Image(
                                                                                  image: BlurHashImage(_model.uploadedLocalFile_uploadDataDgg.blurHash!),
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              )
                                                                          : null,
                                                                      image:
                                                                          NetworkImage(
                                                                        functions
                                                                            .parseTextToImage(containerVarItem.content!),
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            } else if (containerVarItem
                                                                    .sendType ==
                                                                TypeMessage
                                                                    .audio
                                                                    .name) {
                                                              return AudioMessagePlayer(
                                                                audioUrl:
                                                                    containerVarItem
                                                                        .content!,
                                                                isOwn: containerVarItem
                                                                        .typeMessage ==
                                                                    MessageSendType
                                                                        .Contractor
                                                                        .name,
                                                              );
                                                            } else {
                                                              return Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  containerVarItem
                                                                      .content,
                                                                  'Content',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Spacer(),
                                                            Text(
                                                              dateTimeFormat(
                                                                "Hm",
                                                                containerVarItem
                                                                    .createdAt,
                                                                locale: FFLocalizations.of(
                                                                            context)
                                                                        .languageShortCode ??
                                                                    FFLocalizations.of(
                                                                            context)
                                                                        .languageCode,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodySmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                    color: Color(
                                                                        0xFF667781),
                                                                    fontSize:
                                                                        11.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                            if (containerVarItem
                                                                    .typeMessage ==
                                                                MessageSendType
                                                                    .Contractor
                                                                    .name)
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            4.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                    if (containerVarItem
                                                                            .readMessage ==
                                                                        true) {
                                                                      return Icon(
                                                                        Icons
                                                                            .done_all,
                                                                        color: Color(
                                                                            0xFF53BDEB),
                                                                        size:
                                                                            16.0,
                                                                      );
                                                                    } else {
                                                                      return Icon(
                                                                        Icons
                                                                            .check_rounded,
                                                                        color: Color(
                                                                            0xFF667781),
                                                                        size:
                                                                            16.0,
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional(0.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 12.0, 24.0, 0.0),
                                        child: RichText(
                                          textScaler:
                                              MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    'Este código garante a identificação, segurança e rastreabilidade das informações trocadas neste chat. ',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              TextSpan(
                                                text: valueOrDefault<String>(
                                                  widget.chatId,
                                                  'Chat UID',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                      color: Color(0xFF333333),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                              )
                                            ],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                  color: Color(0xFF333333),
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (_model.isOtherUserTyping)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 4.0, 20.0, 4.0),
                        color:
                            FlutterFlowTheme.of(context).primaryBackground,
                        child: Text(
                          'digitando...',
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                font: GoogleFonts.inter(
                                  fontStyle: FontStyle.italic,
                                ),
                                color: Color(0xFF667781),
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: 60.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 8.0, 12.0, 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _model.contentTextController,
                                focusNode: _model.contentFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.contentTextController',
                                  Duration(milliseconds: 300),
                                  () async {
                                    logFirebaseEvent(
                                        'CHAT_content_ON_TEXTFIELD_CHANGE');
                                    logFirebaseEvent(
                                        'content_update_page_state');
                                    _model.typeText = true;
                                    safeSetState(() {});
                                    // Broadcast typing event.
                                    _model.typingChannel?.sendBroadcastMessage(
                                      event: 'typing',
                                      payload: {},
                                    );
                                  },
                                ),
                                onFieldSubmitted: (_) async {
                                  logFirebaseEvent(
                                      'CHAT_content_ON_TEXTFIELD_SUBMIT');
                                  final messageText = _model.contentTextController.text;
                                  logFirebaseEvent('content_reset_form_fields');
                                  safeSetState(() {
                                    _model.contentTextController?.clear();
                                    _model.typeText = false;
                                  });
                                  logFirebaseEvent('content_backend_call');
                                  _model.createCopy =
                                      await ChatsMessageTable().insert({
                                    'chatId': widget.chatId,
                                    'content': messageText,
                                    'typeMessage':
                                        MessageSendType.Contractor.name,
                                    'sendType': TypeMessage.text.name,
                                  });
                                  if (_model.chatListController?.hasClients ?? false) {
                                    _model.chatListController!.animateTo(
                                      0.0,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                },
                                autofocus: false,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: TextInputAction.send,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: false,
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  hintText: 'Digite seu mensagem...',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF212121),
                                      fontSize: 13.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                validator: _model.contentTextControllerValidator
                                    .asValidator(context),
                                inputFormatters: [
                                  if (!isAndroid && !isiOS)
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      return TextEditingValue(
                                        selection: newValue.selection,
                                        text: newValue.text.toCapitalization(
                                            TextCapitalization.sentences),
                                      );
                                    }),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, -1.0),
                              child: Container(
                                height: 50.0,
                                decoration: BoxDecoration(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        if (_model.typeText) {
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              logFirebaseEvent(
                                                  'CHAT_PAGE_PAGE_Icon_e39tvqkj_ON_TAP');
                                              final messageText = _model.contentTextController.text;
                                              logFirebaseEvent(
                                                  'Icon_backend_call');
                                              _model.create =
                                                  await ChatsMessageTable()
                                                      .insert({
                                                'chatId': widget.chatId,
                                                'content': messageText,
                                                'typeMessage': MessageSendType
                                                    .Contractor.name,
                                                'sendType':
                                                    TypeMessage.text.name,
                                              });
                                              logFirebaseEvent(
                                                  'Icon_reset_form_fields');
                                              safeSetState(() {
                                                _model.contentTextController
                                                    ?.clear();
                                                _model.typeText = false;
                                              });
                                              if (_model.chatListController?.hasClients ?? false) {
                                                _model.chatListController!.animateTo(
                                                  0.0,
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeOut,
                                                );
                                              }
                                            },
                                            child: Icon(
                                              Icons.send_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 30.0,
                                            ),
                                          );
                                        } else {
                                          return Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  logFirebaseEvent(
                                                      'CHAT_PAGE_PAGE_Icon_10oj85wz_ON_TAP');
                                                  logFirebaseEvent(
                                                      'Icon_upload_media_to_supabase');
                                                  final selectedMedia =
                                                      await selectMediaWithSourceBottomSheet(
                                                    context: context,
                                                    storageFolderPath:
                                                        FFAppState().serviceId,
                                                    imageQuality: 70,
                                                    maxWidth: 1080.0,
                                                    allowPhoto: true,
                                                    allowVideo: true,
                                                    includeBlurHash: true,
                                                  );
                                                  if (selectedMedia != null &&
                                                      selectedMedia.every((m) =>
                                                          validateFileFormat(
                                                              m.storagePath,
                                                              context))) {
                                                    safeSetState(() => _model
                                                            .isDataUploading_uploadDataDgg =
                                                        true);
                                                    var selectedUploadedFiles =
                                                        <FFUploadedFile>[];

                                                    var downloadUrls =
                                                        <String>[];
                                                    try {
                                                      showUploadMessage(context, 'Subindo...', showLoading: true);
                                                      selectedUploadedFiles =
                                                          selectedMedia
                                                              .map((m) =>
                                                                  FFUploadedFile(
                                                                    name: m
                                                                        .storagePath
                                                                        .split(
                                                                            '/')
                                                                        .last,
                                                                    bytes:
                                                                        m.bytes,
                                                                    height: m
                                                                        .dimensions
                                                                        ?.height,
                                                                    width: m
                                                                        .dimensions
                                                                        ?.width,
                                                                    blurHash: m
                                                                        .blurHash,
                                                                    originalFilename:
                                                                        m.originalFilename,
                                                                  ))
                                                              .toList();

                                                      downloadUrls =
                                                          await uploadSupabaseStorageFiles(
                                                        bucketName: 'App',
                                                        selectedFiles:
                                                            selectedMedia,
                                                      );
                                                    } finally {
                                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                      _model.isDataUploading_uploadDataDgg =
                                                          false;
                                                    }
                                                    if (selectedUploadedFiles
                                                                .length ==
                                                            selectedMedia
                                                                .length &&
                                                        downloadUrls.length ==
                                                            selectedMedia
                                                                .length) {
                                                      safeSetState(() {
                                                        _model.uploadedLocalFile_uploadDataDgg =
                                                            selectedUploadedFiles
                                                                .first;
                                                        _model.uploadedFileUrl_uploadDataDgg =
                                                            downloadUrls.first;
                                                      });
                                                      showUploadMessage(context, 'Sucesso!');
                                                    } else {
                                                      safeSetState(() {});
                                                      return;
                                                    }

                                                    logFirebaseEvent(
                                                        'Icon_backend_call');
                                                    await ChatsMessageTable()
                                                        .insert({
                                                      'chatId': widget.chatId,
                                                      'content': _model
                                                          .uploadedFileUrl_uploadDataDgg,
                                                      'sendType':
                                                          TypeMessage.image.name,
                                                      'typeMessage':
                                                          MessageSendType
                                                              .Contractor.name,
                                                    });
                                                    if (_model.chatListController?.hasClients ?? false) {
                                                      _model.chatListController!.animateTo(
                                                        0.0,
                                                        duration: Duration(milliseconds: 300),
                                                        curve: Curves.easeOut,
                                                      );
                                                    }
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.camera_alt_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 30.0,
                                                ),
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (_model.isRecording) {
                                                    // Stop recording and send
                                                    final audioPath =
                                                        await stopAudioRecording();
                                                    safeSetState(() {
                                                      _model.isRecording =
                                                          false;
                                                    });
                                                    if (audioPath != null) {
                                                      // Upload to Supabase Storage
                                                      final file =
                                                          File(audioPath);
                                                      final bytes =
                                                          await file
                                                              .readAsBytes();
                                                      final fileName =
                                                          'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
                                                      final storagePath =
                                                          '${FFAppState().serviceId}/$fileName';

                                                      await SupaFlow
                                                          .client.storage
                                                          .from('App')
                                                          .uploadBinary(
                                                            storagePath,
                                                            bytes,
                                                            fileOptions:
                                                                FileOptions(
                                                              contentType:
                                                                  'audio/mp4',
                                                            ),
                                                          );

                                                      final audioUrl = SupaFlow
                                                          .client.storage
                                                          .from('App')
                                                          .getPublicUrl(
                                                              storagePath);

                                                      await ChatsMessageTable()
                                                          .insert({
                                                        'chatId':
                                                            widget.chatId,
                                                        'content': audioUrl,
                                                        'sendType': TypeMessage
                                                            .audio.name,
                                                        'typeMessage':
                                                            MessageSendType
                                                                .Contractor
                                                                .name,
                                                      });
                                                    }
                                                  } else {
                                                    // Start recording
                                                    final started =
                                                        await startAudioRecording();
                                                    if (started) {
                                                      safeSetState(() {
                                                        _model.isRecording =
                                                            true;
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Icon(
                                                  _model.isRecording
                                                      ? Icons.stop_circle
                                                      : Icons.mic_rounded,
                                                  color: _model.isRecording
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .error
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  size: 30.0,
                                                ),
                                              ),
                                            ].divide(SizedBox(width: 15.0)),
                                          );
                                        }
                                      },
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 9.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
