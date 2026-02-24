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

    // Vosk STT modelini tekshirish
    await _setupRealSTT();
    
    // Video oqimi ulangach, UI ni yangilash shart
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _setupRealSTT() async {
    // Tilga mos model nomini topish
    String modelName = "";
    if (widget.myLang == "en") {
      // Avval kattasini tekshiramiz, keyin kichigini
      if (await voskManager.isModelDownloaded("vosk-model-en-us-0.22")) {
        modelName = "vosk-model-en-us-0.22";
      } else if (await voskManager.isModelDownloaded("vosk-model-small-en-us-0.15")) {
        modelName = "vosk-model-small-en-us-0.15";
      }
    } else if (widget.myLang == "ru") {
      if (await voskManager.isModelDownloaded("vosk-model-ru-0.42")) {
        modelName = "vosk-model-ru-0.42";
      } else if (await voskManager.isModelDownloaded("vosk-model-small-ru-0.22")) {
        modelName = "vosk-model-small-ru-0.22";
      }
    }

    if (modelName.isNotEmpty) {
      try {
        final path = await voskManager.getModelLocalPath(modelName);
        if (path != null) {
          await realStt.initModel(path);
          print("Haqiqiy STT ishga tushdi: $modelName");
        }
      } catch (e) {
        print("Vosk STT yuklashda xato: $e");
      }
    }
  }

  STTService get _currentStt {
    // Agar model yuklangan bo'lsa realStt ni qaytaramiz
    return realStt.isListening || realStt.textStream != null ? realStt : stt;
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

  void _toggleMic() async {
    setState(() => _isMicOn = !_isMicOn);

    if (_isMicOn) {
      final activeStt = realStt; 
      // Biz realStt ni ishlatishga harakat qilamiz, agar init bo'lgan bo'lsa
      try {
        await activeStt.startListening();
        setState(() => _myText = "Eshitilmoqda..."); 
        
        _sttSub = activeStt.textStream.listen((text) {
          if (text.trim().isEmpty) return;
          setState(() => _myText = text);

          _handler?.sendSpeechText(
            text,
            fromLang: widget.myLang,
            toLang: widget.remoteLang,
          );
        });
      } catch (e) {
        // Fallback to mock if real fails
        stt.startListening();
        setState(() => _myText = "Eshitilmoqda (Mock)...");
        _sttSub = stt.textStream.listen((text) {
           setState(() => _myText = text);
           _handler?.sendSpeechText(text, fromLang: widget.myLang, toLang: widget.remoteLang);
        });
      }
    } else {
      _sttSub?.cancel();
      _sttSub = null;
      realStt.stopListening();
      stt.stopListening();
      tts.stop();
      setState(() => _myText = "");
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

          // Men gapirgan matn (STT, pastda - yanada ko'rinadigan qildik)
          if (_isMicOn || _myText.isNotEmpty)
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.withOpacity(0.8), Colors.blueAccent.withOpacity(0.6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    if (_isMicOn && _myText == "Eshitilmoqda...")
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        ),
                      )
                    else
                      const Icon(Icons.mic, color: Colors.white70, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _myText.isEmpty && _isMicOn ? "Gapiring..." : _myText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
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
