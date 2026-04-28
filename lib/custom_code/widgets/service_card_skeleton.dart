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

class ServiceCardSkeleton extends StatelessWidget {
  const ServiceCardSkeleton({
    Key? key,
    this.width,
    this.height,
    this.itemCount = 3,
  }) : super(key: key);

  final double? width;
  final double? height;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.alternate,
      highlightColor: theme.secondaryBackground,
      period: const Duration(milliseconds: 1400),
      child: Column(
        children: List.generate(
          itemCount,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: width ?? double.infinity,
              height: height ?? 110,
              decoration: BoxDecoration(
                color: theme.alternate,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: theme.alternate,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: theme.alternate,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 160,
                          height: 12,
                          decoration: BoxDecoration(
                            color: theme.alternate,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 10,
                          decoration: BoxDecoration(
                            color: theme.alternate,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
