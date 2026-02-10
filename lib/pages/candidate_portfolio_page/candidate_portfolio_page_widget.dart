import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'candidate_portfolio_page_model.dart';
export 'candidate_portfolio_page_model.dart';

class CandidatePortfolioPageWidget extends StatefulWidget {
  const CandidatePortfolioPageWidget({
    super.key,
    required this.user,
  });

  final UsersRow? user;

  static String routeName = 'CandidatePortfolioPage';
  static String routePath = 'candidatePortfolioPage';

  @override
  State<CandidatePortfolioPageWidget> createState() =>
      _CandidatePortfolioPageWidgetState();
}

class _CandidatePortfolioPageWidgetState
    extends State<CandidatePortfolioPageWidget> {
  late CandidatePortfolioPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CandidatePortfolioPageModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'CandidatePortfolioPage'});
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
              logFirebaseEvent('CANDIDATE_PORTFOLIO_arrow_back_rounded_I');
              logFirebaseEvent('IconButton_navigate_back');
              context.pop();
            },
          ),
          title: Text(
            'Portfolio',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                child: FutureBuilder<List<ViewUsersSkillWithCategoriesRow>>(
                  future: ViewUsersSkillWithCategoriesTable().queryRows(
                    queryFn: (q) => q
                        .eqOrNull(
                          'userId',
                          widget.user?.id,
                        )
                        .order('category_name', ascending: true),
                  ),
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
                    List<ViewUsersSkillWithCategoriesRow>
                        wrapViewUsersSkillWithCategoriesRowList =
                        snapshot.data!;

                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      runAlignment: WrapAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      clipBehavior: Clip.none,
                      children: List.generate(
                          wrapViewUsersSkillWithCategoriesRowList.length,
                          (wrapIndex) {
                        final wrapViewUsersSkillWithCategoriesRow =
                            wrapViewUsersSkillWithCategoriesRowList[wrapIndex];
                        return Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 3.0, 8.0, 3.0),
                            child: Text(
                              valueOrDefault<String>(
                                wrapViewUsersSkillWithCategoriesRow
                                    .categoryName,
                                'categoria',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 6.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(),
                  child: Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Text(
                      valueOrDefault<String>(
                        widget.user?.bio,
                        'Bio',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                ),
              ),
              Container(
                decoration: BoxDecoration(),
                child: FutureBuilder<List<UsersPortfolioRow>>(
                  future: UsersPortfolioTable().queryRows(
                    queryFn: (q) => q
                        .eqOrNull(
                          'userId',
                          widget.user?.id,
                        )
                        .order('created_at'),
                  ),
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
                    List<UsersPortfolioRow> listViewUsersPortfolioRowList =
                        snapshot.data!;

                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        15.0,
                        0,
                        24.0,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listViewUsersPortfolioRowList.length,
                      itemBuilder: (context, listViewIndex) {
                        final listViewUsersPortfolioRow =
                            listViewUsersPortfolioRowList[listViewIndex];
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 4.0, 12.0, 15.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        logFirebaseEvent(
                                            'CANDIDATE_PORTFOLIO_Image_97c17y1u_ON_TA');
                                        logFirebaseEvent('Image_expand_image');
                                        await Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.fade,
                                            child: FlutterFlowExpandedImageView(
                                              image: Image.network(
                                                valueOrDefault<String>(
                                                  listViewUsersPortfolioRow
                                                      .images,
                                                  'https://picsum.photos/seed/511/600',
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                              allowRotation: false,
                                              tag: valueOrDefault<String>(
                                                listViewUsersPortfolioRow
                                                    .images,
                                                'https://picsum.photos/seed/511/600' +
                                                    '$listViewIndex',
                                              ),
                                              useHeroAnimation: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: valueOrDefault<String>(
                                          listViewUsersPortfolioRow.images,
                                          'https://picsum.photos/seed/511/600' +
                                              '$listViewIndex',
                                        ),
                                        transitionOnUserGestures: true,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            valueOrDefault<String>(
                                              listViewUsersPortfolioRow.images,
                                              'https://picsum.photos/seed/511/600',
                                            ),
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  1.0, 0.0),
                                              child: Text(
                                                dateTimeFormat(
                                                  "d/M/y",
                                                  listViewUsersPortfolioRow
                                                      .createdAt,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                            Text(
                                              valueOrDefault<String>(
                                                listViewUsersPortfolioRow
                                                    .description,
                                                'Description',
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                                Divider(
                                  thickness: 2.0,
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
