enum AlertEventType { panic, scheduled, system }

class AlertEvent {
  final int? id;
  final AlertEventType type;
  final DateTime createdAt;
  final DateTime? processedAt;

  AlertEvent({
    this.id,
    required this.type,
    required this.createdAt,
    this.processedAt,
  });

  AlertEvent copyWith({
    int? id,
    DateTime? processedAt,
  }) {
    return AlertEvent(
      id: id ?? this.id,
      type: type,
      createdAt: createdAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
    };
  }

  factory AlertEvent.fromMap(Map<String, dynamic> map) {
    return AlertEvent(
      id: map['id'] as int?,
      type: AlertEventType.values
          .firstWhere((e) => e.name == map['type'], orElse: () => AlertEventType.panic),
      createdAt: DateTime.parse(map['createdAt']),
      processedAt:
          map['processedAt'] != null ? DateTime.parse(map['processedAt']) : null,
    );
  }
}