// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:song_hub/components/recording_grid_items.dart';
import 'package:path/path.dart' as Path;

/// A widgets that builds and handles all audio playbacks.
///
/// This widget builds a [RecordingGridItemPlayback] widget to allow audio
/// playback defined in this widgets methods.
class RecordingPlayback extends StatefulWidget {
  final String recordingUrl;

  RecordingPlayback({this.recordingUrl});

  @override
  _RecordingPlaybackState createState() => _RecordingPlaybackState();
}

class _RecordingPlaybackState extends State<RecordingPlayback> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  VideoPlayerController _controller;
  bool isDisabled = false;
  bool isPlaying = false;
  bool loaded = true;
  String fileUrl;

  void initState() {
    super.initState();
    checkForPlaybackDisable();
  }

  /// Check if device is simulator or file is no audio format
  void checkForPlaybackDisable() async {
    bool isIosSimulator = false;
    try {
      if (Platform.isIOS) {
        IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        isIosSimulator = !data.isPhysicalDevice;
      }
    } on PlatformException {
      print('Error:: Failed to get platform version.');
    }

    setState(() {
      isDisabled =
          isIosSimulator || !['.mp3', '.wav'].contains(getFileExtension());
    });
  }

  /// Get file extension of recording file download url
  String getFileExtension() {
    final String fileExtension = Path.extension(widget.recordingUrl);
    final List subStrings = fileExtension.split('?');
    return subStrings[0];
  }

  /// Initialize audio playback
  void initRecordingPlayback(String fileUrl) async {
    setState(() {
      loaded = false;
    });

    if (!isDisabled) {
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
      isDisabled: isDisabled,
      isPlaying: isPlaying,
      loaded: loaded,
    );
  }
}
