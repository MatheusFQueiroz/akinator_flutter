/// Uma pergunta do jogo. Em vez de guardar listas de professores por
/// resposta, cada pergunta aponta para um atributo da base de conhecimento
/// (ver `lib/data/knowledge_base.dart`).
class Question {
  final int id;
  final String text;

  /// Identificador do atributo que esta pergunta verifica nos professores.
  final String attributeId;

  const Question({
    required this.id,
    required this.text,
    required this.attributeId,
  });
}
