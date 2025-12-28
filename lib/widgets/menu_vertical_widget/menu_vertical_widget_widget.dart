import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/not_access_widget/not_access_widget_widget.dart';
import '/widgets/option_service_widget/option_service_widget_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuVerticalWidgetModel());

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

    return FutureBuilder<List<MenusRow>>(
      future: MenusTable().queryRows(
        queryFn: (q) => q
            .eqOrNull(
              'active',
              true,
            )
            .order('order', ascending: true),
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
        List<MenusRow> containerMenusRowList = snapshot.data!;

        return Container(
          width: double.infinity,
          height: 100.0,
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
                          width: 100.0,
                          height: 100.0,
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
                                if (FFAppState().typecompany != '') {
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
                                              child:
                                                  OptionServiceWidgetWidget(),
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
                                } else {
                                  logFirebaseEvent('Image_alert_dialog');
                                  await showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return Dialog(
                                        elevation: 0,
                                        insetPadding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                        child: NotAccessWidgetWidget(),
                                      );
                                    },
                                  );
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
                    }).divide(SizedBox(width: 15.0)),
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
