import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/calculation_provider.dart';
import '../../../routes/app_routes.dart';

/// Result screen showing TBSA calculation - matching mockup
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Ringan':
        return AppColors.severityRingan;
      case 'Sedang':
        return AppColors.severitySedang;
      case 'Berat':
        return AppColors.severityBerat;
      default:
        return AppColors.textSecondary;
    }
  }

  /// Build calculation formula string like "6.5 + 2 + 4 + 4 = 16.5%"
  // String _buildCalculationFormula(CalculationProvider provider) {
  //   final percentages = provider.selectedAreas.map((area) {
  //     return area.getPercentage(provider.selectedAgeGroup!);
  //   }).toList();

  //   final formula = percentages.map((p) => p.toStringAsFixed(1)).join(' + ');
  //   return '$formula = ${provider.totalTBSA.toStringAsFixed(1)}%';
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationProvider>(
      builder: (context, provider, _) {
        final severityColor = _getSeverityColor(provider.severity);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Hasil Perhitungan',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: Colors.grey.shade200, height: 1),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Main result card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        'TOTAL LUAS LUKA BAKAR',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Percentage with icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${provider.totalTBSA}%',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'TBSA',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Severity section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kategori Keparahan',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: severityColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                provider.severity.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Detailed breakdown card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rincian Area',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // List of selected areas
                      ...provider.selectedAreas.map((area) {
                        final percentage = area.getPercentage(
                          provider.selectedAgeGroup!,
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  area.displayName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Panduan Kategori',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SeverityGuideItem(
                        label: 'Ringan',
                        range: '< 10%',
                        color: AppColors.severityRingan,
                        isActive: provider.severity == 'Ringan',
                      ),
                      const SizedBox(height: 12),
                      _SeverityGuideItem(
                        label: 'Sedang',
                        range: '10% - 20%',
                        color: AppColors.severitySedang,
                        isActive: provider.severity == 'Sedang',
                      ),
                      const SizedBox(height: 12),
                      _SeverityGuideItem(
                        label: 'Berat',
                        range: '> 20%',
                        color: AppColors.severityBerat,
                        isActive: provider.severity == 'Berat',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Recalculate button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      provider.reset();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.ageSelection,
                        ModalRoute.withName(AppRoutes.home),
                      );
                    },
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text(
                      'Hitung Ulang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Back to home link
                TextButton(
                  onPressed: () {
                    provider.reset();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Kembali ke Home',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Severity guide item widget
class _SeverityGuideItem extends StatelessWidget {
  final String label;
  final String range;
  final Color color;
  final bool isActive;

  const _SeverityGuideItem({
    required this.label,
    required this.range,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? color.withAlpha(25) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive ? Border.all(color: color, width: 1.5) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            range,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          if (isActive) ...[
            const SizedBox(width: 8),
            Icon(Icons.check_circle, color: color, size: 20),
          ],
        ],
      ),
    );
  }
}
