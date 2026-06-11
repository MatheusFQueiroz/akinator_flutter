import '../models/professor.dart';
import '../models/question.dart';

/// Identificadores dos atributos usados pelas perguntas.
class Attr {
  Attr._();

  static const usaOculos = 'usaOculos';
  static const temBarba = 'temBarba';
  static const generoFeminino = 'generoFeminino';
  static const temTatuagem = 'temTatuagem';
  static const vaiDeCarro = 'vaiDeCarro';
  static const aulaSemestre1 = 'aulaSemestre1';
  static const parouDeDarAula = 'parouDeDarAula';
  static const formadoNoBiopark = 'formadoNoBiopark';
  static const moraEmToledo = 'moraEmToledo';
  static const olhosClaros = 'olhosClaros';
  static const aulaProjetoIntegrador = 'aulaProjetoIntegrador';
  static const cabeloCurto = 'cabeloCurto';
  static const usouLaboratorio = 'usouLaboratorio';
  static const passaAtividades = 'passaAtividades';
  static const aulaSemestre3 = 'aulaSemestre3';
  static const aulaSemestre5 = 'aulaSemestre5';

  // Novos atributos.
  static const nomeComecaComJ = 'nomeComecaComJ';
  static const nomeComecaComVogal = 'nomeComecaComVogal';
  static const aulaProgramacao = 'aulaProgramacao';
  static const maisDe40Anos = 'maisDe40Anos';
  static const aulaSemestre2 = 'aulaSemestre2';
}

/// Perguntas disponíveis. A ordem aqui NÃO é a ordem do jogo: o motor
/// (GameEngine) escolhe dinamicamente a pergunta mais informativa.
const List<Question> questions = [
  Question(id: 1, text: 'O professor usa óculos?', attributeId: Attr.usaOculos),
  Question(id: 2, text: 'O professor tem barba?', attributeId: Attr.temBarba),
  Question(
    id: 3,
    text: 'O professor é do gênero feminino?',
    attributeId: Attr.generoFeminino,
  ),
  Question(
    id: 4,
    text: 'O professor possui tatuagem?',
    attributeId: Attr.temTatuagem,
  ),
  Question(
    id: 5,
    text: 'O professor utiliza carro para ir à faculdade?',
    attributeId: Attr.vaiDeCarro,
  ),
  Question(
    id: 6,
    text: 'O professor deu aula no 1º semestre?',
    attributeId: Attr.aulaSemestre1,
  ),
  Question(
    id: 7,
    text: 'O professor parou de dar aulas na faculdade?',
    attributeId: Attr.parouDeDarAula,
  ),
  Question(
    id: 8,
    text: 'O professor se formou no Biopark?',
    attributeId: Attr.formadoNoBiopark,
  ),
  Question(
    id: 9,
    text: 'O professor reside em Toledo?',
    attributeId: Attr.moraEmToledo,
  ),
  Question(
    id: 10,
    text: 'O professor possui olhos claros?',
    attributeId: Attr.olhosClaros,
  ),
  Question(
    id: 11,
    text: 'O professor já deu aula de Projeto Integrador em ADS?',
    attributeId: Attr.aulaProjetoIntegrador,
  ),
  Question(
    id: 12,
    text: 'O professor tem cabelo curto?',
    attributeId: Attr.cabeloCurto,
  ),
  Question(
    id: 13,
    text: 'O professor já utilizou o laboratório para dar aula?',
    attributeId: Attr.usouLaboratorio,
  ),
  Question(
    id: 14,
    text: 'O professor costuma passar atividades em toda aula?',
    attributeId: Attr.passaAtividades,
  ),
  Question(
    id: 15,
    text: 'O professor deu aula no 3º semestre?',
    attributeId: Attr.aulaSemestre3,
  ),
  Question(
    id: 16,
    text: 'O professor deu aula no 5º semestre?',
    attributeId: Attr.aulaSemestre5,
  ),

  // ---- Novas perguntas ----
  Question(
    id: 17,
    text: 'O nome do professor começa com a letra J?',
    attributeId: Attr.nomeComecaComJ,
  ),
  Question(
    id: 18,
    text: 'O nome do professor começa com vogal?',
    attributeId: Attr.nomeComecaComVogal,
  ),
  Question(
    id: 19,
    text: 'O professor dá aulas de programação?',
    attributeId: Attr.aulaProgramacao,
  ),
  Question(
    id: 20,
    text: 'O professor tem mais de 40 anos?',
    attributeId: Attr.maisDe40Anos,
  ),
  Question(
    id: 21,
    text: 'O professor deu aula no 2º semestre?',
    attributeId: Attr.aulaSemestre2,
  ),
];

/// Base de conhecimento: cada professor com a probabilidade de "sim" para
/// cada atributo (1.0 = sim, 0.0 = não, 0.5 ou ausente = desconhecido).
///
/// Para ADICIONAR UMA PERGUNTA NOVA:
///   1. Crie um id em [Attr] e a [Question] correspondente acima.
///   2. Preencha o atributo para cada professor abaixo. Atributos não
///      preenchidos valem 0.5 (desconhecido) e a pergunta só passa a ser
///      feita quando diferenciar pelo menos um professor.
///
/// TODO: preencher os valores reais de `aulaProgramacao`, `maisDe40Anos` e
/// `aulaSemestre2` para cada professor (hoje estão como desconhecidos).
const List<Professor> professors = [
  Professor(
    name: 'Fabiane',
    attributes: {
      Attr.usaOculos: 1.0,
      Attr.temBarba: 0.0,
      Attr.generoFeminino: 1.0,
      Attr.temTatuagem: 1.0,
      Attr.vaiDeCarro: 0.0,
      Attr.aulaSemestre1: 1.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 0.0,
      Attr.moraEmToledo: 0.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 0.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 1.0,
      Attr.aulaSemestre3: 0.0,
      Attr.aulaSemestre5: 0.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Jefferson Speck',
    attributes: {
      Attr.usaOculos: 1.0,
      Attr.temBarba: 1.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 1.0,
      Attr.vaiDeCarro: 0.0,
      Attr.aulaSemestre1: 0.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 0.0,
      Attr.moraEmToledo: 0.0,
      Attr.olhosClaros: 1.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 1.0,
      Attr.aulaSemestre3: 0.0,
      Attr.aulaSemestre5: 1.0,
      Attr.nomeComecaComJ: 1.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Jhoni',
    attributes: {
      Attr.usaOculos: 0.0,
      Attr.temBarba: 1.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 0.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 0.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 0.0,
      Attr.moraEmToledo: 0.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 1.0,
      Attr.aulaSemestre3: 1.0,
      Attr.aulaSemestre5: 0.0,
      Attr.nomeComecaComJ: 1.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Willian',
    attributes: {
      Attr.usaOculos: 1.0,
      Attr.temBarba: 1.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 1.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 1.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 0.0,
      Attr.moraEmToledo: 0.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 1.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 1.0,
      Attr.aulaSemestre3: 1.0,
      Attr.aulaSemestre5: 0.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Guilherme Alves',
    attributes: {
      Attr.usaOculos: 0.0,
      Attr.temBarba: 0.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 1.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 1.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 0.0,
      Attr.moraEmToledo: 1.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 1.0,
      Attr.aulaSemestre3: 0.0,
      Attr.aulaSemestre5: 1.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Marcos Guido',
    attributes: {
      Attr.usaOculos: 0.0,
      Attr.temBarba: 0.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 0.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 0.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 0.0,
      Attr.moraEmToledo: 0.0,
      Attr.olhosClaros: 1.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 1.0,
      Attr.passaAtividades: 1.0,
      Attr.aulaSemestre3: 0.0,
      Attr.aulaSemestre5: 1.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Letícia',
    attributes: {
      Attr.usaOculos: 1.0,
      Attr.temBarba: 0.0,
      Attr.generoFeminino: 1.0,
      Attr.temTatuagem: 1.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 0.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 0.0,
      Attr.moraEmToledo: 1.0,
      Attr.olhosClaros: 1.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 1.0,
      Attr.aulaSemestre3: 1.0,
      Attr.aulaSemestre5: 0.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Jeferson Vorpagel',
    attributes: {
      Attr.usaOculos: 0.0,
      Attr.temBarba: 1.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 1.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 0.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 1.0,
      Attr.moraEmToledo: 1.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 0.0,
      Attr.aulaSemestre3: 0.0,
      Attr.aulaSemestre5: 1.0,
      Attr.nomeComecaComJ: 1.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'André Dorr',
    attributes: {
      Attr.usaOculos: 1.0,
      Attr.temBarba: 1.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 0.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 0.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 1.0,
      Attr.moraEmToledo: 1.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 1.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 0.0,
      Attr.aulaSemestre3: 1.0,
      Attr.aulaSemestre5: 1.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 1.0,
    },
  ),
  Professor(
    name: 'Renato',
    attributes: {
      Attr.usaOculos: 0.0,
      Attr.temBarba: 0.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 1.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 0.0,
      Attr.parouDeDarAula: 1.0,
      // No banco antigo, Renato aparecia como "provavelmente sim" para
      // formado no Biopark — incerteza parcial mantida.
      Attr.formadoNoBiopark: 0.3,
      Attr.moraEmToledo: 1.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 1.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 0.0,
      Attr.aulaSemestre3: 1.0,
      Attr.aulaSemestre5: 0.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Marcel',
    attributes: {
      Attr.usaOculos: 0.0,
      Attr.temBarba: 1.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 1.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 0.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 0.0,
      Attr.moraEmToledo: 0.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 1.0,
      Attr.aulaSemestre3: 0.0,
      Attr.aulaSemestre5: 0.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Hiago',
    attributes: {
      Attr.usaOculos: 0.0,
      Attr.temBarba: 1.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 0.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 1.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 0.3,
      Attr.moraEmToledo: 0.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 0.0,
      Attr.aulaSemestre3: 0.0,
      Attr.aulaSemestre5: 0.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Vander',
    attributes: {
      Attr.usaOculos: 1.0,
      Attr.temBarba: 0.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 0.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 1.0,
      Attr.parouDeDarAula: 0.0,
      Attr.formadoNoBiopark: 0.0,
      Attr.moraEmToledo: 0.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 1.0,
      Attr.passaAtividades: 0.0,
      Attr.aulaSemestre3: 0.0,
      Attr.aulaSemestre5: 0.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
  Professor(
    name: 'Alan',
    attributes: {
      Attr.usaOculos: 1.0,
      Attr.temBarba: 0.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 0.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 1.0,
      Attr.parouDeDarAula: 1.0,
      Attr.formadoNoBiopark: 0.3,
      Attr.moraEmToledo: 1.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 0.0,
      Attr.aulaSemestre3: 0.0,
      Attr.aulaSemestre5: 0.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 1.0,
    },
  ),
  Professor(
    name: 'Fabiano',
    attributes: {
      Attr.usaOculos: 1.0,
      Attr.temBarba: 1.0,
      Attr.generoFeminino: 0.0,
      Attr.temTatuagem: 1.0,
      Attr.vaiDeCarro: 1.0,
      Attr.aulaSemestre1: 0.0,
      Attr.parouDeDarAula: 1.0,
      Attr.formadoNoBiopark: 0.0,
      Attr.moraEmToledo: 0.0,
      Attr.olhosClaros: 0.0,
      Attr.aulaProjetoIntegrador: 0.0,
      Attr.cabeloCurto: 1.0,
      Attr.usouLaboratorio: 0.0,
      Attr.passaAtividades: 0.0,
      Attr.aulaSemestre3: 0.0,
      Attr.aulaSemestre5: 0.0,
      Attr.nomeComecaComJ: 0.0,
      Attr.nomeComecaComVogal: 0.0,
    },
  ),
];

/// Nomes de todos os professores (usado pelas telas).
final List<String> allProfessors = professors
    .map((p) => p.name)
    .toList(growable: false);
