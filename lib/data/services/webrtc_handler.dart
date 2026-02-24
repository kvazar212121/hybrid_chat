import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef OnTranslationCallback = void Function(
    String original, String translated);

class WebRTCHandler {
  final String serverUrl;
  late WebSocketChannel _channel;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  Function(MediaStream)? onRemoteStream;

  /// Server tarjimasini qabul qilib callback chiqaradi
  OnTranslationCallback? onTranslationReceived;

  WebRTCHandler({required this.serverUrl});

  Future<void> init(RTCVideoRenderer localRenderer) async {
    _channel = WebSocketChannel.connect(Uri.parse(serverUrl));
    _channel.stream.listen(
      _onSignalingMessage,
      onError: (e) => print("WS xatosi: $e"),
      onDone: () => print("WS ulanish yopildi"),
    );

    final Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (candidate) {
      _sendSignalingMessage({
        "type": "candidate",
        "candidate": candidate.toMap(),
      });
    };

    _peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        onRemoteStream?.call(event.streams[0]);
      }
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia({
        "audio": true,
        "video": {
          "facingMode": "user",
          "width": {"min": "640", "ideal": "1280", "max": "1920"},
          "height": {"min": "480", "ideal": "720", "max": "1080"},
        },
      });
      print("Kamera oqimi olindi: ${_localStream!.id}");

      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });

      localRenderer.srcObject = _localStream;
    } catch (e) {
      print("Kamera yoki mikrofonni yoqishda xato: $e");
    }
  }

  void _onSignalingMessage(message) async {
    final data = jsonDecode(message);
    final type = data["type"] as String? ?? "";

    switch (type) {
      case "offer":
        await _peerConnection!.setRemoteDescription(
          RTCSessionDescription(data["sdp"], "offer"),
        );
        final answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);
        _sendSignalingMessage({"type": "answer", "sdp": answer.sdp});
        break;

      case "answer":
        await _peerConnection!.setRemoteDescription(
          RTCSessionDescription(data["sdp"], "answer"),
        );
        break;

      case "candidate":
        await _peerConnection!.addCandidate(
          RTCIceCandidate(
            data["candidate"]["candidate"],
            data["candidate"]["sdpMid"],
            data["candidate"]["sdpMLineIndex"],
          ),
        );
        break;

      case "translation":
        // -----------------------------------------------
        // Server tarjimasi keldi → callback orqali UI ga yubor
        // -----------------------------------------------
        final original = data["original"] as String? ?? "";
        final translated = data["translated"] as String? ?? "";
        onTranslationReceived?.call(original, translated);
        break;

      case "peer_disconnected":
        print("Ulanish uzildi.");
        break;
    }
  }

  void _sendSignalingMessage(Map<String, dynamic> message) {
    _channel.sink.add(jsonEncode(message));
  }

  /// STT orqali qo'lga kiritilgan matnni serverga yuboradi.
  /// Server tarjima qilib narigi qurilmaga jo'natadi.
  void sendSpeechText(String text,
      {String fromLang = "en", String toLang = "ru"}) {
    _sendSignalingMessage({
      "type": "speech",
      "text": text,
      "from_lang": fromLang,
      "to_lang": toLang,
    });
  }

  Future<void> createOffer() async {
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    _sendSignalingMessage({"type": "offer", "sdp": offer.sdp});
  }

  void dispose() {
    _localStream?.dispose();
    _peerConnection?.dispose();
    _channel.sink.close();
  }
}
