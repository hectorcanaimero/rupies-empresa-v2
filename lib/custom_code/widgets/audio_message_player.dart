// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import "package:utility_functions_library_8g4bud/backend/schema/structs/index.dart"
    as utility_functions_library_8g4bud_data_schema;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:just_audio/just_audio.dart';

class AudioMessagePlayer extends StatefulWidget {
  const AudioMessagePlayer({
    super.key,
    required this.audioUrl,
    this.width,
    this.height,
    this.isOwn = true,
  });

  final String audioUrl;
  final double? width;
  final double? height;
  final bool isOwn;

  @override
  State<AudioMessagePlayer> createState() => _AudioMessagePlayerState();
}

class _AudioMessagePlayerState extends State<AudioMessagePlayer> {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      final duration = await _player.setUrl(widget.audioUrl);
      if (duration != null && mounted) {
        setState(() {
          _duration = duration;
          _isLoaded = true;
        });
      }

      _player.positionStream.listen((position) {
        if (mounted) {
          setState(() => _position = position);
        }
      });

      _player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() => _isPlaying = state.playing);
          if (state.processingState == ProcessingState.completed) {
            _player.seek(Duration.zero);
            _player.pause();
          }
        }
      });
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (!_isLoaded) return;
            if (_isPlaying) {
              _player.pause();
            } else {
              _player.play();
            }
          },
          child: Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: widget.isOwn ? Color(0xFF075E54) : Color(0xFF128C7E),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 20.0,
            ),
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0),
                  activeTrackColor: Color(0xFF075E54),
                  inactiveTrackColor: Color(0xFFB0BEC5),
                  thumbColor: Color(0xFF075E54),
                ),
                child: Slider(
                  min: 0.0,
                  max: _duration.inMilliseconds.toDouble(),
                  value: _position.inMilliseconds
                      .toDouble()
                      .clamp(0.0, _duration.inMilliseconds.toDouble()),
                  onChanged: (value) {
                    _player.seek(Duration(milliseconds: value.toInt()));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  _isPlaying
                      ? _formatDuration(_position)
                      : _formatDuration(_duration),
                  style: TextStyle(
                    fontSize: 11.0,
                    color: Color(0xFF667781),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
