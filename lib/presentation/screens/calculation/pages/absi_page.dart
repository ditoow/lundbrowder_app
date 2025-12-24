import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/absi_constants.dart';
import '../../../../providers/calculation_provider.dart';

/// ABSI Page - can be used directly in PageView
class AbsiPage extends StatelessWidget {
  final VoidCallback onNext;

  const AbsiPage({super.key, required this.onNext});

  void _calculate(BuildContext context, CalculationProvider provider) {
    if (provider.ageRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kategori usia terlebih dahulu')),
      );
      return;
    }
    provider.calculateAbsiScore();
    onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            // Step indicator
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: _StepIndicator(currentStep: 5, totalSteps: 5),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.assessment,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Abbreviated Burn Severity Index',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Estimasi risiko mortalitas pasien luka bakar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // TBSA display
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
                            'Total TBSA (otomatis)',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${provider.totalTBSA.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Age category
                    const Text(
                      'Kategori Usia Pasien',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _AgeCategoryOption(
                                label: '≤ 20 tahun',
                                isSelected:
                                    provider.ageRange == AgeRange.age0to20,
                                onTap: () =>
                                    provider.setAgeRange(AgeRange.age0to20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _AgeCategoryOption(
                                label: '21 - 40 tahun',
                                isSelected:
                                    provider.ageRange == AgeRange.age21to40,
                                onTap: () =>
                                    provider.setAgeRange(AgeRange.age21to40),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _AgeCategoryOption(
                                label: '41 - 60 tahun',
                                isSelected:
                                    provider.ageRange == AgeRange.age41to60,
                                onTap: () =>
                                    provider.setAgeRange(AgeRange.age41to60),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _AgeCategoryOption(
                                label: '> 60 tahun',
                                isSelected:
                                    provider.ageRange == AgeRange.age60plus,
                                onTap: () =>
                                    provider.setAgeRange(AgeRange.age60plus),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Sex
                    const Text(
                      'Jenis Kelamin',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _SexOption(
                            label: 'Laki-laki',
                            icon: Icons.male,
                            isSelected: provider.isMale,
                            onTap: () => provider.setSex(true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SexOption(
                            label: 'Perempuan',
                            icon: Icons.female,
                            isSelected: !provider.isMale,
                            onTap: () => provider.setSex(false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _ToggleOption(
                      title: 'Luka Bakar Derajat Penuh',
                      subtitle: 'Derajat 3 (seluruh lapisan kulit)',
                      value: provider.hasFullThickness,
                      onChanged: (value) => provider.setFullThickness(value),
                    ),
                    const SizedBox(height: 12),
                    _ToggleOption(
                      title: 'Cedera Inhalasi',
                      subtitle: 'Cedera saluran napas akibat asap/panas',
                      value: provider.hasInhalationInjury,
                      onChanged: (value) => provider.setInhalationInjury(value),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _calculate(context, provider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Hitung Skor ABSI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'LANGKAH $currentStep DARI $totalSteps',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _SexOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SexOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(15)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleOption({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? AppColors.primary.withAlpha(15) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppColors.primary : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary.withAlpha(128),
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _AgeCategoryOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AgeCategoryOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(15)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
