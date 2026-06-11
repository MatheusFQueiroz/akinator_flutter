import 'package:flutter/material.dart';
import '../data/knowledge_base.dart';
import '../models/answer.dart';
import '../models/question.dart';
import '../services/game_engine.dart';
import '../services/learning_service.dart';
import '../theme/brutal.dart';
import '../widgets/akinator_character.dart';
import '../widgets/professor_avatar.dart';
import 'result_screen.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final LearningService _learningService = LearningService();
  GameEngine? _engine;

  static const _answerColors = {
    Answer.sim: BrutalColors.green,
    Answer.provavelmenteSim: BrutalColors.lightGreen,
    Answer.naoSei: BrutalColors.gray,
    Answer.provavelmenteNao: BrutalColors.orange,
    Answer.nao: BrutalColors.red,
  };

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _learningService.load();
    if (!mounted) return;
    setState(() {
      _engine = GameEngine(
        // Atributos ajustados pelo que os jogadores responderam em
        // partidas anteriores (aprendizado contínuo).
        professors: _learningService.adjustProfessors(professors),
        questions: questions,
        priorWeights: {
          for (final p in professors)
            p.name: _learningService.getPriorWeight(p.name),
        },
      );
    });
  }

  /// Humor do personagem conforme a convicção atual.
  String _mood(double confidence) {
    if (confidence < 0.35) return '🤔';
    if (confidence < 0.65) return '🧐';
    return '😏';
  }

  Color _confidenceColor(double confidence) {
    if (confidence < 0.5) return BrutalColors.lilac;
    if (confidence < 0.75) return BrutalColors.yellow;
    return BrutalColors.green;
  }

  void _handleAnswer(Answer answer) {
    final engine = _engine!;
    engine.answer(answer);
    if (engine.shouldGuess) {
      setState(() {});
      _showGuessDialog(engine);
    } else if (engine.isFinished) {
      _goToResult(engine, confirmed: false);
    } else {
      setState(() {});
    }
  }

  void _goBack() {
    final engine = _engine!;
    if (engine.history.isEmpty) return;
    setState(engine.undo);
  }

  /// Palpite intermediário, como no Akinator: "está pensando em X?".
  void _showGuessDialog(GameEngine engine) {
    final guess = engine.bestGuess;
    final confidence = (engine.bestProbability * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalColors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: BrutalColors.ink, width: 3),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrutalTag(
              text: 'Tenho um palpite!',
              color: BrutalColors.yellow,
            ),
            const SizedBox(height: 16),
            ProfessorAvatar(name: guess, radius: 48),
            const SizedBox(height: 12),
            Text(
              'Você está pensando em\n$guess?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: BrutalColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Certeza: $confidence%',
              style: const TextStyle(
                color: BrutalColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          BrutalButton(
            color: BrutalColors.green,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shadowOffset: 3,
            onPressed: () {
              Navigator.pop(ctx);
              _goToResult(engine, confirmed: true);
            },
            child: const Text(
              'SIM!',
              style: TextStyle(
                color: BrutalColors.ink,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          BrutalButton(
            color: BrutalColors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shadowOffset: 3,
            onPressed: () {
              Navigator.pop(ctx);
              engine.rejectGuess(guess);
              if (engine.shouldGuess) {
                setState(() {});
                _showGuessDialog(engine);
              } else if (engine.isFinished) {
                _goToResult(engine, confirmed: false);
              } else {
                setState(() {});
              }
            },
            child: const Text(
              'NÃO',
              style: TextStyle(
                color: BrutalColors.ink,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToResult(GameEngine engine, {required bool confirmed}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          probabilities: Map.from(engine.probabilities),
          answers: [
            for (final h in engine.history)
              {
                'question': h.question.text,
                'answer': h.answer.key,
                'attributeId': h.question.attributeId,
              },
          ],
          learningService: _learningService,
          confirmedCorrect: confirmed,
        ),
      ),
    );
  }

  Widget _questionPanel(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.15, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: BrutalBox(
            key: ValueKey(question.id),
            padding: const EdgeInsets.all(24),
            child: Text(
              question.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: BrutalColors.ink,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: Answer.values.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final answer = Answer.values[index];
              return BrutalButton(
                color: _answerColors[answer]!,
                shadowOffset: 4,
                onPressed: () => _handleAnswer(answer),
                child: Text(
                  answer.label.toUpperCase(),
                  style: const TextStyle(
                    color: BrutalColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _character(double size, double confidence) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AkinatorCharacter(size: size),
        Positioned(
          right: -10,
          top: -10,
          child: BrutalBox(
            color: BrutalColors.white,
            shadowOffset: 2,
            borderWidth: 2,
            padding: const EdgeInsets.all(4),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _mood(confidence),
                key: ValueKey(_mood(confidence)),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final engine = _engine;
    final question = engine?.currentQuestion;
    if (engine == null || question == null) {
      return const Scaffold(
        backgroundColor: BrutalColors.bg,
        body: Center(
          child: CircularProgressIndicator(color: BrutalColors.purple),
        ),
      );
    }

    final confidence = (engine.bestProbability * 100).round();

    return Scaffold(
      backgroundColor: BrutalColors.bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      BrutalButton(
                        color: BrutalColors.white,
                        padding: const EdgeInsets.all(8),
                        shadowOffset: 3,
                        onPressed: engine.history.isEmpty ? null : _goBack,
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: BrutalColors.ink,
                        ),
                      ),
                      const SizedBox(width: 12),
                      BrutalTag(
                        text: 'Pergunta ${engine.questionNumber}',
                        color: BrutalColors.yellow,
                      ),
                      const Spacer(),
                      BrutalTag(
                        text: 'Certeza $confidence%',
                        color: _confidenceColor(engine.bestProbability),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Em telas estreitas o personagem vai para cima da
                        // pergunta; em telas largas fica ao lado.
                        if (constraints.maxWidth < 480) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: _character(80, engine.bestProbability),
                              ),
                              const SizedBox(height: 16),
                              Expanded(child: _questionPanel(question)),
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _character(110, engine.bestProbability),
                            const SizedBox(width: 24),
                            Expanded(child: _questionPanel(question)),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
