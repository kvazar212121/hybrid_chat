import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoView extends StatelessWidget {
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;

  const VideoView({
    super.key,
    required this.localRenderer,
    required this.remoteRenderer,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Asosiy fon (Remote video)
        Container(
          color: Colors.black,
          child: RTCVideoView(
            remoteRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
        ),
        // Kichik oyna (Local video)
        Positioned(
          right: 20,
          top: 100,
          child: Container(
            width: 120,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: RTCVideoView(
              localRenderer,
              mirror: true,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),
        ),
      ],
    );
  }
}
