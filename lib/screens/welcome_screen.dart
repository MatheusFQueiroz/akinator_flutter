import 'package:flutter/material.dart';
import '../data/knowledge_base.dart';
import '../theme/brutal.dart';
import '../widgets/akinator_character.dart';
import '../widgets/professor_avatar.dart';
import 'question_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrutalColors.bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BrutalTag(
                        text: 'ADS • Biopark',
                        color: BrutalColors.yellow,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Center(child: AkinatorCharacter(size: 150)),
                  const SizedBox(height: 28),
                  BrutalBox(
                    color: BrutalColors.purple,
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'QUEM É O\nPROFESSOR?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: BrutalColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BrutalBox(
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'Pense em um professor do curso de ADS do Biopark. '
                      'Eu vou fazer perguntas até descobrir quem é — '
                      'igual ao Akinator!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: BrutalColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'PROFESSORES DISPONÍVEIS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: BrutalColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 108,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: allProfessors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final name = allProfessors[index];
                        return Column(
                          children: [
                            ProfessorAvatar(name: name, radius: 30),
                            const SizedBox(height: 6),
                            Text(
                              name,
                              style: const TextStyle(
                                color: BrutalColors.ink,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  BrutalButton(
                    color: BrutalColors.yellow,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shadowOffset: 6,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuestionScreen(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'COMEÇAR →',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          color: BrutalColors.ink,
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
