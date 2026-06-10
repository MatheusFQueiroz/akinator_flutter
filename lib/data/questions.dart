class Question {
  final int id;
  final String question;
  final Map<String, List<String>> answers;

  const Question({
    required this.id,
    required this.question,
    required this.answers,
  });
}

const List<Question> questions = [
  Question(
    id: 1,
    question: "O professor usa óculos?",
    answers: {
      "sim": ["Fabiane", "Jefferson Speck", "Willian", "Letícia", "André Dorr", "Fabiano", "Vander", "Alan"],
      "não": ["Jhoni", "Guilherme Alves", "Marcos Guido", "Jeferson Vorpagel", "Renato", "Marcel", "Hiago"],
      "provavelmente sim": ["Fabiane", "Jefferson Speck", "Willian", "Letícia", "André Dorr", "Fabiano", "Vander", "Alan"],
      "provavelmente não": ["Jhoni", "Guilherme Alves", "Marcos Guido", "Jeferson Vorpagel", "Renato", "Marcel", "Hiago"],
    },
  ),
  Question(
    id: 2,
    question: "O professor tem barba?",
    answers: {
      "sim": ["Jefferson Speck", "Jhoni", "Willian", "Jeferson Vorpagel", "André Dorr", "Marcel", "Hiago", "Fabiano"],
      "não": ["Fabiane", "Guilherme Alves", "Marcos Guido", "Letícia", "Renato", "Vander", "Alan"],
      "provavelmente sim": ["Jefferson Speck", "Jhoni", "Willian", "Jeferson Vorpagel", "André Dorr", "Marcel", "Hiago", "Fabiano"],
      "provavelmente não": ["Fabiane", "Guilherme Alves", "Marcos Guido", "Letícia", "Renato", "Vander", "Alan"],
    },
  ),
  Question(
    id: 3,
    question: "O professor é do gênero feminino?",
    answers: {
      "sim": ["Fabiane", "Letícia"],
      "não": ["Jefferson Speck", "Jhoni", "Willian", "Guilherme Alves", "Marcos Guido", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
      "provavelmente sim": ["Fabiane", "Letícia"],
      "provavelmente não": ["Jefferson Speck", "Jhoni", "Willian", "Guilherme Alves", "Marcos Guido", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
    },
  ),
  Question(
    id: 4,
    question: "O professor possui tatuagem?",
    answers: {
      "sim": ["Fabiane", "Jefferson Speck", "Willian", "Guilherme Alves", "Letícia", "Fabiano", "Marcel", "Jeferson Vorpagel", "Renato"],
      "não": ["Jhoni", "Marcos Guido", "André Dorr", "Hiago", "Vander", "Alan"],
      "provavelmente sim": ["Fabiane", "Jefferson Speck", "Willian", "Guilherme Alves", "Letícia", "Fabiano", "Marcel", "Jeferson Vorpagel", "Renato"],
      "provavelmente não": ["Jhoni", "Marcos Guido", "André Dorr", "Hiago", "Vander", "Alan"],
    },
  ),
  Question(
    id: 5,
    question: "O professor utiliza carro para ir à faculdade?",
    answers: {
      "sim": ["Jhoni", "Willian", "Guilherme Alves", "Marcos Guido", "Letícia", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
      "não": ["Fabiane", "Jefferson Speck"],
      "provavelmente sim": ["Jhoni", "Willian", "Guilherme Alves", "Marcos Guido", "Letícia", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
      "provavelmente não": ["Fabiane", "Jefferson Speck"],
    },
  ),
  Question(
    id: 6,
    question: "O professor deu aula no 1º semestre?",
    answers: {
      "sim": ["Guilherme Alves", "Fabiane", "Alan", "Hiago", "Vander", "Willian"],
      "não": ["Jefferson Speck", "Jhoni", "Marcos Guido", "Letícia", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Fabiano"],
      "provavelmente sim": ["Guilherme Alves", "Fabiane", "Alan", "Hiago", "Vander", "Willian"],
      "provavelmente não": ["Jefferson Speck", "Jhoni", "Marcos Guido", "Letícia", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Fabiano"],
    },
  ),
  Question(
    id: 7,
    question: "O professor parou de dar aulas na faculdade?",
    answers: {
      "sim": ["Renato", "Alan", "Fabiano"],
      "não": ["Fabiane", "Jefferson Speck", "Jhoni", "Willian", "Guilherme Alves", "Marcos Guido", "Letícia", "Jeferson Vorpagel", "André Dorr", "Marcel", "Hiago", "Vander"],
      "provavelmente sim": ["Renato", "Alan", "Fabiano"],
      "provavelmente não": ["Fabiane", "Jefferson Speck", "Jhoni", "Willian", "Guilherme Alves", "Marcos Guido", "Letícia", "Jeferson Vorpagel", "André Dorr", "Marcel", "Hiago", "Vander"],
    },
  ),
  Question(
    id: 8,
    question: "O professor se formou no Biopark?",
    answers: {
      "sim": ["André Dorr", "Jeferson Vorpagel"],
      "não": ["Fabiane", "Jefferson Speck", "Jhoni", "Willian", "Guilherme Alves", "Marcos Guido", "Letícia", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
      "provavelmente sim": ["André Dorr", "Jeferson Vorpagel", "Renato", "Hiago", "Alan"],
      "provavelmente não": ["Fabiane", "Jefferson Speck", "Jhoni", "Willian", "Guilherme Alves", "Marcos Guido", "Letícia", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
    },
  ),
  Question(
    id: 9,
    question: "O professor reside em Toledo?",
    answers: {
      "sim": ["Guilherme Alves", "Letícia", "Jeferson Vorpagel", "André Dorr", "Renato", "Alan"],
      "não": ["Fabiane", "Jefferson Speck", "Jhoni", "Willian", "Marcos Guido", "Marcel", "Hiago", "Fabiano", "Vander"],
      "provavelmente sim": ["Guilherme Alves", "Letícia", "Jeferson Vorpagel", "André Dorr", "Renato", "Alan"],
      "provavelmente não": ["Fabiane", "Jefferson Speck", "Jhoni", "Willian", "Marcos Guido", "Marcel", "Hiago", "Fabiano", "Vander"],
    },
  ),
  Question(
    id: 10,
    question: "O professor possui olhos claros?",
    answers: {
      "sim": ["Jefferson Speck", "Marcos Guido", "Letícia"],
      "não": ["Fabiane", "Jhoni", "Willian", "Guilherme Alves", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
      "provavelmente sim": ["Jefferson Speck", "Marcos Guido", "Letícia"],
      "provavelmente não": ["Fabiane", "Jhoni", "Willian", "Guilherme Alves", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
    },
  ),
  Question(
    id: 11,
    question: "O professor já deu aula de Projeto Integrador em ADS?",
    answers: {
      "sim": ["Willian", "Renato", "André Dorr"],
      "não": ["Fabiane", "Jefferson Speck", "Jhoni", "Guilherme Alves", "Marcos Guido", "Letícia", "Jeferson Vorpagel", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
      "provavelmente sim": ["Willian", "Renato", "André Dorr"],
      "provavelmente não": ["Fabiane", "Jefferson Speck", "Jhoni", "Guilherme Alves", "Marcos Guido", "Letícia", "Jeferson Vorpagel", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
    },
  ),
  Question(
    id: 12,
    question: "O professor tem cabelo curto?",
    answers: {
      "sim": ["Jefferson Speck", "Jhoni", "Willian", "Guilherme Alves", "Marcos Guido", "Letícia", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
      "não": ["Fabiane"],
      "provavelmente sim": ["Jefferson Speck", "Jhoni", "Willian", "Guilherme Alves", "Marcos Guido", "Letícia", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
      "provavelmente não": ["Fabiane"],
    },
  ),
  Question(
    id: 13,
    question: "O professor já utilizou o laboratório para dar aula?",
    answers: {
      "sim": ["Vander", "Marcos Guido"],
      "não": ["Fabiane", "Jefferson Speck", "Jhoni", "Willian", "Guilherme Alves", "Letícia", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Hiago", "Alan", "Fabiano"],
      "provavelmente sim": ["Vander", "Marcos Guido"],
      "provavelmente não": ["Fabiane", "Jefferson Speck", "Jhoni", "Willian", "Guilherme Alves", "Letícia", "Jeferson Vorpagel", "André Dorr", "Renato", "Marcel", "Hiago", "Alan", "Fabiano"],
    },
  ),
  Question(
    id: 14,
    question: "O professor costuma passar atividades em toda aula?",
    answers: {
      "sim": ["Fabiane", "Jefferson Speck", "Willian", "Guilherme Alves", "Marcos Guido", "Letícia", "Marcel", "Jhoni"],
      "não": ["Jeferson Vorpagel", "André Dorr", "Renato", "Hiago", "Vander", "Alan", "Fabiano"],
      "provavelmente sim": ["Fabiane", "Jefferson Speck", "Willian", "Guilherme Alves", "Marcos Guido", "Letícia", "Marcel", "Jhoni"],
      "provavelmente não": ["Jeferson Vorpagel", "André Dorr", "Renato", "Hiago", "Vander", "Alan", "Fabiano"],
    },
  ),
  Question(
    id: 15,
    question: "O professor deu aula no 3º semestre?",
    answers: {
      "sim": ["Jhoni", "Letícia", "Willian", "Renato", "André Dorr"],
      "não": ["Fabiane", "Guilherme Alves", "Marcos Guido", "Jeferson Vorpagel", "Marcel", "Hiago", "Vander", "Alan", "Fabiano", "Jefferson Speck"],
      "provavelmente sim": ["Jhoni", "Letícia", "Willian", "Renato", "André Dorr"],
      "provavelmente não": ["Fabiane", "Guilherme Alves", "Marcos Guido", "Jeferson Vorpagel", "Marcel", "Hiago", "Vander", "Alan", "Fabiano", "Jefferson Speck"],
    },
  ),
  Question(
    id: 16,
    question: "O professor deu aula no 5º semestre?",
    answers: {
      "sim": ["Guilherme Alves", "Jefferson Speck", "Marcos Guido", "André Dorr", "Jeferson Vorpagel"],
      "não": ["Fabiane", "Jhoni", "Willian", "Letícia", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
      "provavelmente sim": ["Guilherme Alves", "Jefferson Speck", "Marcos Guido", "André Dorr", "Jeferson Vorpagel"],
      "provavelmente não": ["Fabiane", "Jhoni", "Willian", "Letícia", "Renato", "Marcel", "Hiago", "Vander", "Alan", "Fabiano"],
    },
  ),
];

const List<String> allProfessors = [
  "Fabiane",
  "Jefferson Speck",
  "Jhoni",
  "Willian",
  "Guilherme Alves",
  "Marcos Guido",
  "Letícia",
  "Jeferson Vorpagel",
  "André Dorr",
  "Renato",
  "Marcel",
  "Hiago",
  "Vander",
  "Alan",
  "Fabiano",
];
