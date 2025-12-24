import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/parkland_constants.dart';
import '../../../../providers/calculation_provider.dart';

/// Parkland Page - can be used directly in PageView
class ParklandPage extends StatefulWidget {
  final VoidCallback onNext;

  const ParklandPage({super.key, required this.onNext});

  @override
  State<ParklandPage> createState() => _ParklandPageState();
}

class _ParklandPageState extends State<ParklandPage> {
  final _weightController = TextEditingController();
  bool _hasCalculated = false;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _calculate(CalculationProvider provider) {
    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan berat badan yang valid')),
      );
      return;
    }
    provider.setWeight(weight);
    provider.calculateParkland();
    setState(() => _hasCalculated = true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
              child: _StepIndicator(currentStep: 5, totalSteps: 7),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.r),
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
                            'TOTAL CAIRAN 24 JAM',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            _hasCalculated
                                ? ParklandFormula.formatVolume(
                                    provider.totalFluid,
                                  )
                                : '0 mL',
                            style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                              color: _hasCalculated
                                  ? AppColors.primary
                                  : Colors.grey.shade400,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Divider(color: Colors.grey.shade200),
                          SizedBox(height: 16.h),
                          _FluidRow(
                            icon: Icons.access_time,
                            iconColor: _hasCalculated
                                ? Colors.orange
                                : Colors.grey,
                            title: '8 Jam Pertama',
                            subtitle: '50% dari total',
                            value: _hasCalculated
                                ? ParklandFormula.formatVolume(
                                    provider.first8Hours,
                                  )
                                : '0 mL',
                            rate: _hasCalculated
                                ? '${ParklandFormula.getFirst8HoursRate(provider.totalFluid).toStringAsFixed(0)} mL/jam'
                                : '0 mL/jam',
                          ),
                          SizedBox(height: 16.h),
                          _FluidRow(
                            icon: Icons.access_time_filled,
                            iconColor: _hasCalculated
                                ? Colors.teal
                                : Colors.grey,
                            title: '16 Jam Berikutnya',
                            subtitle: '50% dari total',
                            value: _hasCalculated
                                ? ParklandFormula.formatVolume(
                                    provider.next16Hours,
                                  )
                                : '0 mL',
                            rate: _hasCalculated
                                ? '${ParklandFormula.getNext16HoursRate(provider.totalFluid).toStringAsFixed(0)} mL/jam'
                                : '0 mL/jam',
                          ),
                        ],
                      ),
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
                            'Total TBSA',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${provider.totalTBSA.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Berat Badan',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,1}'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: 'Masukkan berat badan',
                        suffixText: 'kg',
                        suffixStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: () => _calculate(provider),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Hitung',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: SizedBox(
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: _hasCalculated ? widget.onNext : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _hasCalculated
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                foregroundColor: _hasCalculated
                                    ? Colors.white
                                    : Colors.grey.shade500,
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
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(Icons.arrow_forward, size: 18.r),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _FluidRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String value;
  final String rate;

  const _FluidRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: iconColor.withAlpha(15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(30),
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
              Text(
                rate,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
