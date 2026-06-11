import 'package:flutter/material.dart';
import '../data/knowledge_base.dart';
import '../services/learning_service.dart';
import '../theme/brutal.dart';
import '../widgets/akinator_character.dart';
import '../widgets/professor_avatar.dart';
import 'welcome_screen.dart';

class ResultScreen extends StatefulWidget {
  /// Distribuição de probabilidade final do GameEngine (soma 1.0).
  final Map<String, double> probabilities;
  final List<Map<String, String>> answers;
  final LearningService learningService;

  /// True quando o jogador já confirmou o palpite no diálogo intermediário
  /// ("está pensando em X?") — a tela vira uma celebração direta.
  final bool confirmedCorrect;

  const ResultScreen({
    super.key,
    required this.probabilities,
    required this.answers,
    required this.learningService,
    this.confirmedCorrect = false,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String _predicted;
  late List<MapEntry<String, double>> _ranking;
  late int _confidence;

  @override
  void initState() {
    super.initState();
    final sorted = widget.probabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    _ranking = sorted;
    _predicted = sorted.isNotEmpty ? sorted.first.key : 'Desconhecido';
    _confidence = sorted.isNotEmpty ? (sorted.first.value * 100).round() : 0;

    if (widget.confirmedCorrect) {
      widget.learningService.saveGameResult(
        answers: widget.answers,
        predicted: _predicted,
        actual: _predicted,
      );
    }
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
    final sorted = allProfessors.toList()..sort();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalColors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: BrutalColors.ink, width: 3),
        ),
        title: const Text(
          'QUEM ERA O PROFESSOR?',
          style: TextStyle(
            color: BrutalColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
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
                  style: const TextStyle(
                    color: BrutalColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
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
        backgroundColor: BrutalColors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: BrutalColors.ink, width: 3),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              acertou ? '🎉 ACERTEI!' : '😅 ERREI!',
              style: const TextStyle(
                color: BrutalColors.ink,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (!acertou && correctProfessor != null) ...[
              const SizedBox(height: 8),
              Text(
                'O professor era: $correctProfessor',
                style: const TextStyle(
                  color: BrutalColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 12),
            const BrutalTag(
              text: 'Aprendizado salvo',
              color: BrutalColors.lightGreen,
            ),
          ],
        ),
        actions: [
          BrutalButton(
            color: BrutalColors.yellow,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shadowOffset: 3,
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              );
            },
            child: const Text(
              'JOGAR NOVAMENTE',
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

  @override
  Widget build(BuildContext context) {
    final second = _ranking.length > 1 ? _ranking[1] : null;
    final confirmed = widget.confirmedCorrect;

    return Scaffold(
      backgroundColor: BrutalColors.bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AkinatorCharacter(size: 110)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BrutalTag(
                        text: confirmed ? '🎉 Acertei!' : 'Eu acho que é...',
                        color: confirmed
                            ? BrutalColors.green
                            : BrutalColors.yellow,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                    child: BrutalBox(
                      padding: const EdgeInsets.all(24),
                      shadowOffset: 7,
                      child: Column(
                        children: [
                          ProfessorAvatar(name: _predicted, radius: 70),
                          const SizedBox(height: 16),
                          Text(
                            _predicted.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                              color: BrutalColors.ink,
                            ),
                          ),
                          const SizedBox(height: 12),
                          BrutalTag(
                            text: '$_confidence% de certeza',
                            color: BrutalColors.lilac,
                          ),
                          if (!confirmed && second != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              'Segunda opção: ${second.key} '
                              '(${(second.value * 100).round()}%)',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: BrutalColors.ink,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (!confirmed) ...[
                    Row(
                      children: [
                        Expanded(
                          child: BrutalButton(
                            color: BrutalColors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            onPressed: _onCorrect,
                            child: const Center(
                              child: Text(
                                '✅ ACERTOU!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: BrutalColors.ink,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: BrutalButton(
                            color: BrutalColors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            onPressed: _onWrong,
                            child: const Center(
                              child: Text(
                                '❌ ERROU!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: BrutalColors.ink,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                  ],
                  if (widget.learningService.totalGames > 0) ...[
                    BrutalBox(
                      color: BrutalColors.lilac,
                      shadowOffset: 4,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'JOGOS: ${widget.learningService.totalGames}  |  '
                        'ERROS: ${widget.learningService.totalMistakes}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: BrutalColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  BrutalButton(
                    color: BrutalColors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shadowOffset: 6,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WelcomeScreen(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'JOGAR NOVAMENTE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          color: BrutalColors.white,
                        ),
                      ),
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
