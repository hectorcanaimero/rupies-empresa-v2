import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ff_commons/flutter_flow/lat_lng.dart';
import 'package:ff_commons/flutter_flow/place.dart';
import 'package:ff_commons/flutter_flow/uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import "package:utility_functions_library_8g4bud/backend/schema/structs/index.dart"
    as utility_functions_library_8g4bud_data_schema;
import 'package:utility_functions_library_8g4bud/flutter_flow/custom_functions.dart'
    as utility_functions_library_8g4bud_functions;

/// Parsea texto para Imagen
String parseTextToImage(String text) {
  return text;
}

/// Parsea de Texto para oAudio
String parseTextAudio(String text) {
  return text;
}

List<String> parseHour() {
  return [
    '00:00',
    '00:30',
    '01:00',
    '01:30',
    '02:00',
    '02:30',
    '03:00',
    '03:30',
    '04:00',
    '04:30',
    '05:00',
    '05:30',
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '12:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '15:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
    '23:30'
  ];
}

LatLng parseTextToLatLng(String location) {
  final regex = RegExp(r'LatLng\(lat:\s*(-?\d+\.\d+),\s*lng:\s*(-?\d+\.\d+)\)');
  final match = regex.firstMatch(location);
  if (match != null) {
    final latitude = double.parse(match.group(1)!);
    final longitude = double.parse(match.group(2)!);
    return LatLng(latitude, longitude);
  }
  throw FormatException('Invalid format');
}

bool validateTrial(dynamic trial) {
  int limit = int.parse(trial['limit']);
  int total = int.parse(trial['total']);
  if (limit <= total) {
    return true;
  }
  return false;
}

dynamic newValuetrial(
  dynamic trial,
  int newValue,
) {
  trial['limit'] = trial['limit'] + newValue;
  return trial;
}

double calcularMediaPrestador(List<ViewServiceRatingRow> ratings) {
  double suma = 0;
  int contador = 0;

  for (final row in ratings) {
    final rating = row.srContractorRating;
    ;

    if (rating != null) {
      final value = (rating as num).toDouble();
      if (value.isFinite) {
        suma += value;
        contador++;
      }
    }
  }

  if (contador == 0) return 0.0;
  final media = suma / contador;
  return double.parse(media.toStringAsFixed(1));
}
