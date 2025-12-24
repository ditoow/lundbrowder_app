import '../../core/constants/burn_percentages.dart';

/// Represents a body area for burn calculation
class BurnArea {
  final String key;
  final String displayName;
  bool isSelected;

  BurnArea({
    required this.key,
    required this.displayName,
    this.isSelected = false,
  });

  /// Get percentage based on age group
  double getPercentage(AgeGroup ageGroup) {
    return BurnPercentages.getPercentage(key, ageGroup);
  }

  /// Create all burn areas based on Lund & Browder table
  static List<BurnArea> createAllAreas() {
    return BurnPercentages.bodyPartKeys.map((key) {
      return BurnArea(
        key: key,
        displayName: BurnPercentages.getDisplayName(key),
      );
    }).toList();
  }

  /// Copy with updated selection
  BurnArea copyWith({bool? isSelected}) {
    return BurnArea(
      key: key,
      displayName: displayName,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
