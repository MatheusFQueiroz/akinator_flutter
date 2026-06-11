# Akinator dos Professores — ADS Biopark

Jogo estilo Akinator em Flutter: pense em um professor do curso de ADS e o
app tenta adivinhar quem é fazendo perguntas.

## Como funciona a adivinhação

O motor de adivinhação (`lib/services/game_engine.dart`) usa **inferência
Bayesiana** com **seleção dinâmica de perguntas**:

1. Cada professor começa com a mesma probabilidade (ajustada levemente pelo
   histórico de partidas anteriores, via `LearningService`).
2. A cada resposta, a probabilidade de cada professor é multiplicada pela
   verossimilhança da resposta (regra de Bayes) e renormalizada.
3. A próxima pergunta **não segue ordem fixa**: o motor escolhe a pergunta
   com maior ganho de informação esperado (maior redução de entropia).
4. A partida termina cedo quando a confiança no melhor palpite atinge 85%
   (após no mínimo 5 perguntas), quando não há mais perguntas informativas
   ou ao atingir 15 perguntas.

## Estrutura

```
lib/
├── data/
│   └── knowledge_base.dart   # Professores, atributos e perguntas
├── models/
│   ├── answer.dart           # Respostas possíveis do jogador
│   ├── game_data.dart        # Histórico de partidas (aprendizado)
│   ├── professor.dart        # Professor + mapa de atributos
│   └── question.dart         # Pergunta -> atributo
├── services/
│   ├── game_engine.dart      # Motor Bayesiano (lógica do jogo)
│   └── learning_service.dart # Persistência do aprendizado
├── screens/                  # UI (welcome, question, result)
└── widgets/                  # Componentes visuais
```

## Como adicionar uma pergunta

Tudo fica em `lib/data/knowledge_base.dart`:

1. Crie um identificador novo na classe `Attr`.
2. Adicione a `Question` na lista `questions`, apontando para o atributo.
3. Preencha o valor do atributo para cada professor na lista `professors`:
   `1.0` = sim, `0.0` = não, valores intermediários = incerteza
   (ex.: `0.3` para "provavelmente não").

Atributos não preenchidos valem `0.5` (desconhecido). Uma pergunta cujo
atributo é desconhecido para todos os professores nunca é feita — ela passa
a entrar no jogo automaticamente assim que os valores forem preenchidos.

> As perguntas 19, 20 e 21 ("dá aulas de programação", "mais de 40 anos" e
> "deu aula no 2º semestre") estão com valores desconhecidos e precisam ser
> preenchidas com os dados reais.

## Rodando

```bash
flutter pub get
flutter run
flutter test   # testes do motor e smoke test da UI
```
