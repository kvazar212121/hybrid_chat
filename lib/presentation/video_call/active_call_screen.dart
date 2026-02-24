import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../service_locator.dart';
import '../../data/services/webrtc_handler.dart';
import 'widgets/video_view.dart';
import 'widgets/translation_overlay.dart';

class ActiveCallScreen extends StatefulWidget {
  final String userName;
  final String myLang;       // Bu qurilma tili (masalan "en")
  final String remoteLang;   // Narigi qurilma tili (masalan "ru")

  const ActiveCallScreen({
    super.key,
    required this.userName,
    this.myLang = "en",
    this.remoteLang = "ru",
  });

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  bool _isMicOn = false;

  // Men gapirayotgan matn (STT dan)
  String _myText = "";

  // Narigi qurilmadan tarjima bo'lib kelgan matn
  String _receivedTranslation = "";

  StreamSubscription? _sttSub;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  WebRTCHandler? _handler;

  @override
  void initState() {
    super.initState();
    _initWebRTC();
  }

  Future<void> _initWebRTC() async {
    // Ruxsatlarni tekshirish
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.microphone] != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kamera yoki mikrofon ruxsati berilmadi!")),
        );
      }
      return;
    }

    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    final roomId = widget.userName.replaceAll(' ', '_').toLowerCase();
    _handler = WebRTCHandler(serverUrl: "$kServerWsUrl/ws/$roomId");

    // Narigi qurilmadan tarjima bo'lib kelsa
    _handler!.onTranslationReceived = (original, translated) {
      setState(() {
        _receivedTranslation = translated;
      });
      // Narigi kishi gapirganini bu qurilmada ovoz chiqarib bering
      tts.speak(translated);
    };

    _handler!.onRemoteStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    };

    await _handler!.init(_localRenderer);
  }

  @override
  void dispose() {
    _sttSub?.cancel();
    stt.stopListening();
    tts.stop();
    _handler?.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  void _toggleMic() {
    setState(() => _isMicOn = !_isMicOn);

    if (_isMicOn) {
      stt.startListening();
      _sttSub = stt.textStream.listen((text) {
        if (text.trim().isEmpty) return;
        setState(() => _myText = text);

        // Men gapirganim → server orqali tarjima bo'lib narigi tomonga ketadi
        _handler?.sendSpeechText(
          text,
          fromLang: widget.myLang,
          toLang: widget.remoteLang,
        );
      });
    } else {
      _sttSub?.cancel();
      _sttSub = null;
      stt.stopListening();
      tts.stop();
    }
  }

  void _endCall() {
    Navigator.pop(context);
  }

  void _startCall() {
    _handler?.createOffer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video ko'rinish
          VideoView(
            localRenderer: _localRenderer,
            remoteRenderer: _remoteRenderer,
          ),

          // Yuqori: Xona nomi + Boshlash tugmasi
          Positioned(
            top: 48,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Xona: ${widget.userName}",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _startCall,
                  icon: const Icon(Icons.call, size: 16),
                  label: const Text("Boshlash"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),

          // Men gapirgan matn (STT, pastda)
          if (_myText.isNotEmpty)
            Positioned(
              bottom: 140,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Men:", style: TextStyle(color: Colors.white70, fontSize: 11)),
                    Text(_myText, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ),

          // Narigi qurilmadan kelgan tarjima (ustda)
          TranslationOverlay(
            originalText: "",
            translatedText: _receivedTranslation,
          ),

          // Pastki: Tugmalar
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'mic_btn',
                  onPressed: _toggleMic,
                  backgroundColor: _isMicOn ? Colors.blueAccent : Colors.grey[800],
                  child: Icon(_isMicOn ? Icons.mic : Icons.mic_off),
                ),
                const SizedBox(width: 40),
                FloatingActionButton(
                  heroTag: 'end_call_btn',
                  onPressed: _endCall,
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.call_end),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
