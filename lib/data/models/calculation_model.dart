import '../../core/constants/burn_percentages.dart';

/// Model to store calculation history
class Calculation {
  final int? id;
  final int userId;
  final AgeGroup ageGroup;
  final List<String> selectedAreas;
  final double totalTBSA;
  final String severity;
  final DateTime createdAt;

  Calculation({
    this.id,
    required this.userId,
    required this.ageGroup,
    required this.selectedAreas,
    required this.totalTBSA,
    required this.severity,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create Calculation from database map
  factory Calculation.fromMap(Map<String, dynamic> map) {
    return Calculation(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      ageGroup: _parseAgeGroup(map['age_group'] as String),
      selectedAreas: (map['selected_areas'] as String).split(','),
      totalTBSA: map['total_tbsa'] as double,
      severity: map['severity'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Parse age group from string
  static AgeGroup _parseAgeGroup(String value) {
    switch (value) {
      case 'age0':
        return AgeGroup.age0;
      case 'age1':
        return AgeGroup.age1;
      case 'age5':
        return AgeGroup.age5;
      case 'age10':
        return AgeGroup.age10;
      case 'age15':
        return AgeGroup.age15;
      case 'adult':
      default:
        return AgeGroup.adult;
    }
  }

  /// Convert Calculation to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'age_group': ageGroup.name,
      'selected_areas': selectedAreas.join(','),
      'total_tbsa': totalTBSA,
      'severity': severity,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get age group display name
  String get ageGroupDisplayName => ageGroup.displayName;
}
