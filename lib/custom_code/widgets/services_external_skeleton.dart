// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import "package:utility_functions_library_8g4bud/backend/schema/structs/index.dart"
    as utility_functions_library_8g4bud_data_schema;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:shimmer/shimmer.dart';

class ServicesExternalSkeleton extends StatelessWidget {
  const ServicesExternalSkeleton({Key? key, this.width, this.height})
      : super(key: key);

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: width,
      color: theme.primary,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Shimmer.fromColors(
        baseColor: theme.primary.withOpacity(0.55),
        highlightColor: theme.primaryBackground.withOpacity(0.35),
        period: const Duration(milliseconds: 1400),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            4,
            (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 56,
                  height: 10,
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
