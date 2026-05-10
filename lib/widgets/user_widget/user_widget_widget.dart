import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/pages/notifications_page/notifications_page_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'user_widget_model.dart';
export 'user_widget_model.dart';

class UserWidgetWidget extends StatefulWidget {
  const UserWidgetWidget({super.key});

  @override
  State<UserWidgetWidget> createState() => _UserWidgetWidgetState();
}

class _UserWidgetWidgetState extends State<UserWidgetWidget> {
  late UserWidgetModel _model;
  Future<List<ViewServiceRatingRow>>? _ratingFuture;
  Future<int>? _notificationCountFuture;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserWidgetModel());

    _ratingFuture = ViewServiceRatingTable().queryRows(
      queryFn: (q) => q.eqOrNull('sr_contractor', currentUserUid),
    );
    _notificationCountFuture = SupaFlow.client
        .from('notifications')
        .select('id')
        .eq('recipient_id', currentUserUid)
        .eq('is_read', false)
        .then<int>((data) => (data as List).length);

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 43.0,
              height: 43.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).info,
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 500),
                    fadeOutDuration: Duration(milliseconds: 500),
                    imageUrl: valueOrDefault<String>(
                      FFAppState().user.photoUrl,
                      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/rupies-profissional-93jipj/assets/i2ozq2kadrah/dog_avatar.gif',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ViewServiceRatingRow>>(
                future: _ratingFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Shimmer.fromColors(
                      baseColor: FlutterFlowTheme.of(context).alternate,
                      highlightColor: FlutterFlowTheme.of(context)
                          .alternate
                          .withValues(alpha: 0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 14.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).alternate,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Container(
                            height: 12.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).alternate,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  List<ViewServiceRatingRow> containerViewServiceRatingRowList =
                      snapshot.data!;

                  return Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFAppState().user.displayName,
                          style: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: valueOrDefault<String>(
                                      formatNumber(
                                        functions.calcularMediaPrestador(
                                            containerViewServiceRatingRowList
                                                .toList()),
                                        formatType: FormatType.decimal,
                                        decimalType: DecimalType.periodDecimal,
                                      ),
                                      '3',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  )
                                ],
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                            RatingBarIndicator(
                              itemBuilder: (context, index) => Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFC52B),
                              ),
                              direction: Axis.horizontal,
                              rating: valueOrDefault<double>(
                                functions.calcularMediaPrestador(
                                    containerViewServiceRatingRowList.toList()),
                                3.0,
                              ),
                              unratedColor:
                                  FlutterFlowTheme.of(context).alternate,
                              itemCount: 5,
                              itemSize: 18.0,
                            ),
                          ].divide(SizedBox(width: 6.0)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            FutureBuilder<int>(
              future: _notificationCountFuture,
              builder: (context, snapshot) {
                final unreadCount = snapshot.data ?? 0;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 26.0,
                      ),
                      onPressed: () => context
                          .pushNamed(NotificationsPageWidget.routeName),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).error,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              unreadCount > 9 ? '9+' : '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
      ),
    );
  }
}
