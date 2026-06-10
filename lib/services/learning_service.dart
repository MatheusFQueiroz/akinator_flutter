import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_data.dart';

class LearningService {
  static const _gameResultsKey = 'game_results';
  static const _confusionKey = 'confusion_matrix';
  static const _maxResults = 100;

  List<GameResult> _results = [];
  Map<String, int> _confusionMatrix = {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final resultsJson = prefs.getString(_gameResultsKey);
    if (resultsJson != null) {
      final list = jsonDecode(resultsJson) as List;
      _results = list.map((e) => GameResult.fromJson(e)).toList();
    }

    final confusionJson = prefs.getString(_confusionKey);
    if (confusionJson != null) {
      final map = jsonDecode(confusionJson) as Map<String, dynamic>;
      _confusionMatrix = map.map((k, v) => MapEntry(k, v as int));
    }
  }

  Future<void> saveGameResult({
    required List<Map<String, String>> answers,
    required String predicted,
    required String actual,
  }) async {
    final result = GameResult(
      answers: answers,
      predicted: predicted,
      actual: actual,
      timestamp: DateTime.now(),
    );

    _results.add(result);
    if (_results.length > _maxResults) {
      _results = _results.sublist(_results.length - _maxResults);
    }

    final pairKey = ConfusionPair(
      professorA: predicted,
      professorB: actual,
    ).key;
    _confusionMatrix[pairKey] = (_confusionMatrix[pairKey] ?? 0) + 1;

    await _save();
  }

  int getConfusionCount(String profA, String profB) {
    final pairKey = ConfusionPair(
      professorA: profA,
      professorB: profB,
    ).key;
    return _confusionMatrix[pairKey] ?? 0;
  }

  double getBoost(int questionId, String predicted, String actual) {
    final confusion = getConfusionCount(predicted, actual);
    if (confusion <= 0) return 0.0;

    final boost = confusion * 0.3;
    return boost > 2.0 ? 2.0 : boost;
  }

  int get totalGames => _results.length;

  int get totalMistakes =>
      _results.where((r) => r.actual != null && r.actual != r.predicted).length;

  List<GameResult> get recentResults => List.unmodifiable(_results);

  Map<String, int> get confusionMatrix => Map.unmodifiable(_confusionMatrix);

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    final resultsJson = _results.map((r) => r.toJson()).toList();
    await prefs.setString(_gameResultsKey, jsonEncode(resultsJson));

    await prefs.setString(_confusionKey, jsonEncode(_confusionMatrix));
  }

  Future<void> clearAll() async {
    _results.clear();
    _confusionMatrix.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gameResultsKey);
    await prefs.remove(_confusionKey);
  }
}
