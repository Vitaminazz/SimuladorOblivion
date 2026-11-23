# Proposta inicial — cálculo de rank de poderes

**Estado: proposta da equipe para discussão. Não é regra aprovada.** Coeficientes, medições e faixas devem ser ajustados com exemplos antes de virarem requisito.

## 1. Princípios de modelagem
- Cada poder escolhe um status-base, que comunica sua fonte e orienta o tipo de manifestação. O status, por si só, não dá pontos automáticos nesta proposta; a potência observável é pontuada separadamente para evitar contar a mesma coisa duas vezes.
- Os medidores avaliam o que o poder faz. Cada dimensão recebe nota de 0 a 5 em relação a referências do status e do universo.
- Pesos diferentes traduzem importância relativa. A equipe deve permitir que o usuário entenda por que um poder recebeu determinado rank.
- Efeitos especiais, como Dano Real, podem alterar o score após os medidores. Dano Real é uma opção booleana: ligado ou desligado; não existe versão parcial ou intensidade menor.
- Rank narrativo e capacidade atual do motor de simulação são coisas distintas. O motor de testes começa limitado até SS; SSS/U podem existir na documentação/edição sem prometer simulação fiel nesta fase.

## 2. Score base proposto
Cada medidor vai de 0 a 5. A soma dos pesos é 100.

| Medidor | Peso inicial | O que considera |
|---|---:|---|
| Potência/impacto | 30% | Intensidade do resultado direto, avaliada com o status-base e suas referências de feitos. |
| Área e alvos afetados | 15% | Quantos alvos/quanto espaço o poder pode afetar. |
| Alcance | 10% | Distância máxima e capacidade de atuar ao longo do espaço. |
| Duração e persistência | 10% | Quanto tempo o efeito dura ou permanece influenciando a cena. |
| Precisão e controle | 10% | Capacidade de escolher alvo, direção, intensidade ou limitar efeitos colaterais. |
| Versatilidade/complexidade | 10% | Número e interação de efeitos, condições ou usos representados pelo mesmo poder. |
| Interação com defesas | 15% | Quanto ignora, atravessa ou contorna defesas, imunidades e resistências. Dano real recebe pontuação alta aqui, com as regras abaixo. |

**Fórmula base:**

`Base (0–100) = Σ [peso_i × (nota_i ÷ 5)]`

## 3. Modificadores propostos

`Score final = limitar(score ponderado pelos medidores, 0, 100)`

O usuário aprovou os medidores/pesos como boa base de trabalho. Não usar bônus aditivos ou multiplicadores arbitrários no score total por padrão. Quando **Dano Real** estiver ligado, atribuir a nota máxima (5/5) ao medidor ponderado de interação com defesas. Assim, a propriedade binária realça o rank via uma dimensão de peso relevante (15 pontos máximos em score 0–100), sem criar uma pilha de bônus que possa desbalancear o resultado. Quando estiver desligado, o medidor ainda pode representar interações defensivas não equivalentes a dano real, conforme regras futuras; isso não cria níveis parciais de Dano Real. Exibir também o selo “Dano Real” junto ao rank.

Não aplicar outro bônus `+2` ou `×1,5` além da contribuição do medidor de interação com defesas. O usuário informou que esses valores eram exemplos e autorizou a equipe a escolher uma abordagem mais equilibrada.

## 4. Faixas iniciais de rank (proposta)

| Score | Rank | Leitura inicial |
|---:|:---:|---|
| 0–9 | F | efeito pequeno ou muito restrito |
| 10–19 | D | baixo, mas claramente funcional |
| 20–29 | C | relevante em uma situação comum |
| 30–39 | B | forte, com impacto amplo ou consistente |
| 40–49 | A | muito forte no contexto regular |
| 50–64 | S | extraordinário, acima do padrão comum |
| 65–79 | SS | extremo; nível mais alto que a Sandbox deve testar inicialmente |
| 80–100 | SSS | feito mensurável extremo; fora do limite inicial de teste |
| além da escala mensurável | U | teto ficcional de poder existente; não derivado simplesmente de score 100 |

As faixas foram escolhidas apenas para iniciar a conversa. A Persona de Sistemas deverá criar casos de referência, comparar saltos entre letras e ajustar intervalos. O rank U é qualitativo/metanarrativo: a definição do usuário o coloca no teto ficcional, enquanto SSS permanece um feito extremo ainda mensurável.

## 5. Interpretação de Dano Real

**Entendimento registrado:** Dano Real é booleano. Quando ligado, o poder aplica o dano que produziria no destino, ignorando defesas contra esse dano. Não garante acerto inevitável: ataque ainda pode ser bloqueado, interceptado, evitado ou desviado. O dummy Indestrutível pode sofrer dano e outros efeitos, mas nunca é destruído.

Modelo candidato para representar a resolução:
1. Verificar se o ataque alcança o destino ou é bloqueado/desviado/evitado.
2. Se o efeito acertar um dummy Indestrutível, ele pode receber dano/efeitos, mas o estado de destruição é impedido.
3. Para outros alvos, dano real atravessa defesas que reduziriam, anulariam ou impediriam aquele dano.
4. Resolver e exibir o resultado no dummy.

Dano Real afeta o componente de dano, não transforma automaticamente cura, congelamento, queimadura ou outros efeitos em efeitos que ignoram suas proteções. Cada tipo de efeito pode exigir sua regra própria. O usuário confirmou o entendimento de Dano Real e do dummy Indestrutível. Permanecem por calibrar as fronteiras dos ranks e a apresentação visual detalhada.

## 6. Apresentação visual de resultados
O dummy Indestrutível pode reagir visualmente a dano e efeitos, mas não deve ter uma barra de dano acumulado obrigatória nem entrar em estado de destruição. A interface pode exibir números e DPS como representações visuais da potência/dano; na primeira versão, não precisam servir como métricas úteis ou como base de balanceamento. DPS é desejável “se possível”, sujeito à simplicidade da implementação.

## 7. Exemplo de calibração que a próxima etapa pode produzir
Para cada rank/status relevante, criar uma faixa descritiva de feitos: o que significa um impacto FOR C, um poder INT S, uma aura HAR B etc. Os exemplos fornecidos (FOR C quebrar parede; FOR SS desestabilizar átomos por golpes) são âncoras de conversa, não benchmarks matemáticos fechados.

## 8. Próximas verificações
- Calibrar as fronteiras dos ranks com os exemplos de [07_EXEMPLOS_DE_CALIBRACAO.md](07_EXEMPLOS_DE_CALIBRACAO.md).
- Rodar alguns exemplos lado a lado, sem implementar ainda: golpe físico, magia de área, defesa/aura e dano real.
- Usar os exemplos para avaliar se os 15 pontos de interação com defesas destacam Dano Real sem distorcer os demais perfis.
- Confirmado pelo usuário: dano real é binário; depois de acertar ignora defesas contra dano, mas pode ser bloqueado/desviado; dummy Indestrutível pode sofrer dano/efeitos, mas nunca é destruído.
- SSS/U podem ser criados e guardados; testes limitados a SS foram confirmados.






