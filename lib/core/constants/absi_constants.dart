/// ABSI (Abbreviated Burn Severity Index) Score calculation
/// Used to estimate mortality risk in burn patients
library;

/// Age range categories for ABSI scoring (4 categories)
enum AgeRange {
  age0to20, // ≤ 20 tahun
  age21to40, // 21-40 tahun
  age41to60, // 41-60 tahun
  age60plus, // > 60 tahun
}

extension AgeRangeExtension on AgeRange {
  String get displayName {
    switch (this) {
      case AgeRange.age0to20:
        return '≤ 20 tahun';
      case AgeRange.age21to40:
        return '21 - 40 tahun';
      case AgeRange.age41to60:
        return '41 - 60 tahun';
      case AgeRange.age60plus:
        return '> 60 tahun';
    }
  }

  int get score {
    switch (this) {
      case AgeRange.age0to20:
        return 1;
      case AgeRange.age21to40:
        return 2;
      case AgeRange.age41to60:
        return 3;
      case AgeRange.age60plus:
        return 4;
    }
  }
}

/// Risk level based on ABSI score
enum AbsiRiskLevel {
  veryLow, // Sangat Rendah
  low, // Rendah
  moderate, // Sedang
  high, // Tinggi
  veryHigh, // Sangat Tinggi
  severe, // Berat
}

extension AbsiRiskLevelExtension on AbsiRiskLevel {
  String get displayName {
    switch (this) {
      case AbsiRiskLevel.veryLow:
        return 'Sangat Rendah';
      case AbsiRiskLevel.low:
        return 'Rendah';
      case AbsiRiskLevel.moderate:
        return 'Sedang';
      case AbsiRiskLevel.high:
        return 'Tinggi';
      case AbsiRiskLevel.veryHigh:
        return 'Sangat Tinggi';
      case AbsiRiskLevel.severe:
        return 'Berat';
    }
  }

  String get mortalityRange {
    switch (this) {
      case AbsiRiskLevel.veryLow:
        return '< 1%';
      case AbsiRiskLevel.low:
        return '2 - 3%';
      case AbsiRiskLevel.moderate:
        return '10 - 20%';
      case AbsiRiskLevel.high:
        return '30 - 50%';
      case AbsiRiskLevel.veryHigh:
        return '50 - 70%';
      case AbsiRiskLevel.severe:
        return '> 90%';
    }
  }
}

class AbsiScore {
  /// Get sex score (Male = 1, Female = 0)
  static int getSexScore(bool isMale) {
    return isMale ? 1 : 0;
  }

  /// Get age score based on age range
  static int getAgeScore(AgeRange ageRange) {
    return ageRange.score;
  }

  /// Get TBSA score based on percentage
  /// Every 10% TBSA adds 1 point
  static int getTbsaScore(double tbsaPercent) {
    if (tbsaPercent <= 0) return 0;
    if (tbsaPercent <= 10) return 1;
    if (tbsaPercent <= 20) return 2;
    if (tbsaPercent <= 30) return 3;
    if (tbsaPercent <= 40) return 4;
    if (tbsaPercent <= 50) return 5;
    if (tbsaPercent <= 60) return 6;
    if (tbsaPercent <= 70) return 7;
    if (tbsaPercent <= 80) return 8;
    if (tbsaPercent <= 90) return 9;
    return 10;
  }

  /// Get full thickness burn score (Yes = 1, No = 0)
  static int getFullThicknessScore(bool hasFullThickness) {
    return hasFullThickness ? 1 : 0;
  }

  /// Get inhalation injury score (Yes = 1, No = 0)
  static int getInhalationScore(bool hasInhalationInjury) {
    return hasInhalationInjury ? 1 : 0;
  }

  /// Calculate total ABSI score
  static int calculateTotal({
    required bool isMale,
    required AgeRange ageRange,
    required double tbsaPercent,
    required bool hasFullThickness,
    required bool hasInhalationInjury,
  }) {
    return getSexScore(isMale) +
        getAgeScore(ageRange) +
        getTbsaScore(tbsaPercent) +
        getFullThicknessScore(hasFullThickness) +
        getInhalationScore(hasInhalationInjury);
  }

  /// Get risk level based on total score
  static AbsiRiskLevel getRiskLevel(int totalScore) {
    if (totalScore <= 2) return AbsiRiskLevel.veryLow;
    if (totalScore <= 4) return AbsiRiskLevel.low;
    if (totalScore <= 6) return AbsiRiskLevel.moderate;
    if (totalScore <= 8) return AbsiRiskLevel.high;
    if (totalScore <= 10) return AbsiRiskLevel.veryHigh;
    return AbsiRiskLevel.severe;
  }

  /// Get score breakdown details
  static Map<String, int> getScoreBreakdown({
    required bool isMale,
    required AgeRange ageRange,
    required double tbsaPercent,
    required bool hasFullThickness,
    required bool hasInhalationInjury,
  }) {
    return {
      'Jenis Kelamin': getSexScore(isMale),
      'Usia': getAgeScore(ageRange),
      'TBSA': getTbsaScore(tbsaPercent),
      'Luka Bakar Derajat Penuh': getFullThicknessScore(hasFullThickness),
      'Cedera Inhalasi': getInhalationScore(hasInhalationInjury),
    };
  }
}
