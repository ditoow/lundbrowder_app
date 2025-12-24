import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../lib/core/constants/app_colors.dart';
import '../lib/providers/calculation_provider.dart';
import '../lib/presentation/screens/calculation/pages/age_selection_page.dart';
import '../lib/presentation/screens/calculation/pages/info_page.dart';
import '../lib/presentation/screens/calculation/pages/burn_input_page.dart';
import '../lib/presentation/screens/calculation/pages/parkland_page.dart';
import '../lib/presentation/screens/calculation/pages/absi_page.dart';
import '../lib/presentation/screens/calculation/pages/absi_result_page.dart';

/// Unified calculation flow with PageView - calls separate page widgets
class CalculationFlowScreen extends StatefulWidget {
  const CalculationFlowScreen({super.key});

  @override
  State<CalculationFlowScreen> createState() => _CalculationFlowScreenState();
}

class _CalculationFlowScreenState extends State<CalculationFlowScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TabController _burnTabController;
  int _currentPage = 0;
  final int _totalPages = 6;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _burnTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _burnTabController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _getStepTitle(int page) {
    switch (page) {
      case 0:
        return 'Pilih Usia Pasien';
      case 1:
        return 'Informasi Metode';
      case 2:
        return 'Pilih Area Luka Bakar';
      case 3:
        return 'Kebutuhan Cairan';
      case 4:
        return 'ABSI Score';
      case 5:
        return 'Hasil ABSI Score';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationProvider>(
      builder: (context, provider, _) {
        // Hide back button on result page
        final showBackButton = _currentPage < 5;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: showBackButton
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () {
                      if (_currentPage > 0) {
                        _previousPage();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  )
                : null,
            title: Text(
              _getStepTitle(_currentPage),
              style: const TextStyle(
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
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) => setState(() => _currentPage = page),
            children: [
              AgeSelectionPage(onNext: _nextPage),
              InfoPage(onNext: _nextPage),
              BurnInputPage(
                tabController: _burnTabController,
                onNext: _nextPage,
              ),
              ParklandPage(onNext: _nextPage),
              AbsiPage(onNext: _nextPage),
              const AbsiResultPage(),
            ],
          ),
        );
      },
    );
  }
}
