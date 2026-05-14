class VoiceProfile {
  final String id;
  final String name;
  final String? customVoiceKey;
  final DateTime createdAt;

  VoiceProfile({
    required this.id,
    required this.name,
    this.customVoiceKey,
    required this.createdAt,
  });

  factory VoiceProfile.fromJson(Map<String, dynamic> json) {
    return VoiceProfile(
      id: json['id'],
      name: json['name'],
      customVoiceKey: json['customVoiceKey'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'customVoiceKey': customVoiceKey,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class StorySegment {
  final String en;
  final String ko;
  final bool emphasis;

  StorySegment({
    required this.en,
    required this.ko,
    this.emphasis = false,
  });

  factory StorySegment.fromJson(Map<String, dynamic> json) {
    return StorySegment(
      en: json['en'],
      ko: json['ko'],
      emphasis: json['emphasis'] ?? false,
    );
  }
}
