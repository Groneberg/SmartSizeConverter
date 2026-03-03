import 'dart:convert';

class UserProfile {
  DateTime? createdAt;
  DateTime? updatedAt;
  double? footLength;
  double? waistCircumference;
  double? hipCircumference;
  double? chestCircumference;
  String? notes;

  UserProfile({
    this.createdAt,
    this.updatedAt,
    this.footLength,
    this.waistCircumference,
    this.hipCircumference,
    this.chestCircumference,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'footLength': footLength,
      'waistCircumference': waistCircumference,
      'hipCircumference': hipCircumference,
      'chestCircumference': chestCircumference,
      'notes': notes,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      footLength: map['footLength'],
      waistCircumference: map['waistCircumference'],
      hipCircumference: map['hipCircumference'],
      chestCircumference: map['chestCircumference'],
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());
  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));
}