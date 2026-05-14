import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import '../services/ocr_service.dart';
import '../services/api_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class ReadingScreen extends StatefulWidget {
  final VoiceProfile? selectedProfile;
  const ReadingScreen({super.key, this.selectedProfile});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  CameraController? _controller;
  bool _isBusy = false;
  String? _detectedText;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isReading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    await _controller?.initialize();
    
    if (mounted) {
      setState(() {});
      _startStreaming();
    }
  }

  void _startStreaming() {
    _controller?.startImageStream((image) {
      if (_isBusy || _isReading) return;
      _processCameraImage(image);
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    _isBusy = true;
    final ocrService = Provider.of<OcrService>(context, listen: false);
    
    // Convert CameraImage to InputImage (simplified for brevity)
    // Note: In production, you'd need a more robust conversion utility
    // for rotation and format handling across iOS/Android.
    
    // final inputImage = _convertCameraImage(image);
    // final text = await ocrService.processImage(inputImage);
    
    // Placeholder for real OCR result
    // setState(() => _detectedText = text);
    
    _isBusy = false;
  }

  Future<void> _handleRead() async {
    if (_detectedText == null || _isReading) return;

    setState(() => _isReading = true);
    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      // 1. Translate
      final storySegments = await apiService.translate([_detectedText!]);
      
      // 2. Get Audio
      final audioBytes = await apiService.getAudio(storySegments, widget.selectedProfile);
      
      // 3. Play
      // We'd save bytes to a temp file and play via just_audio
      // await _audioPlayer.setFilePath(tempPath);
      // await _audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('낭독 오류: $e')));
    } finally {
      setState(() => _isReading = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full Screen Camera Preview
          Center(
            child: CameraPreview(_controller!),
          ),
          
          // Header
          Positioned(
            top: 60,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black38,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Bottom UI
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _detectedText ?? '책의 글자를 카메라로 비춰주세요',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textMain,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _detectedText != null && !_isReading ? _handleRead : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: _isReading 
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('✨ 이야기 읽어줘!'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
