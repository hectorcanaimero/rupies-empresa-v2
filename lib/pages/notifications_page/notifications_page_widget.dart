import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'notifications_page_model.dart';
export 'notifications_page_model.dart';

class NotificationsPageWidget extends StatefulWidget {
  const NotificationsPageWidget({super.key});

  static String routeName = 'NotificationsPage';
  static String routePath = 'notificationsPage';

  @override
  State<NotificationsPageWidget> createState() =>
      _NotificationsPageWidgetState();
}

class _NotificationsPageWidgetState extends State<NotificationsPageWidget> {
  late NotificationsPageModel _model;
  late Future<List<NotificationsRow>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsPageModel());
    _loadNotifications();
  }

  void _loadNotifications() {
    _notificationsFuture = NotificationsTable().queryRows(
      queryFn: (q) => q
          .eqOrNull('recipient_id', currentUserUid)
          .order('created_at', ascending: false),
    );
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _markAsRead(NotificationsRow notification) async {
    if (notification.isRead) return;
    await NotificationsTable().update(
      data: {'is_read': true},
      matchingRows: (rows) => rows.eqOrNull('id', notification.id),
    );
    safeSetState(() => _loadNotifications());
  }

  Future<void> _markAllAsRead() async {
    await NotificationsTable().update(
      data: {'is_read': true},
      matchingRows: (rows) =>
          rows.eqOrNull('recipient_id', currentUserUid).eqOrNull('is_read', false),
    );
    safeSetState(() => _loadNotifications());
  }

  Future<void> _deleteNotification(NotificationsRow notification) async {
    await NotificationsTable().delete(
      matchingRows: (rows) => rows.eqOrNull('id', notification.id),
    );
    safeSetState(() => _loadNotifications());
  }

  Future<void> _deleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir todas'),
        content:
            const Text('Tem certeza que deseja excluir todas as notificações?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await NotificationsTable().delete(
      matchingRows: (rows) => rows.eqOrNull('recipient_id', currentUserUid),
    );
    safeSetState(() => _loadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notificações',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                font: GoogleFonts.interTight(
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                ),
                letterSpacing: 0,
              ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            onSelected: (value) {
              switch (value) {
                case 'mark_all_read':
                  _markAllAsRead();
                  break;
                case 'delete_all':
                  _deleteAll();
                  break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all_rounded, size: 20),
                    SizedBox(width: 8),
                    Text('Marcar todas como lidas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Eliminar todas', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<NotificationsRow>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primary,
              ),
            );
          }

          final notifications = snapshot.data!;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 64,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nenhuma notificação',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: FlutterFlowTheme.of(context).alternate,
            ),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return Dismissible(
                key: ValueKey(notif.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) => _deleteNotification(notif),
                child: InkWell(
                onTap: () => _markAsRead(notif),
                child: Container(
                  color: notif.isRead
                      ? Colors.transparent
                      : FlutterFlowTheme.of(context).primary.withOpacity(0.06),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_rounded,
                          size: 20,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notif.title,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: notif.isRead
                                          ? FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .fontWeight
                                          : FontWeight.w600,
                                    ),
                                    letterSpacing: 0,
                                    fontWeight: notif.isRead
                                        ? FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight
                                        : FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              notif.body,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              timeago.format(
                                notif.createdAt,
                                locale: 'pt',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    font: GoogleFonts.inter(),
                                    letterSpacing: 0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            shape: BoxShape.circle,
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
  }
}
