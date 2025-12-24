/// Burn percentage constants based on Lund & Browder chart
/// Different values based on age categories
/// Separated into front (depan) and back (belakang) sections
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

/// Section type for body areas
enum BodySection { depan, belakang }

class BurnPercentages {
  /// Get percentage for a body part based on age group
  static double getPercentage(String bodyPart, AgeGroup ageGroup) {
    final percentages = _percentagesByAge[ageGroup]!;
    return percentages[bodyPart] ?? 0.0;
  }

  /// Percentages by age group (based on Lund & Browder table)
  /// A (Kepala), B (Paha), C (Tungkai) - berubah sesuai usia
  /// Nilai adalah PER SISI (depan saja atau belakang saja)
  static const Map<AgeGroup, Map<String, double>> _percentagesByAge = {
    // ============ 0 TAHUN ============
    // A=9.5%, B=2.75%, C=2.5% (per sisi)
    AgeGroup.age0: {
      // DEPAN
      'kepala_depan': 9.5,
      'leher_depan': 1.0,
      'badan_depan': 13.0,
      'lengan_atas_kanan_depan': 2.0,
      'lengan_atas_kiri_depan': 2.0,
      'lengan_bawah_kanan_depan': 1.5,
      'lengan_bawah_kiri_depan': 1.5,
      'telapak_tangan_kanan_depan': 1.25,
      'telapak_tangan_kiri_depan': 1.25,
      'paha_kanan_depan': 2.75,
      'paha_kiri_depan': 2.75,
      'tungkai_kanan_depan': 2.5,
      'tungkai_kiri_depan': 2.5,
      'telapak_kaki_kanan_depan': 1.75,
      'telapak_kaki_kiri_depan': 1.75,
      'genital': 1.0,
      // BELAKANG
      'kepala_belakang': 9.5,
      'leher_belakang': 1.0,
      'badan_belakang': 13.0,
      'pantat_kanan': 2.5,
      'pantat_kiri': 2.5,
      'lengan_atas_kanan_belakang': 2.0,
      'lengan_atas_kiri_belakang': 2.0,
      'lengan_bawah_kanan_belakang': 1.5,
      'lengan_bawah_kiri_belakang': 1.5,
      'telapak_tangan_kanan_belakang': 1.25,
      'telapak_tangan_kiri_belakang': 1.25,
      'paha_kanan_belakang': 2.75,
      'paha_kiri_belakang': 2.75,
      'tungkai_kanan_belakang': 2.5,
      'tungkai_kiri_belakang': 2.5,
      'telapak_kaki_kanan_belakang': 1.75,
      'telapak_kaki_kiri_belakang': 1.75,
    },
    // ============ 1 TAHUN ============
    // A=8.5%, B=3.25%, C=2.75% (per sisi)
    AgeGroup.age1: {
      // DEPAN
      'kepala_depan': 8.5,
      'leher_depan': 1.0,
      'badan_depan': 13.0,
      'lengan_atas_kanan_depan': 2.0,
      'lengan_atas_kiri_depan': 2.0,
      'lengan_bawah_kanan_depan': 1.5,
      'lengan_bawah_kiri_depan': 1.5,
      'telapak_tangan_kanan_depan': 1.25,
      'telapak_tangan_kiri_depan': 1.25,
      'paha_kanan_depan': 3.25,
      'paha_kiri_depan': 3.25,
      'tungkai_kanan_depan': 2.75,
      'tungkai_kiri_depan': 2.75,
      'telapak_kaki_kanan_depan': 1.75,
      'telapak_kaki_kiri_depan': 1.75,
      'genital': 1.0,
      // BELAKANG
      'kepala_belakang': 8.5,
      'leher_belakang': 1.0,
      'badan_belakang': 13.0,
      'pantat_kanan': 2.5,
      'pantat_kiri': 2.5,
      'lengan_atas_kanan_belakang': 2.0,
      'lengan_atas_kiri_belakang': 2.0,
      'lengan_bawah_kanan_belakang': 1.5,
      'lengan_bawah_kiri_belakang': 1.5,
      'telapak_tangan_kanan_belakang': 1.25,
      'telapak_tangan_kiri_belakang': 1.25,
      'paha_kanan_belakang': 3.25,
      'paha_kiri_belakang': 3.25,
      'tungkai_kanan_belakang': 2.75,
      'tungkai_kiri_belakang': 2.75,
      'telapak_kaki_kanan_belakang': 1.75,
      'telapak_kaki_kiri_belakang': 1.75,
    },
    // ============ 5 TAHUN ============
    // A=6.5%, B=4%, C=2.75% (per sisi)
    AgeGroup.age5: {
      // DEPAN
      'kepala_depan': 6.5,
      'leher_depan': 1.0,
      'badan_depan': 13.0,
      'lengan_atas_kanan_depan': 2.0,
      'lengan_atas_kiri_depan': 2.0,
      'lengan_bawah_kanan_depan': 1.5,
      'lengan_bawah_kiri_depan': 1.5,
      'telapak_tangan_kanan_depan': 1.25,
      'telapak_tangan_kiri_depan': 1.25,
      'paha_kanan_depan': 4.0,
      'paha_kiri_depan': 4.0,
      'tungkai_kanan_depan': 2.75,
      'tungkai_kiri_depan': 2.75,
      'telapak_kaki_kanan_depan': 1.75,
      'telapak_kaki_kiri_depan': 1.75,
      'genital': 1.0,
      // BELAKANG
      'kepala_belakang': 6.5,
      'leher_belakang': 1.0,
      'badan_belakang': 13.0,
      'pantat_kanan': 2.5,
      'pantat_kiri': 2.5,
      'lengan_atas_kanan_belakang': 2.0,
      'lengan_atas_kiri_belakang': 2.0,
      'lengan_bawah_kanan_belakang': 1.5,
      'lengan_bawah_kiri_belakang': 1.5,
      'telapak_tangan_kanan_belakang': 1.25,
      'telapak_tangan_kiri_belakang': 1.25,
      'paha_kanan_belakang': 4.0,
      'paha_kiri_belakang': 4.0,
      'tungkai_kanan_belakang': 2.75,
      'tungkai_kiri_belakang': 2.75,
      'telapak_kaki_kanan_belakang': 1.75,
      'telapak_kaki_kiri_belakang': 1.75,
    },
    // ============ 10 TAHUN ============
    // A=5.5%, B=5%, C=3% (per sisi)
    AgeGroup.age10: {
      // DEPAN
      'kepala_depan': 5.5,
      'leher_depan': 1.0,
      'badan_depan': 13.0,
      'lengan_atas_kanan_depan': 2.0,
      'lengan_atas_kiri_depan': 2.0,
      'lengan_bawah_kanan_depan': 1.5,
      'lengan_bawah_kiri_depan': 1.5,
      'telapak_tangan_kanan_depan': 1.25,
      'telapak_tangan_kiri_depan': 1.25,
      'paha_kanan_depan': 5.0,
      'paha_kiri_depan': 5.0,
      'tungkai_kanan_depan': 3.0,
      'tungkai_kiri_depan': 3.0,
      'telapak_kaki_kanan_depan': 1.75,
      'telapak_kaki_kiri_depan': 1.75,
      'genital': 1.0,
      // BELAKANG
      'kepala_belakang': 5.5,
      'leher_belakang': 1.0,
      'badan_belakang': 13.0,
      'pantat_kanan': 2.5,
      'pantat_kiri': 2.5,
      'lengan_atas_kanan_belakang': 2.0,
      'lengan_atas_kiri_belakang': 2.0,
      'lengan_bawah_kanan_belakang': 1.5,
      'lengan_bawah_kiri_belakang': 1.5,
      'telapak_tangan_kanan_belakang': 1.25,
      'telapak_tangan_kiri_belakang': 1.25,
      'paha_kanan_belakang': 5.0,
      'paha_kiri_belakang': 5.0,
      'tungkai_kanan_belakang': 3.0,
      'tungkai_kiri_belakang': 3.0,
      'telapak_kaki_kanan_belakang': 1.75,
      'telapak_kaki_kiri_belakang': 1.75,
    },
    // ============ 15 TAHUN ============
    // A=4.5%, B=6%, C=3.25% (per sisi)
    AgeGroup.age15: {
      // DEPAN
      'kepala_depan': 4.5,
      'leher_depan': 1.0,
      'badan_depan': 13.0,
      'lengan_atas_kanan_depan': 2.0,
      'lengan_atas_kiri_depan': 2.0,
      'lengan_bawah_kanan_depan': 1.5,
      'lengan_bawah_kiri_depan': 1.5,
      'telapak_tangan_kanan_depan': 1.25,
      'telapak_tangan_kiri_depan': 1.25,
      'paha_kanan_depan': 6.0,
      'paha_kiri_depan': 6.0,
      'tungkai_kanan_depan': 3.25,
      'tungkai_kiri_depan': 3.25,
      'telapak_kaki_kanan_depan': 1.75,
      'telapak_kaki_kiri_depan': 1.75,
      'genital': 1.0,
      // BELAKANG
      'kepala_belakang': 4.5,
      'leher_belakang': 1.0,
      'badan_belakang': 13.0,
      'pantat_kanan': 2.5,
      'pantat_kiri': 2.5,
      'lengan_atas_kanan_belakang': 2.0,
      'lengan_atas_kiri_belakang': 2.0,
      'lengan_bawah_kanan_belakang': 1.5,
      'lengan_bawah_kiri_belakang': 1.5,
      'telapak_tangan_kanan_belakang': 1.25,
      'telapak_tangan_kiri_belakang': 1.25,
      'paha_kanan_belakang': 6.0,
      'paha_kiri_belakang': 6.0,
      'tungkai_kanan_belakang': 3.25,
      'tungkai_kiri_belakang': 3.25,
      'telapak_kaki_kanan_belakang': 1.75,
      'telapak_kaki_kiri_belakang': 1.75,
    },
    // ============ DEWASA ============
    // A=3.5%, B=6.5%, C=3.5% (per sisi)
    AgeGroup.adult: {
      // DEPAN
      'kepala_depan': 3.5,
      'leher_depan': 1.0,
      'badan_depan': 13.0,
      'lengan_atas_kanan_depan': 2.0,
      'lengan_atas_kiri_depan': 2.0,
      'lengan_bawah_kanan_depan': 1.5,
      'lengan_bawah_kiri_depan': 1.5,
      'telapak_tangan_kanan_depan': 1.25,
      'telapak_tangan_kiri_depan': 1.25,
      'paha_kanan_depan': 6.5,
      'paha_kiri_depan': 6.5,
      'tungkai_kanan_depan': 3.5,
      'tungkai_kiri_depan': 3.5,
      'telapak_kaki_kanan_depan': 1.75,
      'telapak_kaki_kiri_depan': 1.75,
      'genital': 1.0,
      // BELAKANG
      'kepala_belakang': 3.5,
      'leher_belakang': 1.0,
      'badan_belakang': 13.0,
      'pantat_kanan': 2.5,
      'pantat_kiri': 2.5,
      'lengan_atas_kanan_belakang': 2.0,
      'lengan_atas_kiri_belakang': 2.0,
      'lengan_bawah_kanan_belakang': 1.5,
      'lengan_bawah_kiri_belakang': 1.5,
      'telapak_tangan_kanan_belakang': 1.25,
      'telapak_tangan_kiri_belakang': 1.25,
      'paha_kanan_belakang': 6.5,
      'paha_kiri_belakang': 6.5,
      'tungkai_kanan_belakang': 3.5,
      'tungkai_kiri_belakang': 3.5,
      'telapak_kaki_kanan_belakang': 1.75,
      'telapak_kaki_kiri_belakang': 1.75,
    },
  };

  /// Body parts for FRONT section
  static const List<String> frontBodyParts = [
    'kepala_depan',
    'leher_depan',
    'badan_depan',
    'lengan_atas_kanan_depan',
    'lengan_atas_kiri_depan',
    'lengan_bawah_kanan_depan',
    'lengan_bawah_kiri_depan',
    'telapak_tangan_kanan_depan',
    'telapak_tangan_kiri_depan',
    'paha_kanan_depan',
    'paha_kiri_depan',
    'tungkai_kanan_depan',
    'tungkai_kiri_depan',
    'telapak_kaki_kanan_depan',
    'telapak_kaki_kiri_depan',
    'genital',
  ];

  /// Body parts for BACK section
  static const List<String> backBodyParts = [
    'kepala_belakang',
    'leher_belakang',
    'badan_belakang',
    'pantat_kanan',
    'pantat_kiri',
    'lengan_atas_kanan_belakang',
    'lengan_atas_kiri_belakang',
    'lengan_bawah_kanan_belakang',
    'lengan_bawah_kiri_belakang',
    'telapak_tangan_kanan_belakang',
    'telapak_tangan_kiri_belakang',
    'paha_kanan_belakang',
    'paha_kiri_belakang',
    'tungkai_kanan_belakang',
    'tungkai_kiri_belakang',
    'telapak_kaki_kanan_belakang',
    'telapak_kaki_kiri_belakang',
  ];

  /// All body part keys
  static List<String> get bodyPartKeys => [...frontBodyParts, ...backBodyParts];

  /// Get display name for body part key
  static String getDisplayName(String key) {
    const displayNames = {
      // DEPAN
      'kepala_depan': 'Kepala (A)',
      'leher_depan': 'Leher',
      'badan_depan': 'Badan',
      'lengan_atas_kanan_depan': 'Lengan Atas Kanan',
      'lengan_atas_kiri_depan': 'Lengan Atas Kiri',
      'lengan_bawah_kanan_depan': 'Lengan Bawah Kanan',
      'lengan_bawah_kiri_depan': 'Lengan Bawah Kiri',
      'telapak_tangan_kanan_depan': 'Telapak Tangan Kanan',
      'telapak_tangan_kiri_depan': 'Telapak Tangan Kiri',
      'paha_kanan_depan': 'Paha Kanan (B)',
      'paha_kiri_depan': 'Paha Kiri (B)',
      'tungkai_kanan_depan': 'Tungkai Kanan (C)',
      'tungkai_kiri_depan': 'Tungkai Kiri (C)',
      'telapak_kaki_kanan_depan': 'Telapak Kaki Kanan',
      'telapak_kaki_kiri_depan': 'Telapak Kaki Kiri',
      'genital': 'Genital',
      // BELAKANG
      'kepala_belakang': 'Kepala (A)',
      'leher_belakang': 'Leher',
      'badan_belakang': 'Badan',
      'pantat_kanan': 'Pantat Kanan',
      'pantat_kiri': 'Pantat Kiri',
      'lengan_atas_kanan_belakang': 'Lengan Atas Kanan',
      'lengan_atas_kiri_belakang': 'Lengan Atas Kiri',
      'lengan_bawah_kanan_belakang': 'Lengan Bawah Kanan',
      'lengan_bawah_kiri_belakang': 'Lengan Bawah Kiri',
      'telapak_tangan_kanan_belakang': 'Telapak Tangan Kanan',
      'telapak_tangan_kiri_belakang': 'Telapak Tangan Kiri',
      'paha_kanan_belakang': 'Paha Kanan (B)',
      'paha_kiri_belakang': 'Paha Kiri (B)',
      'tungkai_kanan_belakang': 'Tungkai Kanan (C)',
      'tungkai_kiri_belakang': 'Tungkai Kiri (C)',
      'telapak_kaki_kanan_belakang': 'Telapak Kaki Kanan',
      'telapak_kaki_kiri_belakang': 'Telapak Kaki Kiri',
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
