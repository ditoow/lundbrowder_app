import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/burn_percentages.dart';
import '../../../providers/calculation_provider.dart';
import '../../../routes/app_routes.dart';

/// Burn area input screen with front/back sections
class BurnInputScreen extends StatefulWidget {
  const BurnInputScreen({super.key});

  @override
  State<BurnInputScreen> createState() => _BurnInputScreenState();
}

class _BurnInputScreenState extends State<BurnInputScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          // Separate front and back areas
          final frontAreas = provider.burnAreas
              .where((a) => BurnPercentages.frontBodyParts.contains(a.key))
              .toList();
          final backAreas = provider.burnAreas
              .where((a) => BurnPercentages.backBodyParts.contains(a.key))
              .toList();

          return Column(
            children: [
              // Step indicator
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: _StepIndicator(currentStep: 3, totalSteps: 5),
              ),

              // Tab bar for front/back section
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  padding: const EdgeInsets.all(4),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline, size: 20),
                          const SizedBox(width: 8),
                          const Text('DEPAN'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, size: 20),
                          const SizedBox(width: 8),
                          const Text('BELAKANG'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Body image and areas
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // FRONT tab
                    _BodySection(
                      isFront: true,
                      areas: frontAreas,
                      provider: provider,
                    ),
                    // BACK tab
                    _BodySection(
                      isFront: false,
                      areas: backAreas,
                      provider: provider,
                    ),
                  ],
                ),
              ),

              // Selected count & total TBSA preview
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${provider.selectedAreas.length} area dipilih',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              // Bottom button
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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
          );
        },
      ),
    );
  }
}

/// Body section widget for front or back
class _BodySection extends StatelessWidget {
  final bool isFront;
  final List areas;
  final CalculationProvider provider;

  const _BodySection({
    required this.isFront,
    required this.areas,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Body image
        Container(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: isFront
                  ? const Color(0xFFFFF8E1)
                  : const Color(0xFFD7CCC8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Image.asset(
                isFront ? 'assets/images/front.png' : 'assets/images/back.png',
                height: 160,
                errorBuilder: (context, error, stackTrace) => Icon(
                  isFront ? Icons.person_outline : Icons.person,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),

        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                isFront ? 'Area Tubuh Depan' : 'Area Tubuh Belakang',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _selectAll(context),
                child: Text(
                  'Pilih Semua',
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),

        // Areas list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: areas.length,
            itemBuilder: (context, index) {
              final area = areas[index];
              final areaIndex = provider.burnAreas.indexOf(area);

              return _BodyAreaCheckbox(
                title: area.displayName,
                percentage: provider.selectedAgeGroup != null
                    ? area.getPercentage(provider.selectedAgeGroup!)
                    : null,
                isSelected: area.isSelected,
                onTap: () => provider.toggleBurnArea(areaIndex),
              );
            },
          ),
        ),
      ],
    );
  }

  void _selectAll(BuildContext context) {
    for (final area in areas) {
      if (!area.isSelected) {
        final index = provider.burnAreas.indexOf(area);
        provider.toggleBurnArea(index);
      }
    }
  }
}

/// Body area checkbox widget
class _BodyAreaCheckbox extends StatelessWidget {
  final String title;
  final double? percentage;
  final bool isSelected;
  final VoidCallback onTap;

  const _BodyAreaCheckbox({
    required this.title,
    required this.percentage,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (percentage != null)
                    Text(
                      '${percentage!.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
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
