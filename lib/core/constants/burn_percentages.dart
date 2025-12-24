/// Burn percentage constants based on Lund & Browder chart
/// Different values based on age categories
library;

/// Age categories based on Lund & Browder chart
enum AgeGroup {
  age0, // 0 tahun
  age1, // 1 tahun
  age5, // 5 tahun
  age10, // 10 tahun
  age15, // 15 tahun
  adult, // Dewasa
}

extension AgeGroupExtension on AgeGroup {
  String get displayName {
    switch (this) {
      case AgeGroup.age0:
        return '0 Tahun';
      case AgeGroup.age1:
        return '1 Tahun';
      case AgeGroup.age5:
        return '5 Tahun';
      case AgeGroup.age10:
        return '10 Tahun';
      case AgeGroup.age15:
        return '15 Tahun';
      case AgeGroup.adult:
        return 'Dewasa (>15 Tahun)';
    }
  }
}

class BurnPercentages {
  /// Get percentage for a body part based on age group
  static double getPercentage(String bodyPart, AgeGroup ageGroup) {
    final percentages = _percentagesByAge[ageGroup]!;
    return percentages[bodyPart] ?? 0.0;
  }

  /// Percentages by age group (based on Lund & Browder table)
  /// Format: body_part -> percentage
  static const Map<AgeGroup, Map<String, double>> _percentagesByAge = {
    AgeGroup.age0: {
      'kepala': 9.5,
      'paha_kanan': 2.75,
      'paha_kiri': 2.75,
      'tungkai_kanan': 2.5,
      'tungkai_kiri': 2.5,
      'leher': 2.0,
      'lengan_atas_kanan': 4.0,
      'lengan_atas_kiri': 4.0,
      'lengan_bawah_kanan': 3.0,
      'lengan_bawah_kiri': 3.0,
      'telapak_tangan_kanan': 3.0,
      'telapak_tangan_kiri': 3.0,
      'telapak_kaki_kanan': 1.75,
      'telapak_kaki_kiri': 1.75,
      'genital_depan': 1.0,
      'genital_belakang': 5.0,
    },
    AgeGroup.age1: {
      'kepala': 8.5,
      'paha_kanan': 3.25,
      'paha_kiri': 3.25,
      'tungkai_kanan': 2.75,
      'tungkai_kiri': 2.75,
      'leher': 2.0,
      'lengan_atas_kanan': 4.0,
      'lengan_atas_kiri': 4.0,
      'lengan_bawah_kanan': 3.0,
      'lengan_bawah_kiri': 3.0,
      'telapak_tangan_kanan': 3.0,
      'telapak_tangan_kiri': 3.0,
      'telapak_kaki_kanan': 1.75,
      'telapak_kaki_kiri': 1.75,
      'genital_depan': 1.0,
      'genital_belakang': 5.0,
    },
    AgeGroup.age5: {
      'kepala': 6.5,
      'paha_kanan': 4.0,
      'paha_kiri': 4.0,
      'tungkai_kanan': 2.75,
      'tungkai_kiri': 2.75,
      'leher': 2.0,
      'lengan_atas_kanan': 4.0,
      'lengan_atas_kiri': 4.0,
      'lengan_bawah_kanan': 3.0,
      'lengan_bawah_kiri': 3.0,
      'telapak_tangan_kanan': 3.0,
      'telapak_tangan_kiri': 3.0,
      'telapak_kaki_kanan': 1.75,
      'telapak_kaki_kiri': 1.75,
      'genital_depan': 1.0,
      'genital_belakang': 5.0,
    },
    AgeGroup.age10: {
      'kepala': 5.5,
      'paha_kanan': 5.0,
      'paha_kiri': 5.0,
      'tungkai_kanan': 3.0,
      'tungkai_kiri': 3.0,
      'leher': 2.0,
      'lengan_atas_kanan': 4.0,
      'lengan_atas_kiri': 4.0,
      'lengan_bawah_kanan': 3.0,
      'lengan_bawah_kiri': 3.0,
      'telapak_tangan_kanan': 3.0,
      'telapak_tangan_kiri': 3.0,
      'telapak_kaki_kanan': 1.75,
      'telapak_kaki_kiri': 1.75,
      'genital_depan': 1.0,
      'genital_belakang': 5.0,
    },
    AgeGroup.age15: {
      'kepala': 4.5,
      'paha_kanan': 6.0,
      'paha_kiri': 6.0,
      'tungkai_kanan': 3.25,
      'tungkai_kiri': 3.25,
      'leher': 2.0,
      'lengan_atas_kanan': 4.0,
      'lengan_atas_kiri': 4.0,
      'lengan_bawah_kanan': 3.0,
      'lengan_bawah_kiri': 3.0,
      'telapak_tangan_kanan': 3.0,
      'telapak_tangan_kiri': 3.0,
      'telapak_kaki_kanan': 1.75,
      'telapak_kaki_kiri': 1.75,
      'genital_depan': 1.0,
      'genital_belakang': 5.0,
    },
    AgeGroup.adult: {
      'kepala': 3.5,
      'paha_kanan': 6.5,
      'paha_kiri': 6.5,
      'tungkai_kanan': 3.5,
      'tungkai_kiri': 3.5,
      'leher': 2.0,
      'lengan_atas_kanan': 4.0,
      'lengan_atas_kiri': 4.0,
      'lengan_bawah_kanan': 3.0,
      'lengan_bawah_kiri': 3.0,
      'telapak_tangan_kanan': 3.0,
      'telapak_tangan_kiri': 3.0,
      'telapak_kaki_kanan': 1.75,
      'telapak_kaki_kiri': 1.75,
      'genital_depan': 1.0,
      'genital_belakang': 5.0,
    },
  };

  /// List of all body part keys
  static const List<String> bodyPartKeys = [
    'kepala',
    'leher',
    'lengan_atas_kanan',
    'lengan_atas_kiri',
    'lengan_bawah_kanan',
    'lengan_bawah_kiri',
    'telapak_tangan_kanan',
    'telapak_tangan_kiri',
    'paha_kanan',
    'paha_kiri',
    'tungkai_kanan',
    'tungkai_kiri',
    'telapak_kaki_kanan',
    'telapak_kaki_kiri',
    'genital_depan',
    'genital_belakang',
  ];

  /// Get display name for body part key
  static String getDisplayName(String key) {
    const displayNames = {
      'kepala': 'Kepala (A)',
      'leher': 'Leher',
      'lengan_atas_kanan': 'Lengan Atas Kanan',
      'lengan_atas_kiri': 'Lengan Atas Kiri',
      'lengan_bawah_kanan': 'Lengan Bawah Kanan',
      'lengan_bawah_kiri': 'Lengan Bawah Kiri',
      'telapak_tangan_kanan': 'Telapak Tangan Kanan',
      'telapak_tangan_kiri': 'Telapak Tangan Kiri',
      'paha_kanan': 'Paha Kanan (B)',
      'paha_kiri': 'Paha Kiri (B)',
      'tungkai_kanan': 'Tungkai Bawah Kanan (C)',
      'tungkai_kiri': 'Tungkai Bawah Kiri (C)',
      'telapak_kaki_kanan': 'Telapak Kaki Kanan',
      'telapak_kaki_kiri': 'Telapak Kaki Kiri',
      'genital_depan': 'Genital Depan',
      'genital_belakang': 'Genital Belakang',
    };
    return displayNames[key] ?? key;
  }

  /// Calculate severity based on TBSA percentage
  static String getSeverity(double tbsa) {
    if (tbsa < 10) return 'Ringan';
    if (tbsa <= 20) return 'Sedang';
    return 'Berat';
  }
}
