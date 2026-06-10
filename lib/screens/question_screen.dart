import 'package:flutter/material.dart';
import '../data/questions.dart';
import '../services/learning_service.dart';
import '../widgets/akinator_character.dart';
import 'result_screen.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentIndex = 0;
  final Map<String, double> _scores = {};
  final List<Map<String, String>> _answers = [];
  final LearningService _learningService = LearningService();
  String? _lastPredicted;
  bool _initialized = false;

  static const Map<String, double> _baseWeights = {
    'sim': 3.0,
    'não': 3.0,
    'provavelmente sim': 1.0,
    'provavelmente não': 1.0,
    'não sei': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _learningService.load();
    for (var p in allProfessors) {
      _scores[p] = 0.0;
    }
    setState(() => _initialized = true);
  }

  void _recalculateScores() {
    for (var p in _scores.keys) {
      _scores[p] = 0.0;
    }
    String? lastPredicted;
    for (final answer in _answers) {
      final q = questions.firstWhere((q) => q.question == answer['question']);
      final answerKey = answer['answer']!;
      final baseWeight = _baseWeights[answerKey] ?? 0;
      if (answerKey != 'não sei') {
        final group = q.answers[answerKey] ?? [];
        for (var prof in _scores.keys) {
          if (group.contains(prof)) {
            _scores[prof] = _scores[prof]! + baseWeight;
          }
        }
      }
      _scores.forEach((prof, score) {
        final total = _scores.values.fold(0.0, (a, b) => a + b);
        if (total > 0 && score > 0) {
          final conf = (score / total) * 100;
          if (conf > 50) lastPredicted = prof;
        }
      });
    }
    _lastPredicted = lastPredicted;
  }

  void _goBack() {
    if (_currentIndex == 0) return;
    setState(() {
      _answers.removeLast();
      _currentIndex--;
      _recalculateScores();
    });
  }

  Prediction _getBestPrediction() {
    String best = allProfessors.first;
    double bestScore = -1;
    double totalScore = 0;

    _scores.forEach((prof, score) {
      totalScore += score;
      if (score > bestScore) {
        bestScore = score;
        best = prof;
      }
    });

    int conf = totalScore > 0 ? ((bestScore / totalScore) * 100).round() : 0;
    return Prediction(professor: best, confidence: conf);
  }

  void _handleAnswer(String answerKey) {
    final question = _currentIndex < questions.length
        ? questions[_currentIndex]
        : null;
    if (question == null) return;

    final baseWeight = _baseWeights[answerKey] ?? 0;

    if (answerKey != 'não sei') {
      final group = question.answers[answerKey] ?? [];
      for (var prof in _scores.keys) {
        if (group.contains(prof)) {
          _scores[prof] = _scores[prof]! + baseWeight;
        } else if (answerKey == 'sim' || answerKey == 'provavelmente sim') {
          _scores[prof] = _scores[prof]! + 0;
        } else if (answerKey == 'não' || answerKey == 'provavelmente não') {
          final naoGroup = question.answers['não'] ?? [];
          if (!naoGroup.contains(prof)) {
            // Not in NÃO group either — neutral
          }
        }
      }

      if (_lastPredicted != null) {
        final prediction = _getBestPrediction();
        final boost = _learningService.getBoost(
          question.id,
          _lastPredicted!,
          prediction.professor,
        );
        if (boost > 0) {
          for (var prof in group) {
            _scores[prof] = _scores[prof]! + boost;
          }
        }
      }
    }

    _answers.add({
      'question': question.question,
      'answer': answerKey,
    });

    final prediction = _getBestPrediction();
    _lastPredicted = prediction.professor;

    setState(() {
      if (_currentIndex < questions.length - 1) {
        _currentIndex++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              scores: Map.from(_scores),
              answers: List.from(_answers),
              learningService: _learningService,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A0033),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[_currentIndex];
    final progress = (_currentIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0033),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _currentIndex == 0 ? null : _goBack,
                    icon: Icon(
                      Icons.arrow_back,
                      color: _currentIndex == 0
                          ? const Color(0xFF555555)
                          : const Color(0xFFC084FC),
                    ),
                    tooltip: 'Voltar',
                  ),
                  Text(
                    'Pergunta ${_currentIndex + 1} de ${questions.length}',
                    style: const TextStyle(
                      color: Color(0xFFC084FC),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFF333333),
                  color: const Color(0xFFA855F7),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AkinatorCharacter(size: 120),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D1B4E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF4A2D7A)),
                            ),
                            child: Text(
                              question.question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: ListView.separated(
                              itemCount: 5,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final entries = [
                                  ('sim', 'Sim', Colors.green),
                                  ('provavelmente sim', 'Provavelmente sim', Colors.lightGreen),
                                  ('não sei', 'Não sei', Colors.grey),
                                  ('provavelmente não', 'Provavelmente não', Colors.orange),
                                  ('não', 'Não', Colors.red),
                                ];
                                final entry = entries[index];
                                final answerKey = entry.$1;
                                final label = entry.$2;
                                final color = entry.$3;

                                return FilledButton(
                                  onPressed: () => _handleAnswer(answerKey),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: color,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      label,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
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

class Prediction {
  final String professor;
  final int confidence;

  Prediction({required this.professor, required this.confidence});
}
