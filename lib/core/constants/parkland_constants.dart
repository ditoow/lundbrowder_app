/// Parkland Formula for burn resuscitation fluid calculation
/// Formula: Total Fluid (mL) = 4 × Weight (kg) × %TBSA
library;

class ParklandFormula {
  /// Multiplier for Parkland formula (4 mL/kg/% TBSA)
  static const double multiplier = 4.0;

  /// Calculate total fluid requirement for 24 hours
  /// Returns total fluid in mL
  static double calculateTotal(double weightKg, double tbsaPercent) {
    if (weightKg <= 0 || tbsaPercent <= 0) return 0;
    return multiplier * weightKg * tbsaPercent;
  }

  /// Get fluid for first 8 hours (50% of total)
  static double getFirst8Hours(double totalFluid) {
    return totalFluid / 2;
  }

  /// Get fluid for next 16 hours (50% of total)
  static double getNext16Hours(double totalFluid) {
    return totalFluid / 2;
  }

  /// Calculate hourly rate for first 8 hours
  static double getFirst8HoursRate(double totalFluid) {
    return getFirst8Hours(totalFluid) / 8;
  }

  /// Calculate hourly rate for next 16 hours
  static double getNext16HoursRate(double totalFluid) {
    return getNext16Hours(totalFluid) / 16;
  }

  /// Format volume for display (e.g., "2,800 mL")
  static String formatVolume(double volumeMl) {
    if (volumeMl >= 1000) {
      return '${volumeMl.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} mL';
    }
    return '${volumeMl.toStringAsFixed(0)} mL';
  }
}
