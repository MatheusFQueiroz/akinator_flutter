# Arquitetura e Lógica do Motor de Inferência

## 1. Sistema de Aprendizado Heurístico (Feedback Local)

O sistema possui um mecanismo de adaptação contínua baseado nos erros relatados pelo jogador, desenhado para melhorar a experiência do usuário sem comprometer a integridade dos dados globais.

### Como funciona:

- **Armazenamento de Histórico:** Quando o jogo erra e o usuário seleciona o professor correto, o aplicativo salva o contexto da partida (palpite errado, resposta certa e as respostas fornecidas) no armazenamento local do dispositivo.
- **Ajuste de Prioridade (Viés Inicial):** Através do `LearningService.getPriorWeight()`, o sistema aplica um reforço inicial na probabilidade (+15% por erro, limitado a um teto de +75%) aos professores que eram a resposta correta em partidas perdidas.
- **Segurança e Imutabilidade da Base:** O aprendizado **não altera os critérios reais da base de dados** (ex: o atributo genérico "usa óculos: sim" permanece inalterado). Isso é uma escolha arquitetural proposital para evitar que jogadores respondam errado de zoeira e corrompam os dados globais. O sistema adapta-se apenas ao dispositivo local.

---

## 2. O Motor Probabilístico (Inferência Bayesiana)

O coração matemático do jogo é a **Inferência Bayesiana**, utilizada para atualizar a probabilidade de cada professor ser o escolhido à medida que novas evidências (respostas) chegam.

### Os Três Estágios da Atualização Bayesiana:

1. **Prior (Crença Inicial):** Antes da primeira pergunta, todos os professores possuem uma probabilidade basal uniforme (ex: se há 15 professores, a chance inicial é de `~6,7%` ou `1/15`). Esse valor pode sofrer o leve ajuste inicial do sistema de aprendizado mencionado acima.
2. **Verossimilhança (Peso da Evidência e Tolerância a Falhas):** Cada resposta do usuário atua como uma evidência que multiplica a probabilidade atual. O sistema é resiliente a falhas humanas pois os fatores **nunca são 0 ou 1**:
   - **Respostas Absolutas ("Sim" / "Não"):** Aplicam fatores de `0.9` (para concordância) e `0.1` (para discordância). Assim, uma resposta equivocada não elimina o alvo definitivamente, apenas diminui drasticamente sua probabilidade.
   - **Respostas Incertas ("Provavelmente Sim / Não"):** Aplicam fatores mais suaves, como `0.7` e `0.3`.
   - **Desconhecimento ("Não Sei"):** Aplica fator neutro (`1.0`), não alterando as probabilidades.
3. **Posterior (Crença Atualizada):** Após multiplicar a probabilidade pela verossimilhança, os valores de todos os professores são **renormalizados** para que a soma total retorne a 100%. Este valor é exibido ao jogador como a "Certeza" e se torna o novo _Prior_ para a próxima rodada.

A fórmula baseada no Teorema de Bayes pode ser simplificada neste contexto como:
$$P(\text{Professor} | \text{Resposta}) \propto P(\text{Resposta} | \text{Professor}) \times P(\text{Professor})$$

---

## 3. Seleção Dinâmica de Perguntas (Entropia e Teoria da Informação)

O jogo não segue um roteiro fixo de perguntas. A verdadeira "inteligência" (estilo Akinator) reside na escolha de _qual_ pergunta fazer em seguida para resolver o jogo no menor número de rodadas possível.

### Algoritmo de Seleção:

- **Cálculo de Entropia de Shannon:** A incerteza atual do jogo é medida através da entropia da distribuição de probabilidades. Quanto mais divididas as chances entre os professores, maior a entropia (caos/incerteza).
  $$H = - \sum_{i} P(x_i) \log_2 P(x_i)$$
- **Simulação e Ganho de Informação:** A cada rodada, o motor itera sobre **todas as perguntas ainda não feitas** e simula cenários probabilísticos: _"E se a resposta for Sim? E se for Não?"_. Ele calcula a entropia resultante para cada cenário.
- **Decisão:** A pergunta escolhida é aquela que apresenta a **maior redução média de incerteza** (Maior Ganho de Informação). O motor busca perguntas que dividam os candidatos mais viáveis praticamente ao meio.

### Condição de Parada (Gatilho de Resolução):

Devido à seleção otimizada de perguntas, o jogo não tem um limite fixo obrigatório de 16 rodadas. Assim que o processamento probabilístico faz com que o _Posterior_ de um único professor ultrapasse um **limiar de confiança predefinido de 85%**, o algoritmo interrompe as perguntas e realiza o palpite.
