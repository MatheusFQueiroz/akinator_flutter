import 'dart:math' as math;

import '../models/answer.dart';
import '../models/professor.dart';
import '../models/question.dart';

/// Motor de adivinhação baseado em inferência Bayesiana.
///
/// Funcionamento:
///  * Mantém uma distribuição de probabilidade sobre os professores,
///    começando pelos pesos de prior (uniforme, opcionalmente ajustada
///    pelo histórico de aprendizado).
///  * A cada resposta, multiplica a probabilidade de cada professor pela
///    verossimilhança da resposta dada (regra de Bayes) e normaliza.
///  * A próxima pergunta é escolhida dinamicamente: sorteia entre as de
///    maior ganho de informação esperado (maior redução de entropia da
///    distribuição), para a ordem variar entre partidas sem perder
///    qualidade.
///  * Quando a confiança no melhor palpite atinge [confidenceThreshold],
///    o motor sinaliza [shouldGuess] — a UI pergunta "está pensando em X?".
///    Se o jogador rejeitar ([rejectGuess]), o professor é eliminado e o
///    jogo continua até a próxima convicção, acabarem as perguntas
///    informativas ou atingir [maxQuestions].
class GameEngine {
  GameEngine({
    required this.professors,
    required this.questions,
    Map<String, double>? priorWeights,
    this.confidenceThreshold = 0.85,
    this.minQuestions = 5,
    this.maxQuestions = 20,
    int? randomSeed,
  }) : _random = math.Random(randomSeed) {
    _priors = {
      for (final p in professors) p.name: priorWeights?[p.name] ?? 1.0,
    };
    _updatePosterior();
    _currentQuestion = _selectNextQuestion();
  }

  final List<Professor> professors;
  final List<Question> questions;

  final double confidenceThreshold;

  final int minQuestions;

  final int maxQuestions;

  static const double _minInformationGain = 1e-3;

  static const double _gainTolerance = 0.7;

  final math.Random _random;
  final List<AnsweredQuestion> _history = [];
  final Set<String> _rejected = {};
  late Map<String, double> _priors;
  late Map<String, double> _posterior;
  Question? _currentQuestion;

  List<AnsweredQuestion> get history => List.unmodifiable(_history);

  Map<String, double> get probabilities => Map.unmodifiable(_posterior);

  Question? get currentQuestion => _currentQuestion;

  int get questionNumber => _history.length + 1;

  String get bestGuess =>
      _posterior.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

  double get bestProbability =>
      _posterior.values.reduce((a, b) => a >= b ? a : b);

  Set<String> get rejectedGuesses => Set.unmodifiable(_rejected);

  bool get shouldGuess =>
      _history.length >= minQuestions && bestProbability >= confidenceThreshold;

  bool get isFinished =>
      _currentQuestion == null || _history.length >= maxQuestions;

  void answer(Answer answer) {
    final question = _currentQuestion;
    if (question == null) return;
    _history.add(AnsweredQuestion(question: question, answer: answer));
    _updatePosterior();
    _currentQuestion = _selectNextQuestion();
  }

  void undo() {
    if (_history.isEmpty) return;
    final last = _history.removeLast();
    _updatePosterior();
    _currentQuestion = last.question;
  }

  void rejectGuess(String professorName) {
    _rejected.add(professorName);
    _updatePosterior();
    _currentQuestion = _selectNextQuestion();
  }

  static double likelihood(Answer answer, double t) {
    switch (answer) {
      case Answer.sim:
        return 0.1 + 0.8 * t;
      case Answer.nao:
        return 0.9 - 0.8 * t;
      case Answer.provavelmenteSim:
        return 0.3 + 0.4 * t;
      case Answer.provavelmenteNao:
        return 0.7 - 0.4 * t;
      case Answer.naoSei:
        return 1.0;
    }
  }

  void _updatePosterior() {
    final scores = Map<String, double>.from(_priors);
    for (final answered in _history) {
      for (final p in professors) {
        scores[p.name] =
            scores[p.name]! *
            likelihood(
              answered.answer,
              p.probabilityFor(answered.question.attributeId),
            );
      }
    }
    for (final rejected in _rejected) {
      scores[rejected] = 0.0;
    }
    _normalize(scores);
    _posterior = scores;
  }

  void _normalize(Map<String, double> dist) {
    final total = dist.values.fold(0.0, (a, b) => a + b);
    if (total <= 0) {
      final uniform = 1.0 / dist.length;
      dist.updateAll((_, __) => uniform);
      return;
    }
    dist.updateAll((_, v) => v / total);
  }

  Question? _selectNextQuestion() {
    final askedIds = _history.map((h) => h.question.id).toSet();
    final candidates = <(Question, double)>[];
    var bestGain = 0.0;
    for (final q in questions) {
      if (askedIds.contains(q.id)) continue;
      final gain = _informationGain(q);
      if (gain <= _minInformationGain) continue;
      candidates.add((q, gain));
      if (gain > bestGain) bestGain = gain;
    }
    if (candidates.isEmpty) return null;

    final top = [
      for (final (question, gain) in candidates)
        if (gain >= bestGain * _gainTolerance) question,
    ];
    return top[_random.nextInt(top.length)];
  }

  double _informationGain(Question question) {
    final current = _entropy(_posterior.values);
    var expected = 0.0;
    for (final hypothetical in [Answer.sim, Answer.nao]) {
      final joint = <double>[];
      var pAnswer = 0.0;
      for (final p in professors) {
        final v =
            _posterior[p.name]! *
            likelihood(hypothetical, p.probabilityFor(question.attributeId));
        joint.add(v);
        pAnswer += v;
      }
      if (pAnswer <= 0) continue;
      expected += pAnswer * _entropy(joint.map((v) => v / pAnswer));
    }
    return current - expected;
  }

  double _entropy(Iterable<double> dist) {
    var h = 0.0;
    for (final p in dist) {
      if (p > 0) h -= p * math.log(p) / math.ln2;
    }
    return h;
  }
}
