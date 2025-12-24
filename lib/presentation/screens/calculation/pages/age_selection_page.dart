import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/burn_percentages.dart';
import '../../../../providers/calculation_provider.dart';

/// Age Selection Page - can be used directly in PageView
class AgeSelectionPage extends StatelessWidget {
  final VoidCallback onNext;

  const AgeSelectionPage({super.key, required this.onNext});

  void _showChildAgeModal(BuildContext context, CalculationProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ChildAgeModal(provider: provider),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationProvider>(
      builder: (context, provider, _) {
        final isAdultSelected = provider.selectedAgeGroup == AgeGroup.adult;
        final isChildSelected =
            provider.selectedAgeGroup != null &&
            provider.selectedAgeGroup != AgeGroup.adult;

        return Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
              child: _StepIndicator(currentStep: 1, totalSteps: 7),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                child: Column(
                  children: [
                    _MainAgeOptionCard(
                      title: 'Dewasa',
                      subtitle: '> 15 Tahun',
                      icon: Icons.person,
                      iconColor: AppColors.primary,
                      isSelected: isAdultSelected,
                      onTap: () => provider.selectAgeGroup(AgeGroup.adult),
                    ),
                    SizedBox(height: 16.h),
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
                    SizedBox(height: 24.h),
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(25),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: AppColors.primary,
                              size: 18.r,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Pemilihan kategori usia akan menentukan persentase luas area tubuh berdasarkan standar Chart Lund & Browder.',
                              style: TextStyle(
                                fontSize: 14.sp,
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
            Container(
              padding: EdgeInsets.all(24.r),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: provider.hasAgeSelected ? onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lanjut',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: provider.hasAgeSelected
                              ? Colors.white
                              : Colors.grey.shade500,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 20.r,
                        color: provider.hasAgeSelected
                            ? Colors.white
                            : Colors.grey.shade500,
                      ),
                    ],
                  ),
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
                height: 4.h,
                margin: EdgeInsets.only(
                  right: index < totalSteps - 1 ? 4.w : 0,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8.h),
        Text(
          'LANGKAH $currentStep DARI $totalSteps',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

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
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(15) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: iconColor, size: 28.r),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
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
            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: isSelected ? AppColors.primary : Colors.grey.shade400,
                size: 28.r,
              )
            else
              Container(
                width: 24.r,
                height: 24.r,
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
                          width: 12.r,
                          height: 12.r,
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

class _ChildAgeModal extends StatelessWidget {
  final CalculationProvider provider;

  const _ChildAgeModal({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 16.h),
            child: Row(
              children: [
                Text(
                  'Pilih Usia Anak',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey.shade500,
                      size: 24.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
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
                SizedBox(height: 12.h),
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
                SizedBox(height: 12.h),
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
                SizedBox(height: 12.h),
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
                SizedBox(height: 12.h),
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
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

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
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha(15) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 22.r),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24.r,
                height: 24.r,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 16.r, color: Colors.white),
              )
            else
              Container(
                width: 24.r,
                height: 24.r,
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
