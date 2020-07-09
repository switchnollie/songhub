import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:song_hub/components/recording_grid_items.dart';

class RecordingPlayback extends StatefulWidget {
  final String recordingUrl;

  RecordingPlayback({this.recordingUrl});

  @override
  _RecordingPlaybackState createState() => _RecordingPlaybackState();
}

class _RecordingPlaybackState extends State<RecordingPlayback> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  VideoPlayerController _controller;
  bool isSimulator = false;
  bool isPlaying = false;
  bool loaded = true;
  String fileUrl;

  /// Initialize audio playback
  void initRecordingPlayback(String fileUrl) async {
    bool isIosSimulator = false;
    setState(() {
      loaded = false;
    });

    Timer(Duration(milliseconds: 200), () async {
      try {
        if (Platform.isIOS) {
          IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
          isIosSimulator = !data.isPhysicalDevice;
        }
      } on PlatformException {
        print('Error:: Failed to get platform version.');
      }

      setState(() {
        isSimulator = isIosSimulator;
      });

      if (!isSimulator) {
        try {
          _controller = VideoPlayerController.network(fileUrl);
          _controller.setLooping(true);
          _controller.initialize();
          setState(() {
            loaded = true;
            isPlaying = true;
            _controller.play();
          });
        } catch (e) {
          print('Couldn\'t get audio from Storage! $e');
        }
      }
    });
  }

  /// onTap function for grid playback box footer
  void onRecordingPlayback(fileUrl) {
    if (_controller == null) {
      initRecordingPlayback(fileUrl);
    } else {
      setState(() {
        if (_controller.value.isPlaying) {
          isPlaying = false;
          _controller.pause();
        } else {
          isPlaying = true;
          _controller.play();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RecordingGridItemPlayback(
      onTap: () => onRecordingPlayback(widget.recordingUrl),
      isDisabled: isSimulator,
      isPlaying: isPlaying,
      loaded: loaded,
    );
  }
}
