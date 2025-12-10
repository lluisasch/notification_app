class Preferences {
  final bool vibration;
  final bool sound;
  final bool banner;
  final bool criticalMode;

  const Preferences({
    required this.vibration,
    required this.sound,
    required this.banner,
    required this.criticalMode,
  });

  Preferences copyWith({
    bool? vibration,
    bool? sound,
    bool? banner,
    bool? criticalMode,
  }) {
    return Preferences(
      vibration: vibration ?? this.vibration,
      sound: sound ?? this.sound,
      banner: banner ?? this.banner,
      criticalMode: criticalMode ?? this.criticalMode,
    );
  }

  Map<String, dynamic> toJson() => {
        'vibration': vibration,
        'sound': sound,
        'banner': banner,
        'criticalMode': criticalMode,
      };

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        vibration: json['vibration'] ?? true,
        sound: json['sound'] ?? true,
        banner: json['banner'] ?? true,
        criticalMode: json['criticalMode'] ?? false,
      );

  static Preferences get defaultPreferences => const Preferences(
        vibration: true,
        sound: true,
        banner: true,
        criticalMode: false,
      );
}