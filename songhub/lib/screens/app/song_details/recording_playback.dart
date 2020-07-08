import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

/// A component to display a playback button for a recording item
class BoxPlayback extends StatefulWidget {
  final String storagePath;

  BoxPlayback({@required this.storagePath});

  @override
  _BoxPlaybackState createState() => _BoxPlaybackState();
}

class _BoxPlaybackState extends State<BoxPlayback> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  String fileUrl;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  bool _isIosSimulator = false;
  // VoidCallback listener;
  // bool _isPlaying;

  @override
  void initState() {
    super.initState();
    // listener = () {
    //   final bool isPlaying = _controller.value.isPlaying;
    //   if (isPlaying != _isPlaying) {
    //     setState(() {
    //       _isPlaying = isPlaying;
    //     });
    //   }
    // };
    initAudioPlayback(widget.storagePath);
  }

  Future<void> checkIfSimulator() async {
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
      _isIosSimulator = isIosSimulator;
    });
  }

  /// Initialize video player and fetch downloadUrl of file
  void initAudioPlayback(String storagePath) async {
    await checkIfSimulator();

    if (!_isIosSimulator) {
      try {
        FirebaseStorage _storage = FirebaseStorage.instance;
        final String currentUrl =
            await _storage.ref().child(storagePath).getDownloadURL();

        setState(() {
          fileUrl = currentUrl;
        });
        _controller = VideoPlayerController.network(fileUrl);
        _controller.setLooping(true);
        // ..addListener(listener);
        _initializeVideoPlayerFuture = _controller.initialize();
      } catch (e) {
        print('Couldn\'t get audio from Storage! $e');
      }
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  // TODO: Move functionality out of component
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: !_isIosSimulator
          ? FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(),
                  );
                }
              })
          : Icon(Icons.block, color: Theme.of(context).colorScheme.onSurface),
    );
  }
}
