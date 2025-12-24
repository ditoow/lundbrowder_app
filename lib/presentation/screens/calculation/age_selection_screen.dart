import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/burn_percentages.dart';
import '../../../providers/calculation_provider.dart';
import '../../../routes/app_routes.dart';

/// Age selection screen with 2 main options: Dewasa and Anak
class AgeSelectionScreen extends StatelessWidget {
  const AgeSelectionScreen({super.key});

  void _showChildAgeModal(BuildContext context, CalculationProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ChildAgeModal(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pilih Usia Pasien',
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
      body: Column(
        children: [
          // Sticky step indicator
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: _StepIndicator(currentStep: 1, totalSteps: 3),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  // Age options - hanya 2: Dewasa dan Anak
                  Consumer<CalculationProvider>(
                    builder: (context, provider, _) {
                      final isAdultSelected =
                          provider.selectedAgeGroup == AgeGroup.adult;
                      final isChildSelected =
                          provider.selectedAgeGroup != null &&
                          provider.selectedAgeGroup != AgeGroup.adult;

                      return Column(
                        children: [
                          // Dewasa option
                          _MainAgeOptionCard(
                            title: 'Dewasa',
                            subtitle: '> 15 Tahun',
                            icon: Icons.person,
                            iconColor: AppColors.primary,
                            isSelected: isAdultSelected,
                            onTap: () =>
                                provider.selectAgeGroup(AgeGroup.adult),
                          ),
                          const SizedBox(height: 16),
                          // Anak option
                          _MainAgeOptionCard(
                            title: 'Anak',
                            subtitle: isChildSelected
                                ? _getChildAgeLabel(provider.selectedAgeGroup!)
                                : '≤ 15 Tahun',
                            icon: Icons.child_care,
                            iconColor: Colors.orange,
                            isSelected: isChildSelected,
                            showArrow: true,
                            onTap: () => _showChildAgeModal(context, provider),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Info box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pemilihan kategori usia akan menentukan persentase luas area tubuh berdasarkan standar Chart Lund & Browder.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom button
          Container(
            padding: const EdgeInsets.all(24),
            child: Consumer<CalculationProvider>(
              builder: (context, provider, _) {
                final isEnabled = provider.hasAgeSelected;
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isEnabled
                        ? () => Navigator.pushNamed(context, AppRoutes.info)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lanjut',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isEnabled
                                ? Colors.white
                                : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: isEnabled
                              ? Colors.white
                              : Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getChildAgeLabel(AgeGroup ageGroup) {
    switch (ageGroup) {
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
      default:
        return '≤ 15 Tahun';
    }
  }
}

/// Step indicator widget
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress bar
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

/// Main age option card (Dewasa / Anak)
class _MainAgeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final bool showArrow;
  final VoidCallback onTap;

  const _MainAgeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    this.showArrow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(15) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            // Radio or Arrow
            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: isSelected ? AppColors.primary : Colors.grey.shade400,
                size: 28,
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}

/// Modal for selecting child age
class _ChildAgeModal extends StatelessWidget {
  final CalculationProvider provider;

  const _ChildAgeModal({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              children: [
                const Text(
                  'Pilih Usia Anak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey.shade500,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Age options
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              children: [
                _ChildAgeOption(
                  title: '0 Tahun',
                  subtitle: 'Bayi baru lahir',
                  icon: Icons.child_friendly,
                  iconColor: Colors.pink,
                  isSelected: provider.selectedAgeGroup == AgeGroup.age0,
                  onTap: () {
                    provider.selectAgeGroup(AgeGroup.age0);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _ChildAgeOption(
                  title: '1 Tahun',
                  subtitle: 'Balita',
                  icon: Icons.child_care,
                  iconColor: Colors.orange,
                  isSelected: provider.selectedAgeGroup == AgeGroup.age1,
                  onTap: () {
                    provider.selectAgeGroup(AgeGroup.age1);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _ChildAgeOption(
                  title: '5 Tahun',
                  subtitle: 'Anak prasekolah',
                  icon: Icons.face,
                  iconColor: Colors.amber,
                  isSelected: provider.selectedAgeGroup == AgeGroup.age5,
                  onTap: () {
                    provider.selectAgeGroup(AgeGroup.age5);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _ChildAgeOption(
                  title: '10 Tahun',
                  subtitle: 'Anak sekolah',
                  icon: Icons.emoji_people,
                  iconColor: Colors.green,
                  isSelected: provider.selectedAgeGroup == AgeGroup.age10,
                  onTap: () {
                    provider.selectAgeGroup(AgeGroup.age10);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _ChildAgeOption(
                  title: '15 Tahun',
                  subtitle: 'Remaja',
                  icon: Icons.person_outline,
                  iconColor: Colors.teal,
                  isSelected: provider.selectedAgeGroup == AgeGroup.age15,
                  onTap: () {
                    provider.selectAgeGroup(AgeGroup.age15);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

/// Child age option item
class _ChildAgeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChildAgeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(15) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Checkmark
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
