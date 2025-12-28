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

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/services.dart';

class MoedaBRField extends StatefulWidget {
  const MoedaBRField({
    Key? key,
    this.width,
    this.height,
    required this.initialValue,
    required this.labelText,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String initialValue;
  final String labelText;

  @override
  _PriceFieldState createState() => _PriceFieldState();
}

class _PriceFieldState extends State<MoedaBRField> {
  late TextEditingController _priceEditingController;
  final currencyFormat = NumberFormat("#,##0.00", "pt_BR");

  @override
  void initState() {
    super.initState();
    _priceEditingController = TextEditingController();
    _priceEditingController.text = widget.initialValue;
  }

  @override
  void dispose() {
    _priceEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: TextField(
        controller: _priceEditingController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            final text = newValue.text;
            final selection = newValue.selection;
            if (text.isEmpty) {
              return TextEditingValue(text: '', selection: selection);
            } else if (text.length == 1) {
              final number = int.tryParse(text);
              if (number == null) {
                return oldValue;
              } else {
                final newText = '0.${number.toString()}';
                return TextEditingValue(
                  text: newText,
                  selection: TextSelection.collapsed(offset: newText.length),
                );
              }
            } else {
              final price = double.parse(text.replaceAll('.', '')) / 100;
              final newText = currencyFormat.format(price);
              FFAppState().update(() {
                FFAppState().propPrice = price;
              });
              final newSelectionIndex =
                  newText.length - (text.length - selection.end);
              return TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newSelectionIndex),
              );
            }
          })
        ],
        onChanged: (value) {},
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
              ),
          hintText: '1.000,00',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).error,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          prefix: Text(
            'R\$ ',
            style: TextStyle(
              color: Color.fromARGB(255, 87, 99, 108),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
