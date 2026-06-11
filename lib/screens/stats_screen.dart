import 'package:flutter/material.dart';
import '../services/learning_service.dart';
import '../theme/brutal.dart';
import '../widgets/professor_avatar.dart';

/// Estatísticas do aprendizado: taxa de acerto, professores mais difíceis
/// e pares mais confundidos.
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final LearningService _learningService = LearningService();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _learningService.load().then((_) {
      if (mounted) setState(() => _loaded = true);
    });
  }

  void _confirmClear() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalColors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: BrutalColors.ink, width: 3),
        ),
        title: const Text(
          'APAGAR APRENDIZADO?',
          style: TextStyle(
            color: BrutalColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: const Text(
          'Todo o histórico de partidas e os ajustes aprendidos serão '
          'perdidos. Essa ação não pode ser desfeita.',
          style: TextStyle(color: BrutalColors.ink, fontSize: 14),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          BrutalButton(
            color: BrutalColors.gray,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shadowOffset: 3,
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'CANCELAR',
              style: TextStyle(
                color: BrutalColors.ink,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          BrutalButton(
            color: BrutalColors.red,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shadowOffset: 3,
            onPressed: () async {
              await _learningService.clearAll();
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) setState(() {});
            },
            child: const Text(
              'APAGAR',
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

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
          color: BrutalColors.ink,
        ),
      ),
    );
  }

  Widget _bigNumber(String label, String value, Color color) {
    return Expanded(
      child: BrutalBox(
        color: color,
        shadowOffset: 4,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: BrutalColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: BrutalColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrutalColors.bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: !_loaded
                ? const Center(
                    child: CircularProgressIndicator(
                      color: BrutalColors.purple,
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            BrutalButton(
                              color: BrutalColors.white,
                              padding: const EdgeInsets.all(8),
                              shadowOffset: 3,
                              onPressed: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: BrutalColors.ink,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const BrutalTag(
                              text: 'Estatísticas',
                              color: BrutalColors.yellow,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        if (_learningService.totalGames == 0)
                          BrutalBox(
                            padding: const EdgeInsets.all(24),
                            child: const Text(
                              'Nenhuma partida registrada ainda.\n'
                              'Jogue e confirme os resultados para eu '
                              'começar a aprender!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: BrutalColors.ink,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            ),
                          )
                        else ...[
                          Row(
                            children: [
                              _bigNumber(
                                'Jogos',
                                '${_learningService.totalGames}',
                                BrutalColors.white,
                              ),
                              const SizedBox(width: 12),
                              _bigNumber(
                                'Acertos',
                                '${_learningService.totalCorrect}',
                                BrutalColors.green,
                              ),
                              const SizedBox(width: 12),
                              _bigNumber(
                                'Taxa',
                                '${((_learningService.accuracy ?? 0) * 100).round()}%',
                                BrutalColors.yellow,
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          if (_learningService
                              .hardestProfessors
                              .isNotEmpty) ...[
                            _sectionTitle('Professores mais difíceis'),
                            BrutalBox(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  for (final entry
                                      in _learningService.hardestProfessors
                                          .take(5))
                                    ListTile(
                                      dense: true,
                                      leading: ProfessorAvatar(
                                        name: entry.key,
                                        radius: 18,
                                      ),
                                      title: Text(
                                        entry.key,
                                        style: const TextStyle(
                                          color: BrutalColors.ink,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      trailing: BrutalTag(
                                        text:
                                            '${entry.value} '
                                            '${entry.value == 1 ? "erro" : "erros"}',
                                        color: BrutalColors.red,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],
                          if (_learningService.topConfusions.isNotEmpty) ...[
                            _sectionTitle('Pares mais confundidos'),
                            BrutalBox(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (final pair
                                      in _learningService.topConfusions.take(5))
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${pair.$1}  ×  ${pair.$2}',
                                              style: const TextStyle(
                                                color: BrutalColors.ink,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          BrutalTag(
                                            text: '${pair.$3}x',
                                            color: BrutalColors.orange,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],
                          BrutalButton(
                            color: BrutalColors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            onPressed: _confirmClear,
                            child: const Center(
                              child: Text(
                                '🗑 APAGAR APRENDIZADO',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: BrutalColors.ink,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
