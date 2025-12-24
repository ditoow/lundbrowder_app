import 'package:flutter/foundation.dart';
import '../core/constants/burn_percentages.dart';
import '../core/constants/parkland_constants.dart';
import '../core/constants/absi_constants.dart';
import '../data/models/burn_area_model.dart';
import '../data/models/calculation_model.dart';
import '../data/repositories/calculation_repository.dart';

/// Provider for burn calculation state management
class CalculationProvider with ChangeNotifier {
  final CalculationRepository _calculationRepository;

  // TBSA fields
  AgeGroup? _selectedAgeGroup;
  List<BurnArea> _burnAreas = [];
  double _totalTBSA = 0.0;
  String _severity = '';
  bool _isLoading = false;

  // Parkland fields
  double? _weightKg;
  double _totalFluid = 0.0;
  double _first8Hours = 0.0;
  double _next16Hours = 0.0;

  // ABSI fields
  AgeRange? _ageRange;
  bool _isMale = true;
  bool _hasFullThickness = false;
  bool _hasInhalationInjury = false;
  int _absiScore = 0;
  AbsiRiskLevel? _riskLevel;

  CalculationProvider(this._calculationRepository) {
    _initBurnAreas();
  }

  // TBSA Getters
  AgeGroup? get selectedAgeGroup => _selectedAgeGroup;
  List<BurnArea> get burnAreas => _burnAreas;
  double get totalTBSA => _totalTBSA;
  String get severity => _severity;
  bool get isLoading => _isLoading;
  bool get hasAgeSelected => _selectedAgeGroup != null;
  List<BurnArea> get selectedAreas =>
      _burnAreas.where((a) => a.isSelected).toList();

  // Parkland Getters
  double? get weightKg => _weightKg;
  double get totalFluid => _totalFluid;
  double get first8Hours => _first8Hours;
  double get next16Hours => _next16Hours;
  bool get hasParklandCalculated => _totalFluid > 0;

  // ABSI Getters
  AgeRange? get ageRange => _ageRange;
  bool get isMale => _isMale;
  bool get hasFullThickness => _hasFullThickness;
  bool get hasInhalationInjury => _hasInhalationInjury;
  int get absiScore => _absiScore;
  AbsiRiskLevel? get riskLevel => _riskLevel;
  bool get hasAbsiCalculated => _riskLevel != null;

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

  // ============ PARKLAND METHODS ============

  /// Set patient weight
  void setWeight(double kg) {
    _weightKg = kg;
    notifyListeners();
  }

  /// Calculate Parkland fluid requirement
  void calculateParkland() {
    if (_weightKg == null || _weightKg! <= 0 || _totalTBSA <= 0) return;

    _totalFluid = ParklandFormula.calculateTotal(_weightKg!, _totalTBSA);
    _first8Hours = ParklandFormula.getFirst8Hours(_totalFluid);
    _next16Hours = ParklandFormula.getNext16Hours(_totalFluid);
    notifyListeners();
  }

  // ============ ABSI METHODS ============

  /// Set ABSI age range
  void setAgeRange(AgeRange range) {
    _ageRange = range;
    notifyListeners();
  }

  /// Set ABSI age from number (auto-converts to AgeRange)
  void setAgeFromNumber(int age) {
    if (age <= 20) {
      _ageRange = AgeRange.age0to20;
    } else if (age <= 40) {
      _ageRange = AgeRange.age21to40;
    } else if (age <= 60) {
      _ageRange = AgeRange.age41to60;
    } else {
      _ageRange = AgeRange.age60plus;
    }
    notifyListeners();
  }

  /// Set patient sex
  void setSex(bool isMale) {
    _isMale = isMale;
    notifyListeners();
  }

  /// Set full thickness burn status
  void setFullThickness(bool value) {
    _hasFullThickness = value;
    notifyListeners();
  }

  /// Set inhalation injury status
  void setInhalationInjury(bool value) {
    _hasInhalationInjury = value;
    notifyListeners();
  }

  /// Calculate ABSI score
  void calculateAbsiScore() {
    if (_ageRange == null) return;

    _absiScore = AbsiScore.calculateTotal(
      isMale: _isMale,
      ageRange: _ageRange!,
      tbsaPercent: _totalTBSA,
      hasFullThickness: _hasFullThickness,
      hasInhalationInjury: _hasInhalationInjury,
    );

    _riskLevel = AbsiScore.getRiskLevel(_absiScore);
    notifyListeners();
  }

  /// Get ABSI score breakdown
  Map<String, int> getAbsiBreakdown() {
    if (_ageRange == null) return {};

    return AbsiScore.getScoreBreakdown(
      isMale: _isMale,
      ageRange: _ageRange!,
      tbsaPercent: _totalTBSA,
      hasFullThickness: _hasFullThickness,
      hasInhalationInjury: _hasInhalationInjury,
    );
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
    _resetParkland();
    _resetAbsi();
    notifyListeners();
  }

  /// Reset only burn areas (keep age selection)
  void resetAreas() {
    _totalTBSA = 0.0;
    _severity = '';
    _initBurnAreas();
    notifyListeners();
  }

  /// Reset Parkland fields
  void _resetParkland() {
    _weightKg = null;
    _totalFluid = 0.0;
    _first8Hours = 0.0;
    _next16Hours = 0.0;
  }

  /// Reset ABSI fields
  void _resetAbsi() {
    _ageRange = null;
    _isMale = true;
    _hasFullThickness = false;
    _hasInhalationInjury = false;
    _absiScore = 0;
    _riskLevel = null;
  }
}
