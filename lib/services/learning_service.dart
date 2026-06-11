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
    final pairKey = ConfusionPair(professorA: profA, professorB: profB).key;
    return _confusionMatrix[pairKey] ?? 0;
  }

  /// Peso de prior para o professor no início da partida. Professores que
  /// eram a resposta certa em partidas que o jogo errou recebem um leve
  /// reforço inicial, corrigindo a tendência do motor de subestimá-los.
  double getPriorWeight(String professor) {
    var missed = 0;
    for (final r in _results) {
      if (r.actual == professor && r.predicted != professor) {
        missed++;
      }
    }
    final weight = 1.0 + missed * 0.15;
    return weight > 1.75 ? 1.75 : weight;
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
