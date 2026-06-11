import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_data.dart';
import '../models/professor.dart';

class LearningService {
  static const _gameResultsKey = 'game_results';
  static const _confusionKey = 'confusion_matrix';
  static const _attrStatsKey = 'attribute_stats';
  static const _maxResults = 100;

  /// Peso da base de conhecimento ao misturar com as observações dos
  /// jogadores: equivale a [_basePseudoCount] partidas "a favor" do valor
  /// original. Quanto maior, mais lento o aprendizado de atributos.
  static const _basePseudoCount = 5.0;

  List<GameResult> _results = [];
  Map<String, int> _confusionMatrix = {};

  /// Evidências acumuladas por "professor|atributo": quantas vezes os
  /// jogadores responderam "sim" ou "não" quando pensavam nesse professor.
  Map<String, Map<String, double>> _attrStats = {};

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

    final attrJson = prefs.getString(_attrStatsKey);
    if (attrJson != null) {
      final map = jsonDecode(attrJson) as Map<String, dynamic>;
      _attrStats = map.map(
        (k, v) => MapEntry(
          k,
          (v as Map<String, dynamic>).map(
            (k2, v2) => MapEntry(k2, (v2 as num).toDouble()),
          ),
        ),
      );
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

    _recordAttributeEvidence(answers, actual);

    await _save();
  }

  /// Acumula as respostas do jogador como evidência sobre os atributos do
  /// professor que ele estava pensando.
  void _recordAttributeEvidence(
    List<Map<String, String>> answers,
    String actual,
  ) {
    for (final answer in answers) {
      final attributeId = answer['attributeId'];
      if (attributeId == null) continue;

      // Respostas firmes pesam 1.0, "provavelmente" pesa 0.5.
      final (String, double)? evidence = switch (answer['answer']) {
        'sim' => ('yes', 1.0),
        'provavelmente sim' => ('yes', 0.5),
        'não' => ('no', 1.0),
        'provavelmente não' => ('no', 0.5),
        _ => null,
      };
      if (evidence == null) continue;

      final key = '$actual|$attributeId';
      final stats = _attrStats.putIfAbsent(key, () => {'yes': 0.0, 'no': 0.0});
      stats[evidence.$1] = (stats[evidence.$1] ?? 0.0) + evidence.$2;
    }
  }

  /// Retorna os professores com os atributos ajustados gradualmente pelo
  /// que os jogadores responderam em partidas confirmadas (suavização
  /// bayesiana: o valor da base vale [_basePseudoCount] observações).
  List<Professor> adjustProfessors(List<Professor> base) {
    if (_attrStats.isEmpty) return base;

    return [
      for (final p in base)
        Professor(
          name: p.name,
          attributes: {
            for (final entry in p.attributes.entries)
              entry.key: _adjustedValue(p.name, entry.key, entry.value),
          },
        ),
    ];
  }

  double _adjustedValue(String professor, String attributeId, double base) {
    final stats = _attrStats['$professor|$attributeId'];
    if (stats == null) return base;
    final yes = stats['yes'] ?? 0.0;
    final no = stats['no'] ?? 0.0;
    return (base * _basePseudoCount + yes) / (_basePseudoCount + yes + no);
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

  int get totalCorrect => totalGames - totalMistakes;

  /// Taxa de acerto (0.0 a 1.0), ou null sem partidas registradas.
  double? get accuracy => totalGames > 0 ? totalCorrect / totalGames : null;

  /// Quantas vezes cada professor era a resposta certa em partidas que o
  /// jogo errou, do mais difícil para o mais fácil.
  List<MapEntry<String, int>> get hardestProfessors {
    final missed = <String, int>{};
    for (final r in _results) {
      if (r.actual != null && r.actual != r.predicted) {
        missed[r.actual!] = (missed[r.actual!] ?? 0) + 1;
      }
    }
    return missed.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  }

  /// Pares de professores mais confundidos entre si (palpite x resposta),
  /// do mais confundido para o menos.
  List<(String, String, int)> get topConfusions {
    final pairs = <(String, String, int)>[];
    _confusionMatrix.forEach((key, count) {
      final parts = key.split('_');
      if (parts.length != 2 || parts[0] == parts[1]) return;
      pairs.add((parts[0], parts[1], count));
    });
    pairs.sort((a, b) => b.$3.compareTo(a.$3));
    return pairs;
  }

  List<GameResult> get recentResults => List.unmodifiable(_results);

  Map<String, int> get confusionMatrix => Map.unmodifiable(_confusionMatrix);

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    final resultsJson = _results.map((r) => r.toJson()).toList();
    await prefs.setString(_gameResultsKey, jsonEncode(resultsJson));

    await prefs.setString(_confusionKey, jsonEncode(_confusionMatrix));
    await prefs.setString(_attrStatsKey, jsonEncode(_attrStats));
  }

  Future<void> clearAll() async {
    _results.clear();
    _confusionMatrix.clear();
    _attrStats.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gameResultsKey);
    await prefs.remove(_confusionKey);
    await prefs.remove(_attrStatsKey);
  }
}
