import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:akinator_mobile/data/knowledge_base.dart';
import 'package:akinator_mobile/services/learning_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<LearningService> newService() async {
    final service = LearningService();
    await service.load();
    return service;
  }

  test('ajusta atributos gradualmente com a evidência dos jogadores', () async {
    final service = await newService();

    // Três partidas em que era a Fabiane e os jogadores responderam "não"
    // para óculos (a base diz 1.0).
    for (var i = 0; i < 3; i++) {
      await service.saveGameResult(
        answers: [
          {
            'question': 'O professor usa óculos?',
            'answer': 'não',
            'attributeId': Attr.usaOculos,
          },
        ],
        predicted: 'Fabiane',
        actual: 'Fabiane',
      );
    }

    final adjusted = service.adjustProfessors(professors);
    final fabiane = adjusted.firstWhere((p) => p.name == 'Fabiane');

    // (1.0 * 5 + 0) / (5 + 3) = 0.625: caiu, mas sem virar 0 de uma vez.
    expect(fabiane.probabilityFor(Attr.usaOculos), closeTo(0.625, 1e-9));
    // Atributos sem evidência não mudam.
    expect(fabiane.probabilityFor(Attr.temBarba), 0.0);
  });

  test('evidência persiste entre sessões', () async {
    final service = await newService();
    await service.saveGameResult(
      answers: [
        {
          'question': 'O professor usa óculos?',
          'answer': 'não',
          'attributeId': Attr.usaOculos,
        },
      ],
      predicted: 'Fabiane',
      actual: 'Fabiane',
    );

    final reloaded = await newService();
    final fabiane = reloaded
        .adjustProfessors(professors)
        .firstWhere((p) => p.name == 'Fabiane');
    expect(fabiane.probabilityFor(Attr.usaOculos), lessThan(1.0));
  });

  test('estatísticas: acerto, mais difíceis e pares confundidos', () async {
    final service = await newService();

    await service.saveGameResult(
      answers: [],
      predicted: 'Fabiane',
      actual: 'Fabiane',
    );
    await service.saveGameResult(
      answers: [],
      predicted: 'Marcel',
      actual: 'Hiago',
    );
    await service.saveGameResult(
      answers: [],
      predicted: 'Marcel',
      actual: 'Hiago',
    );

    expect(service.totalGames, 3);
    expect(service.totalCorrect, 1);
    expect(service.accuracy, closeTo(1 / 3, 1e-9));

    expect(service.hardestProfessors.first.key, 'Hiago');
    expect(service.hardestProfessors.first.value, 2);

    final topPair = service.topConfusions.first;
    expect({topPair.$1, topPair.$2}, {'Marcel', 'Hiago'});
    expect(topPair.$3, 2);

    expect(service.getPriorWeight('Hiago'), greaterThan(1.0));
    expect(service.getPriorWeight('Fabiane'), 1.0);
  });
}
