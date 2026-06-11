/// Um professor da base de conhecimento.
///
/// Cada atributo guarda a probabilidade (0.0 a 1.0) de a resposta correta
/// para a pergunta correspondente ser "sim":
///   * 1.0  -> o professor tem a característica
///   * 0.0  -> o professor não tem a característica
///   * 0.5  -> desconhecido (a pergunta não diferencia este professor)
///   * valores intermediários -> incerteza parcial (ex.: 0.3)
class Professor {
  final String name;
  final Map<String, double> attributes;

  const Professor({required this.name, required this.attributes});

  /// Probabilidade de "sim" para o atributo. Atributos ausentes são
  /// tratados como desconhecidos (0.5).
  double probabilityFor(String attributeId) => attributes[attributeId] ?? 0.5;
}
