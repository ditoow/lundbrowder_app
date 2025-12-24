import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/calculation_provider.dart';
import '../../../routes/app_routes.dart';

/// Burn area input screen - matching mockup design
class BurnInputScreen extends StatelessWidget {
  const BurnInputScreen({super.key});

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
          'Pilih Area Luka Bakar',
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
      body: Consumer<CalculationProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              children: [
                // Subtitle - tetap di atas
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Pilih bagian tubuh yang terkena luka bakar',
                    style: TextStyle(fontSize: 14, color: AppColors.primary),
                  ),
                ),

                // Body images row - tetap di atas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BodyImageCard(label: 'DEPAN', isFront: true),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _BodyImageCard(
                          label: 'BELAKANG',
                          isFront: false,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Section title - tetap
                const Text(
                  'Area Tubuh',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Checkbox list - HANYA INI YANG SCROLL
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: provider.burnAreas.length,
                    separatorBuilder: (_, i) => const SizedBox(height: 0),
                    itemBuilder: (context, index) {
                      final area = provider.burnAreas[index];
                      return _BodyAreaCheckbox(
                        title: area.displayName,
                        isSelected: area.isSelected,
                        onTap: () => provider.toggleBurnArea(index),
                      );
                    },
                  ),
                ),
                // Bottom button - tetap di bawah
                Container(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: provider.selectedAreas.isNotEmpty
                          ? () {
                              provider.calculate();
                              Navigator.pushNamed(context, AppRoutes.result);
                            }
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
                      child: Text(
                        'Hitung Luas Luka',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: provider.selectedAreas.isNotEmpty
                              ? Colors.white
                              : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Body image card widget
class _BodyImageCard extends StatelessWidget {
  final String label;
  final bool isFront;

  const _BodyImageCard({required this.label, required this.isFront});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: isFront
                ? const Color(0xFFFFF8E1) // Light cream/beige for front
                : const Color(0xFFD7CCC8), // Light brown for back
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Center(
            child: Image.asset(
              isFront ? 'assets/images/front.png' : 'assets/images/back.png',
              height: 180,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

/// Body area checkbox widget
class _BodyAreaCheckbox extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _BodyAreaCheckbox({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
