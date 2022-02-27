import 'dart:convert';

class WeightModel {
  final double value;
  final String id;
  final String createdAt;
  final String updatedAt;
  WeightModel({
    required this.value,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  WeightModel copyWith({
    double? value,
    String? id,
    String? createdAt,
    String? updatedAt,
  }) {
    return WeightModel(
      value: value ?? this.value,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeightModel &&
        other.value == value &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return value.hashCode ^
        id.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory WeightModel.fromMap(Map<String, dynamic> map) {
    return WeightModel(
      value: map['value']?.toDouble() ?? 0.0,
      id: map['id'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WeightModel.fromJson(String source) =>
      WeightModel.fromMap(json.decode(source));
}
