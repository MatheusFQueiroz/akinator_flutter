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
///  * A próxima pergunta é escolhida dinamicamente: a que maximiza o ganho
///    de informação esperado (maior redução de entropia da distribuição).
///  * O jogo termina cedo quando a confiança no melhor palpite atinge
///    [confidenceThreshold], ou quando não há mais perguntas informativas,
///    ou ao atingir [maxQuestions].
class GameEngine {
  GameEngine({
    required this.professors,
    required this.questions,
    Map<String, double>? priorWeights,
    this.confidenceThreshold = 0.85,
    this.minQuestions = 5,
    this.maxQuestions = 15,
  }) {
    _priors = {
      for (final p in professors) p.name: priorWeights?[p.name] ?? 1.0,
    };
    _recompute();
  }

  final List<Professor> professors;
  final List<Question> questions;

  /// Confiança mínima do melhor palpite para encerrar o jogo cedo.
  final double confidenceThreshold;

  /// Número mínimo de perguntas antes de permitir o encerramento.
  final int minQuestions;

  /// Número máximo de perguntas por partida.
  final int maxQuestions;

  /// Ganho de informação mínimo para uma pergunta valer a pena.
  static const double _minInformationGain = 1e-3;

  final List<AnsweredQuestion> _history = [];
  late Map<String, double> _priors;
  late Map<String, double> _posterior;
  Question? _currentQuestion;

  /// Perguntas já respondidas nesta partida.
  List<AnsweredQuestion> get history => List.unmodifiable(_history);

  /// Distribuição de probabilidade atual sobre os professores.
  Map<String, double> get probabilities => Map.unmodifiable(_posterior);

  /// Pergunta selecionada para ser feita agora (null se não houver
  /// nenhuma pergunta informativa restante).
  Question? get currentQuestion => _currentQuestion;

  /// Número da pergunta atual (1-based), para exibição.
  int get questionNumber => _history.length + 1;

  /// Professor mais provável no momento.
  String get bestGuess =>
      _posterior.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

  /// Probabilidade do melhor palpite (0.0 a 1.0).
  double get bestProbability =>
      _posterior.values.reduce((a, b) => a >= b ? a : b);

  /// Indica se o jogo deve terminar e exibir o palpite.
  bool get isFinished {
    if (_currentQuestion == null) return true;
    if (_history.length >= maxQuestions) return true;
    return _history.length >= minQuestions &&
        bestProbability >= confidenceThreshold;
  }

  /// Registra a resposta do jogador para a pergunta atual.
  void answer(Answer answer) {
    final question = _currentQuestion;
    if (question == null) return;
    _history.add(AnsweredQuestion(question: question, answer: answer));
    _recompute();
  }

  /// Desfaz a última resposta (botão "voltar").
  void undo() {
    if (_history.isEmpty) return;
    _history.removeLast();
    _recompute();
  }

  /// Verossimilhança de o jogador dar [answer] para um professor cujo
  /// atributo tem probabilidade [t] de ser "sim". Os extremos não chegam
  /// a 0/1 para tolerar respostas erradas do jogador.
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

  void _recompute() {
    final scores = Map<String, double>.from(_priors);
    for (final answered in _history) {
      for (final p in professors) {
        scores[p.name] = scores[p.name]! *
            likelihood(
              answered.answer,
              p.probabilityFor(answered.question.attributeId),
            );
      }
    }
    _normalize(scores);
    _posterior = scores;
    _currentQuestion = _selectNextQuestion();
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
    Question? best;
    var bestGain = _minInformationGain;
    for (final q in questions) {
      if (askedIds.contains(q.id)) continue;
      final gain = _informationGain(q);
      if (gain > bestGain) {
        bestGain = gain;
        best = q;
      }
    }
    return best;
  }

  /// Ganho de informação esperado da pergunta: entropia atual menos a
  /// entropia esperada da distribuição após uma resposta sim/não.
  double _informationGain(Question question) {
    final current = _entropy(_posterior.values);
    var expected = 0.0;
    for (final hypothetical in [Answer.sim, Answer.nao]) {
      final joint = <double>[];
      var pAnswer = 0.0;
      for (final p in professors) {
        final v = _posterior[p.name]! *
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
