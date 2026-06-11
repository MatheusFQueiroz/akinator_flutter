import 'package:flutter/material.dart';
import '../data/knowledge_base.dart';
import '../models/answer.dart';
import '../services/game_engine.dart';
import '../services/learning_service.dart';
import '../theme/brutal.dart';
import '../widgets/akinator_character.dart';
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
        professors: professors,
        questions: questions,
        priorWeights: {
          for (final p in professors)
            p.name: _learningService.getPriorWeight(p.name),
        },
      );
    });
  }

  void _handleAnswer(Answer answer) {
    final engine = _engine!;
    engine.answer(answer);
    if (engine.isFinished) {
      _goToResult(engine);
    } else {
      setState(() {});
    }
  }

  void _goBack() {
    final engine = _engine!;
    if (engine.history.isEmpty) return;
    setState(engine.undo);
  }

  void _goToResult(GameEngine engine) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          probabilities: Map.from(engine.probabilities),
          answers: [
            for (final h in engine.history)
              {'question': h.question.text, 'answer': h.answer.key},
          ],
          learningService: _learningService,
        ),
      ),
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
                    color: BrutalColors.lilac,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BrutalProgressBar(value: engine.bestProbability),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AkinatorCharacter(size: 110),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BrutalBox(
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
                          const SizedBox(height: 24),
                          Expanded(
                            child: ListView.separated(
                              itemCount: Answer.values.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
