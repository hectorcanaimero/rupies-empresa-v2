import '/flutter_flow/flutter_flow_util.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'load_widget_model.dart';
export 'load_widget_model.dart';

class LoadWidgetWidget extends StatefulWidget {
  const LoadWidgetWidget({
    super.key,
    double? height,
    this.message,
  }) : this.height = height ?? 380.0;

  final double height;
  final String? message;

  @override
  State<LoadWidgetWidget> createState() => _LoadWidgetWidgetState();
}

class _LoadWidgetWidgetState extends State<LoadWidgetWidget> {
  late LoadWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadWidgetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.message != null && widget.message != '')
            Text(
              valueOrDefault<String>(
                widget.message,
                '  Mensagem',
              ),
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.interTight(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
            ),
          Lottie.asset(
            'assets/jsons/Data_Analysis.json',
            width: 300.0,
            height: 260.0,
            fit: BoxFit.contain,
            reverse: true,
            animate: true,
          ),
        ],
      ),
    );
  }
}
