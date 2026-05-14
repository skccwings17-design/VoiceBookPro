import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class VoiceProfileScreen extends StatefulWidget {
  const VoiceProfileScreen({super.key});

  @override
  State<VoiceProfileScreen> createState() => _VoiceProfileScreenState();
}

class _VoiceProfileScreenState extends State<VoiceProfileScreen> {
  List<VoiceProfile> _profiles = [
    // Default system profile
    VoiceProfile(id: 'default_mom', name: '엄마 목소리 (기본)', createdAt: DateTime.now()),
    VoiceProfile(id: 'default_dad', name: '아빠 목소리 (기본)', createdAt: DateTime.now()),
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // In real app, fetch from Firestore via ApiService
  }

  void _addNewProfile() {
    // Show a dialog or navigate to a recording flow
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NewProfileSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('목소리 고르기', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _profiles.length,
            itemBuilder: (context, index) {
              final profile = _profiles[index];
              return Padding(
                padding: const EdgeInsets.bottom(16.0),
                child: InkWell(
                  onTap: () => Navigator.pop(context, profile),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.mic, color: AppTheme.primary),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(
                                  profile.customVoiceKey == null ? '기본 AI 음성' : '클로닝된 음성',
                                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.check_circle_outline, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewProfile,
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('새 목소리 추가', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _NewProfileSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 30),
          const Text('내 목소리 만들기 🎙️', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text(
            '10초 동안 화면에 나오는 글을 읽어주세요.\n엄마 아빠와 똑같은 목소리를 만들어드릴게요!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMuted, height: 1.5),
          ),
          const Spacer(),
          // Recording UI placeholder
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, size: 60, color: AppTheme.secondary),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondary),
            child: const Text('녹음 시작하기'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
