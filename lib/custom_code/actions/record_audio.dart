// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import "package:utility_functions_library_8g4bud/backend/schema/structs/index.dart"
    as utility_functions_library_8g4bud_data_schema;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

final AudioRecorder _recorder = AudioRecorder();

Future<bool> startAudioRecording() async {
  try {
    if (await _recorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );
      return true;
    }
    return false;
  } catch (e) {
    debugPrint('Error starting recording: $e');
    return false;
  }
}

Future<String?> stopAudioRecording() async {
  try {
    final path = await _recorder.stop();
    return path;
  } catch (e) {
    debugPrint('Error stopping recording: $e');
    return null;
  }
}

Future<void> cancelAudioRecording() async {
  try {
    await _recorder.stop();
  } catch (e) {
    debugPrint('Error canceling recording: $e');
  }
}
