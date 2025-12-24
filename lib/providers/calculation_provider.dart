import 'package:flutter/foundation.dart';
import '../core/constants/burn_percentages.dart';
import '../data/models/burn_area_model.dart';
import '../data/models/calculation_model.dart';
import '../data/repositories/calculation_repository.dart';

/// Provider for burn calculation state management
class CalculationProvider with ChangeNotifier {
  final CalculationRepository _calculationRepository;

  AgeGroup? _selectedAgeGroup;
  List<BurnArea> _burnAreas = [];
  double _totalTBSA = 0.0;
  String _severity = '';
  bool _isLoading = false;

  CalculationProvider(this._calculationRepository) {
    _initBurnAreas();
  }

  // Getters
  AgeGroup? get selectedAgeGroup => _selectedAgeGroup;
  List<BurnArea> get burnAreas => _burnAreas;
  double get totalTBSA => _totalTBSA;
  String get severity => _severity;
  bool get isLoading => _isLoading;
  bool get hasAgeSelected => _selectedAgeGroup != null;
  List<BurnArea> get selectedAreas =>
      _burnAreas.where((a) => a.isSelected).toList();

  /// Initialize burn areas
  void _initBurnAreas() {
    _burnAreas = BurnArea.createAllAreas();
  }

  /// Select age group
  void selectAgeGroup(AgeGroup ageGroup) {
    _selectedAgeGroup = ageGroup;
    notifyListeners();
  }

  /// Toggle burn area selection
  void toggleBurnArea(int index) {
    _burnAreas[index] = _burnAreas[index].copyWith(
      isSelected: !_burnAreas[index].isSelected,
    );
    notifyListeners();
  }

  /// Calculate total TBSA
  void calculate() {
    if (_selectedAgeGroup == null) return;

    _totalTBSA = 0.0;
    for (final area in _burnAreas) {
      if (area.isSelected) {
        _totalTBSA += area.getPercentage(_selectedAgeGroup!);
      }
    }

    _severity = BurnPercentages.getSeverity(_totalTBSA);
    notifyListeners();
  }

  /// Save calculation to database
  Future<bool> saveCalculation(int userId) async {
    if (_selectedAgeGroup == null) return false;

    _isLoading = true;
    notifyListeners();

    final calculation = Calculation(
      userId: userId,
      ageGroup: _selectedAgeGroup!,
      selectedAreas: selectedAreas.map((a) => a.key).toList(),
      totalTBSA: _totalTBSA,
      severity: _severity,
    );

    final result = await _calculationRepository.saveCalculation(calculation);

    _isLoading = false;
    notifyListeners();

    return result != null;
  }

  /// Get calculation history for user
  Future<List<Calculation>> getHistory(int userId) async {
    return await _calculationRepository.getCalculationsByUser(userId);
  }

  /// Reset calculation state
  void reset() {
    _selectedAgeGroup = null;
    _totalTBSA = 0.0;
    _severity = '';
    _initBurnAreas();
    notifyListeners();
  }

  /// Reset only burn areas (keep age selection)
  void resetAreas() {
    _totalTBSA = 0.0;
    _severity = '';
    _initBurnAreas();
    notifyListeners();
  }
}
