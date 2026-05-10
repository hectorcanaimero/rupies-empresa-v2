import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/option_service_widget/option_service_widget_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'menu_vertical_widget_model.dart';
export 'menu_vertical_widget_model.dart';

class MenuVerticalWidgetWidget extends StatefulWidget {
  const MenuVerticalWidgetWidget({super.key});

  @override
  State<MenuVerticalWidgetWidget> createState() =>
      _MenuVerticalWidgetWidgetState();
}

class _MenuVerticalWidgetWidgetState extends State<MenuVerticalWidgetWidget> {
  late MenuVerticalWidgetModel _model;
  Future<List<MenusRow>>? _menusFuture;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuVerticalWidgetModel());

    _menusFuture = MenusTable().queryRows(
      queryFn: (q) => q
          .eqOrNull(
            'active',
            true,
          )
          .order('order', ascending: true),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MenusRow>>(
      future: _menusFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Shimmer.fromColors(
            baseColor: FlutterFlowTheme.of(context).alternate,
            highlightColor:
                FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (i) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.5),
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        List<MenusRow> containerMenusRowList = snapshot.data!;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(),
          child: Visibility(
            visible: containerMenusRowList.isNotEmpty,
            child: Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Builder(
                builder: (context) {
                  final containerVar = containerMenusRowList.toList();

                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List.generate(containerVar.length, (containerVarIndex) {
                      final containerVarItem = containerVar[containerVarIndex];
                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          child: Builder(
                            builder: (context) => InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                logFirebaseEvent(
                                    'MENU_VERTICAL_WIDGET_Image_v0jikzc4_ON_T');
                                if (containerVarItem.internal!) {
                                  if ((String var1) {
                                    return var1.contains('function:');
                                  }(containerVarItem.url!)) {
                                    logFirebaseEvent('Image_alert_dialog');
                                    await showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return Dialog(
                                          elevation: 0,
                                          insetPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          alignment: AlignmentDirectional(
                                                  0.0, 0.0)
                                              .resolve(
                                                  Directionality.of(context)),
                                          child: Container(
                                            height: 180.0,
                                            child: OptionServiceWidgetWidget(),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    logFirebaseEvent('Image_custom_action');
                                    await actions.linkTo(
                                      context,
                                      containerVarItem.url!,
                                    );
                                  }
                                } else {
                                  logFirebaseEvent('Image_launch_u_r_l');
                                  await launchURL(containerVarItem.url!);
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9.0),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 500),
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  imageUrl: valueOrDefault<String>(
                                    containerVarItem.image,
                                    'https://picsum.photos/seed/396/600',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).divide(SizedBox(width: 9.0)),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
