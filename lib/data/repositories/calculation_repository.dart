import '../models/calculation_model.dart';
import '../services/database_service.dart';

/// Repository for calculation database operations
class CalculationRepository {
  final DatabaseService _databaseService;

  CalculationRepository(this._databaseService);

  /// Save calculation
  Future<Calculation?> saveCalculation(Calculation calculation) async {
    try {
      final db = await _databaseService.database;
      final id = await db.insert('calculations', calculation.toMap());
      return Calculation(
        id: id,
        userId: calculation.userId,
        ageGroup: calculation.ageGroup,
        selectedAreas: calculation.selectedAreas,
        totalTBSA: calculation.totalTBSA,
        severity: calculation.severity,
        createdAt: calculation.createdAt,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all calculations for a user
  Future<List<Calculation>> getCalculationsByUser(int userId) async {
    final db = await _databaseService.database;
    final results = await db.query(
      'calculations',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => Calculation.fromMap(map)).toList();
  }

  /// Get single calculation by id
  Future<Calculation?> getCalculationById(int id) async {
    final db = await _databaseService.database;
    final results = await db.query(
      'calculations',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;
    return Calculation.fromMap(results.first);
  }

  /// Delete calculation
  Future<bool> deleteCalculation(int id) async {
    try {
      final db = await _databaseService.database;
      await db.delete('calculations', where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }
}
