import 'package:flutter/material.dart';
import '../../data/services/vosk_model_manager.dart';
import '../core/constants/app_colors.dart';

class VoskModelScreen extends StatefulWidget {
  const VoskModelScreen({super.key});

  @override
  State<VoskModelScreen> createState() => _VoskModelScreenState();
}

class _VoskModelScreenState extends State<VoskModelScreen> {
  final VoskModelManager _manager = VoskModelManager();

  final List<Map<String, String>> _availableModels = [
    {
      "name": "vosk-model-small-en-us-0.15",
      "label": "English (Small) - 40MB",
      "url": "https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip",
      "lang": "en"
    },
    {
      "name": "vosk-model-en-us-0.22",
      "label": "English (Big) - 1.8GB",
      "url": "https://alphacephei.com/vosk/models/vosk-model-en-us-0.22.zip",
      "lang": "en"
    },
    {
      "name": "vosk-model-small-ru-0.22",
      "label": "Russian (Small) - 45MB",
      "url": "https://alphacephei.com/vosk/models/vosk-model-small-ru-0.22.zip",
      "lang": "ru"
    },
    {
      "name": "vosk-model-ru-0.42",
      "label": "Russian (Big) - 1.8GB",
      "url": "https://alphacephei.com/vosk/models/vosk-model-ru-0.42.zip",
      "lang": "ru"
    },
  ];

  Map<String, double> _downloadProgress = {};
  Map<String, String> _status = {};
  Map<String, bool> _isDownloaded = {};

  @override
  void initState() {
    super.initState();
    _checkDownloadedModels();
  }

  Future<void> _checkDownloadedModels() async {
    for (var model in _availableModels) {
      bool exists = await _manager.isModelDownloaded(model['name']!);
      setState(() {
        _isDownloaded[model['name']!] = exists;
      });
    }
  }

  Future<void> _startDownload(Map<String, String> model) async {
    final name = model['name']!;
    setState(() {
      _downloadProgress[name] = 0.0;
      _status[name] = "Boshlanmoqda...";
    });

    try {
      await _manager.downloadAndExtractModel(
        modelName: name,
        url: model['url']!,
        onProgress: (p) => setState(() => _downloadProgress[name] = p),
        onStatus: (s) => setState(() => _status[name] = s),
      );
      await _checkDownloadedModels();
    } catch (e) {
      setState(() {
        _status[name] = "Xato: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vosk Modellari"),
        backgroundColor: AppColors.surface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _availableModels.length,
        itemBuilder: (context, index) {
          final model = _availableModels[index];
          final name = model['name']!;
          final isDownloaded = _isDownloaded[name] ?? false;
          final progress = _downloadProgress[name] ?? 0.0;
          final status = _status[name] ?? (isDownloaded ? "Yuklangan" : "Yuklanmagan");

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          model['label']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      if (isDownloaded)
                        const Icon(Icons.check_circle, color: Colors.green)
                      else if (progress > 0 && progress < 1)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(status, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  if (progress > 0 && progress < 1) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[800]),
                  ],
                  const SizedBox(height: 12),
                  if (!isDownloaded && (progress == 0 || progress >= 1))
                    ElevatedButton(
                      onPressed: () => _startDownload(model),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text("Yuklab olish"),
                    )
                  else if (isDownloaded)
                    OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                      child: const Text("Yuklangan"),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
