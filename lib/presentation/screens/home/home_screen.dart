import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/calculation_provider.dart';
import '../../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';

/// Home screen based on mockup design
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Logout button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () async {
                    await context.read<AuthProvider>().logout();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.logout,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.logout,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Header image with gradient
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Decorative circles
                          Positioned(
                            bottom: 40,
                            child: Container(
                              width: 150,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(
                                  (0.1 * 255).round(),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 55,
                            child: Container(
                              width: 120,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(
                                  (0.08 * 255).round(),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          // Sphere
                          Positioned(
                            top: 40,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  center: const Alignment(-0.3, -0.3),
                                  colors: [
                                    Colors.white.withAlpha((0.8 * 255).round()),
                                    Colors.cyan.withAlpha((0.4 * 255).round()),
                                    Colors.teal.withAlpha((0.2 * 255).round()),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(
                                      (0.3 * 255).round(),
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Title
                    const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '(${AppStrings.appSubtitle})',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppStrings.appDescription,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Spacer(),

                    // Start button
                    CustomButton(
                      text: AppStrings.startCalculation,
                      icon: Icons.grid_view_rounded,
                      onPressed: () {
                        // Reset calculation state before starting
                        context.read<CalculationProvider>().reset();
                        Navigator.pushNamed(context, AppRoutes.calculationFlow);
                      },
                    ),

                    const SizedBox(height: 24),

                    // Disclaimer
                    Text(
                      AppStrings.clinicalNote,
                      style: TextStyle(fontSize: 12, color: AppColors.textHint),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
