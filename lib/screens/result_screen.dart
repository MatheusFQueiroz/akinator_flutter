import 'package:flutter/material.dart';
import '../data/questions.dart';
import '../services/learning_service.dart';
import '../widgets/akinator_character.dart';
import '../widgets/professor_avatar.dart';
import 'welcome_screen.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, double> scores;
  final List<Map<String, String>> answers;
  final LearningService learningService;

  const ResultScreen({
    super.key,
    required this.scores,
    required this.answers,
    required this.learningService,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String _predicted;
  late List<MapEntry<String, double>> _top5;
  late int _confidence;

  @override
  void initState() {
    super.initState();
    _calculateResult();
  }

  void _calculateResult() {
    final sorted = widget.scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    _top5 = sorted.take(5).toList();

    _predicted = _top5.isNotEmpty ? _top5.first.key : 'Desconhecido';
    final total = widget.scores.values.fold(0.0, (a, b) => a + b);
    _confidence = total > 0
        ? ((_top5.first.value / total) * 100).round()
        : 0;
  }

  void _onCorrect() {
    widget.learningService.saveGameResult(
      answers: widget.answers,
      predicted: _predicted,
      actual: _predicted,
    );
    _showPlayAgainDialog(acertou: true);
  }

  void _onWrong() {
    _showWrongDialog();
  }

  void _showWrongDialog() {
    final sorted = allProfessors.toList()..sort();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B4E),
        title: const Text(
          'Quem era o professor?',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final prof = sorted[index];
              return ListTile(
                leading: ProfessorAvatar(name: prof, radius: 20),
                title: Text(
                  prof,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.learningService.saveGameResult(
                    answers: widget.answers,
                    predicted: _predicted,
                    actual: prof,
                  );
                  _showPlayAgainDialog(acertou: false, correctProfessor: prof);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showPlayAgainDialog({required bool acertou, String? correctProfessor}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B4E),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              acertou ? '🎉 Acertei!' : '😅 Errei!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!acertou && correctProfessor != null) ...[
              const SizedBox(height: 8),
              Text(
                'O professor era: $correctProfessor',
                style: const TextStyle(
                  color: Color(0xFFC084FC),
                  fontSize: 16,
                ),
              ),
            ],
            const SizedBox(height: 8),
            const Text(
              'O aprendizado foi salvo!',
              style: TextStyle(
                color: Color(0xFFA855F7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              );
            },
            child: const Text(
              'Jogar Novamente',
              style: TextStyle(color: Color(0xFFA855F7)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0033),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AkinatorCharacter(size: 120),
              const SizedBox(height: 8),
              const Text(
                'Eu acho que você está pensando em...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFC084FC),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFFA855F7), Color(0xFFE879F9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: const Color(0xFF2D1B4E),
                  child: ProfessorAvatar(name: _predicted, radius: 76),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _predicted,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _onCorrect,
                      icon: const Text('✅', style: TextStyle(fontSize: 18)),
                      label: const Text(
                        'Acertou!',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _onWrong,
                      icon: const Text('❌', style: TextStyle(fontSize: 18)),
                      label: const Text(
                        'Errou!',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (widget.learningService.totalGames > 0) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D1B4E).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Jogos: ${widget.learningService.totalGames} | '
                    'Erros: ${widget.learningService.totalMistakes}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFC084FC),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WelcomeScreen(),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Jogar Novamente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
