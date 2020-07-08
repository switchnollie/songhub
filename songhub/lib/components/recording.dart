// import 'dart:io';

// import 'package:device_info/device_info.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:song_hub/viewModels/recording_with_images.dart';
// import 'package:song_hub/viewModels/song_with_images.dart';
// import 'package:video_player/video_player.dart';

// /// A component to display a recording input container
// class RecordingInputItem extends StatelessWidget {
//   final SongWithImages song;
//   final String heroTag;
//   final Function onPressed;

//   RecordingInputItem(
//       {@required this.song, @required this.heroTag, @required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: "$heroTag",
//       child: Material(
//         child: Container(
//           color: Theme.of(context).colorScheme.background,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(14.0),
//             child: Container(
//               color: Theme.of(context).colorScheme.surface,
//               child: Center(
//                 child: IconButton(icon: Icon(Icons.add), onPressed: onPressed),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// A component to display a specific recording item
// class RecordingItem extends StatelessWidget {
//   final SongWithImages song;
//   final RecordingWithImages recording;
//   final String index;
//   final Function onTap;

//   RecordingItem(
//       {@required this.song,
//       @required this.recording,
//       @required this.onTap,
//       this.index});

//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: index,
//       child: Material(
//         child: InkWell(
//           onTap: onTap,
//           child: Container(
//             color: Theme.of(context).colorScheme.background,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(14.0),
//               child: Container(
//                 color: Theme.of(context).colorScheme.surface,
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   children: <Widget>[
//                     RecordingItemHeader(recording: recording),
//                     RecordingItemBody(recording: recording),
//                     RecordingPlaybackButton(recording: recording),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// A component to display a header for an recording item
// class RecordingItemHeader extends StatelessWidget {
//   final RecordingWithImages recording;

//   RecordingItemHeader({@required this.recording});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.topLeft,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Icon(
//                 Icons.timeline,
//                 size: 16,
//                 color: Theme.of(context).colorScheme.onSurface,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 4.0),
//                 child: Text(
//                   DateFormat('yyyy-MM-dd').format(
//                       recording.recordingDocument.updatedAt != null
//                           ? recording.recordingDocument.updatedAt.toDate()
//                           : recording.recordingDocument.createdAt.toDate()),
//                   style:
//                       TextStyle(color: Theme.of(context).colorScheme.onSurface),
//                 ),
//               ),
//             ],
//           ),
//           recording.recordingDocument.creator != null
//               ? CircleAvatar(
//                   child: ClipOval(
//                     child: Image.network(recording.creatorImgUrl),
//                   ),
//                   radius: 14,
//                 )
//               : Icon(
//                   Icons.account_circle,
//                   color: Theme.of(context).colorScheme.onSurface,
//                   size: 28,
//                 )
//         ],
//       ),
//     );
//   }
// }

// /// A component to display a body for a recording item
// class RecordingItemBody extends StatelessWidget {
//   final RecordingWithImages recording;

//   RecordingItemBody({@required this.recording});

//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       flex: 1,
//       child: Container(
//         alignment: Alignment.centerLeft,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(bottom: 4.0),
//               child: Text(
//                 recording.recordingDocument.label,
//                 style: TextStyle(
//                   color: Theme.of(context).accentColor,
//                 ),
//               ),
//             ),
//             Text(
//               recording.recordingDocument.versionDescription,
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// A component to display a playback button for a recording item
// class RecordingPlaybackButton extends StatefulWidget {
//   final RecordingWithImages recording;

//   RecordingPlaybackButton({this.recording});

//   @override
//   _RecordingPlaybackButtonState createState() =>
//       _RecordingPlaybackButtonState();
// }

// class _RecordingPlaybackButtonState extends State<RecordingPlaybackButton> {
//   VideoPlayerController _controller;
//   Future<void> _initializeVideoPlayerFuture;
//   String fileUrl;
//   static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//   bool _isIosSimulator = false;
//   // VoidCallback listener;
//   // bool _isPlaying;

//   @override
//   void initState() {
//     super.initState();
//     // listener = () {
//     //   final bool isPlaying = _controller.value.isPlaying;
//     //   if (isPlaying != _isPlaying) {
//     //     setState(() {
//     //       _isPlaying = isPlaying;
//     //     });
//     //   }
//     // };
//     initAudioPlayback(widget.recording.recordingDocument.storagePath);
//   }

//   Future<void> checkIfSimulator() async {
//     bool isIosSimulator = false;

//     try {
//       if (Platform.isIOS) {
//         IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
//         isIosSimulator = data.isPhysicalDevice == false ? true : false;
//       }
//     } on PlatformException {
//       print('Error:: Failed to get platform version.');
//     }

//     setState(() {
//       _isIosSimulator = isIosSimulator;
//     });
//   }

//   /// Initialize video player and fetch downloadUrl of file
//   void initAudioPlayback(String storagePath) async {
//     await checkIfSimulator();

//     if (!_isIosSimulator) {
//       try {
//         FirebaseStorage _storage = FirebaseStorage.instance;
//         final String currentUrl =
//             await _storage.ref().child(storagePath).getDownloadURL();

//         setState(() {
//           fileUrl = currentUrl;
//         });
//         _controller = VideoPlayerController.network(fileUrl);
//         _controller.setLooping(true);
//         // ..addListener(listener);
//         _initializeVideoPlayerFuture = _controller.initialize();
//       } catch (e) {
//         print('Couldn\'t get audio from Storage! $e');
//       }
//     }
//   }

//   @override
//   void dispose() {
//     if (_controller != null) {
//       _controller.dispose();
//     }
//     super.dispose();
//   }

//   // TODO: Move functionality out of component
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomRight,
//       child: !_isIosSimulator
//           ? FutureBuilder(
//               future: _initializeVideoPlayerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return InkWell(
//                     onTap: () {
//                       setState(() {
//                         _controller.value.isPlaying
//                             ? _controller.pause()
//                             : _controller.play();
//                       });
//                     },
//                     child: Icon(
//                       _controller.value.isPlaying
//                           ? Icons.pause
//                           : Icons.play_arrow,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   );
//                 } else {
//                   return SizedBox(
//                     height: 24,
//                     width: 24,
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               })
//           : Icon(Icons.block, color: Theme.of(context).colorScheme.onSurface),
//     );
//   }
// }
