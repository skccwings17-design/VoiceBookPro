import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  final String baseUrl = 'https://voicebook-pro-server-916847589107.us-central1.run.app';
  String? _authToken;

  void updateToken(String? token) {
    _authToken = token;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  Future<List<StorySegment>> translate(List<String> texts) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/translate'),
      headers: _headers,
      body: jsonEncode({'texts': texts}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => StorySegment.fromJson(item)).toList();
    } else {
      throw Exception('Translation failed: ${response.body}');
    }
  }

  Future<Uint8List> getAudio(List<StorySegment> storyData, VoiceProfile? profile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tts'),
      headers: _headers,
      body: jsonEncode({
        'storyData': storyData.map((s) => {'en': s.en, 'ko': s.ko, 'emphasis': s.emphasis}).toList(),
        'voiceProfile': profile?.toJson(),
      }),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('TTS failed: ${response.body}');
    }
  }
}
