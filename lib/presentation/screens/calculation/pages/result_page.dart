import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../providers/calculation_provider.dart';

/// Result Page showing TBSA calculation - can be used in PageView
class ResultPage extends StatefulWidget {
  final VoidCallback onNext;

  const ResultPage({super.key, required this.onNext});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _showAllAreas = false;

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

  List<Widget> _buildAreasList(CalculationProvider provider) {
    final areas = _showAllAreas
        ? provider.selectedAreas
        : provider.selectedAreas.take(3).toList();

    return areas.map((area) {
      final percentage = area.getPercentage(provider.selectedAgeGroup!);
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Container(
              width: 6.r,
              height: 6.r,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                area.displayName,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationProvider>(
      builder: (context, provider, _) {
        final severityColor = _getSeverityColor(provider.severity);

        return Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
              child: _StepIndicator(currentStep: 4, totalSteps: 7),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
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
                          Text(
                            'TOTAL LUAS LUKA BAKAR',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(25),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  color: AppColors.primary,
                                  size: 28.r,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${provider.totalTBSA}%',
                                    style: TextStyle(
                                      fontSize: 48.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'TBSA',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Container(
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Kategori Keparahan',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: severityColor,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    provider.severity.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
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
                    SizedBox(height: 24.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rincian Area',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ..._buildAreasList(provider),
                          if (provider.selectedAreas.length > 3)
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: TextButton(
                                onPressed: () {
                                  setState(
                                    () => _showAllAreas = !_showAllAreas,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _showAllAreas
                                          ? 'Sembunyikan'
                                          : 'Tampilkan Semua (${provider.selectedAreas.length})',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      _showAllAreas
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: AppColors.primary,
                                      size: 20.r,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Panduan Kategori',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _SeverityGuideItem(
                            label: 'Ringan',
                            range: '< 10%',
                            color: AppColors.severityRingan,
                            isActive: provider.severity == 'Ringan',
                          ),
                          SizedBox(height: 12.h),
                          _SeverityGuideItem(
                            label: 'Sedang',
                            range: '10% - 20%',
                            color: AppColors.severitySedang,
                            isActive: provider.severity == 'Sedang',
                          ),
                          SizedBox(height: 12.h),
                          _SeverityGuideItem(
                            label: 'Berat',
                            range: '> 20%',
                            color: AppColors.severityBerat,
                            isActive: provider.severity == 'Berat',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: widget.onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
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
                              'Lanjut ke Kebutuhan Cairan',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.arrow_forward, size: 20.r),
                          ],
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isActive ? color.withAlpha(25) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: isActive ? Border.all(color: color, width: 1.5) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 12.r,
            height: 12.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            range,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          if (isActive) ...[
            SizedBox(width: 8.w),
            Icon(Icons.check_circle, color: color, size: 20.r),
          ],
        ],
      ),
    );
  }
}
