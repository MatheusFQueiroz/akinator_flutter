import 'question.dart';

/// Respostas possíveis do jogador para uma pergunta.
enum Answer {
  sim('sim', 'Sim'),
  provavelmenteSim('provavelmente sim', 'Provavelmente sim'),
  naoSei('não sei', 'Não sei'),
  provavelmenteNao('provavelmente não', 'Provavelmente não'),
  nao('não', 'Não');

  const Answer(this.key, this.label);

  /// Chave usada na persistência (compatível com o histórico antigo).
  final String key;

  /// Texto exibido no botão.
  final String label;
}

/// Uma pergunta já respondida pelo jogador durante a partida.
class AnsweredQuestion {
  final Question question;
  final Answer answer;

  const AnsweredQuestion({required this.question, required this.answer});
}
