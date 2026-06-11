import 'package:flutter_test/flutter_test.dart';
import 'package:akinator_mobile/data/knowledge_base.dart';
import 'package:akinator_mobile/models/answer.dart';
import 'package:akinator_mobile/models/professor.dart';
import 'package:akinator_mobile/services/game_engine.dart';

/// Responde como um jogador perfeito que pensa no [professor].
Answer _idealAnswer(Professor professor, String attributeId) {
  final t = professor.probabilityFor(attributeId);
  if (t > 0.5) return Answer.sim;
  if (t < 0.5) return Answer.nao;
  return Answer.naoSei;
}

GameEngine _newEngine() =>
    GameEngine(professors: professors, questions: questions);

/// Joga com respostas ideais até o motor querer palpitar ou acabar.
void _playFor(GameEngine engine, Professor professor) {
  while (!engine.isFinished && !engine.shouldGuess) {
    final q = engine.currentQuestion!;
    engine.answer(_idealAnswer(professor, q.attributeId));
  }
}

void main() {
  test('começa com distribuição uniforme e uma pergunta selecionada', () {
    final engine = _newEngine();
    expect(engine.currentQuestion, isNotNull);
    expect(engine.isFinished, isFalse);
    expect(engine.shouldGuess, isFalse);
    final uniform = 1.0 / professors.length;
    for (final p in engine.probabilities.values) {
      expect(p, closeTo(uniform, 1e-9));
    }
  });

  test('não repete perguntas na mesma partida', () {
    final engine = _newEngine();
    final asked = <int>{};
    while (!engine.isFinished) {
      final q = engine.currentQuestion!;
      expect(
        asked.contains(q.id),
        isFalse,
        reason: 'Pergunta ${q.id} repetida',
      );
      asked.add(q.id);
      engine.answer(Answer.naoSei);
    }
  });

  test('palpita corretamente cada professor com respostas ideais', () {
    for (final professor in professors) {
      final engine = _newEngine();
      _playFor(engine, professor);
      expect(
        engine.bestGuess,
        professor.name,
        reason:
            'Falhou para ${professor.name} '
            'após ${engine.history.length} perguntas',
      );
    }
  });

  test('quer palpitar cedo, antes de esgotar as perguntas', () {
    final professor = professors.first; // Fabiane
    final engine = _newEngine();
    _playFor(engine, professor);
    expect(engine.shouldGuess, isTrue);
    expect(engine.history.length, lessThan(questions.length));
    expect(engine.history.length, greaterThanOrEqualTo(engine.minQuestions));
  });

  test('palpite rejeitado elimina o professor e o jogo continua', () {
    final professor = professors.first; // Fabiane
    final engine = _newEngine();
    _playFor(engine, professor);
    expect(engine.bestGuess, professor.name);

    engine.rejectGuess(professor.name);
    expect(engine.probabilities[professor.name], 0.0);
    expect(engine.bestGuess, isNot(professor.name));
    expect(engine.rejectedGuesses, contains(professor.name));
  });

  test('undo restaura a distribuição anterior', () {
    final engine = _newEngine();
    final before = Map<String, double>.from(engine.probabilities);
    final firstQuestion = engine.currentQuestion;

    engine.answer(Answer.sim);
    expect(engine.probabilities, isNot(equals(before)));

    engine.undo();
    expect(engine.currentQuestion?.id, firstQuestion?.id);
    engine.probabilities.forEach((name, p) {
      expect(p, closeTo(before[name]!, 1e-9));
    });
  });

  test('prior maior favorece o professor em caso de empate', () {
    final engine = GameEngine(
      professors: professors,
      questions: questions,
      priorWeights: {'Marcel': 1.5},
    );
    expect(
      engine.probabilities['Marcel']!,
      greaterThan(engine.probabilities['Jhoni']!),
    );
  });

  test('perguntas sem informação (atributos desconhecidos) não são feitas', () {
    // aulaProgramacao, maisDe40Anos e aulaSemestre2 estão como 0.5 para
    // todos os professores até serem preenchidas.
    final unknownIds = {19, 20, 21};
    final engine = _newEngine();
    while (!engine.isFinished) {
      final q = engine.currentQuestion!;
      expect(
        unknownIds.contains(q.id),
        isFalse,
        reason: 'Pergunta ${q.id} não diferencia ninguém',
      );
      engine.answer(Answer.naoSei);
    }
  });
}
