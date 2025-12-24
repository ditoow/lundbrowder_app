import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/parkland_constants.dart';
import '../../../providers/calculation_provider.dart';
import '../../../routes/app_routes.dart';

/// Parkland Formula calculation screen
class ParklandScreen extends StatefulWidget {
  const ParklandScreen({super.key});

  @override
  State<ParklandScreen> createState() => _ParklandScreenState();
}

class _ParklandScreenState extends State<ParklandScreen> {
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
    setState(() {
      _hasCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationProvider>(
      builder: (context, provider, _) {
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
              'Kebutuhan Cairan',
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
              // Step indicator
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: _StepIndicator(currentStep: 4, totalSteps: 5),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Results card (always visible)
                      Container(
                        padding: const EdgeInsets.all(20),
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
                            // Total fluid
                            const Text(
                              'TOTAL CAIRAN 24 JAM',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _hasCalculated
                                  ? ParklandFormula.formatVolume(
                                      provider.totalFluid,
                                    )
                                  : '0 mL',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: _hasCalculated
                                    ? AppColors.primary
                                    : Colors.grey.shade400,
                              ),
                            ),

                            const SizedBox(height: 24),
                            Divider(color: Colors.grey.shade200),
                            const SizedBox(height: 16),

                            // 8 hours
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

                            const SizedBox(height: 16),

                            // 16 hours
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

                      const SizedBox(height: 24),

                      // // Info card
                      // Container(
                      //   padding: const EdgeInsets.all(16),
                      //   decoration: BoxDecoration(
                      //     color: AppColors.primary.withAlpha(15),
                      //     borderRadius: BorderRadius.circular(12),
                      //     border: Border.all(
                      //       color: AppColors.primary.withAlpha(50),
                      //     ),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         Icons.water_drop,
                      //         color: AppColors.primary,
                      //         size: 24,
                      //       ),
                      //       const SizedBox(width: 12),
                      //       Expanded(
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             const Text(
                      //               'Parkland Formula',
                      //               style: TextStyle(
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w600,
                      //                 color: AppColors.textPrimary,
                      //               ),
                      //             ),
                      //             const SizedBox(height: 4),
                      //             Text(
                      //               '4 × BB (kg) × %TBSA = Total Cairan 24 jam',
                      //               style: TextStyle(
                      //                 fontSize: 12,
                      //                 color: AppColors.textSecondary,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // const SizedBox(height: 24),

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
                              'Total TBSA',
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

                      const SizedBox(height: 20),

                      // Weight input label
                      const Text(
                        'Berat Badan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Weight input field
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
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Buttons Row
                      Row(
                        children: [
                          // Calculate button
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () => _calculate(provider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Hitung',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Continue button
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _hasCalculated
                                    ? () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.absi,
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _hasCalculated
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  foregroundColor: _hasCalculated
                                      ? Colors.white
                                      : Colors.grey.shade500,
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
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_forward, size: 18),
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
          ),
        );
      },
    );
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

/// Fluid row widget
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
              Text(
                rate,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
