# Visão do produto e requisitos

Simulador pessoal de criação livre de poderes e experimentação visual. Oblivion Flame é referência de ideias, status, raças, habilidades, ranks e ambientação, sem restringir as regras do simulador.

## Requisitos confirmados
| ID | Requisito | Estado |
|---|---|---|
| R-001 | Descoberta antecede decisões técnicas definitivas e programação. | Confirmado |
| R-002 | Sandbox é núcleo da experiência; customizador é prioridade inicial. | Confirmado |
| R-003 | Sandbox em visão superior sobre quadrícula, com jogador e dummies distinguíveis; visual pixelizado simples. | Confirmado em alto nível |
| R-004 | Dummies são estáticos e reativos; classes: Fraco, Normal, Elite e Indestrutível. | Confirmado em alto nível |
| R-005 | Poderes são compostos e não limitados a uma lista fechada. | Confirmado |
| R-006 | Mira por clique; clique-arraste pode definir direção/amplitude de cone ou área. | Direção confirmada; gestos específicos pendentes |
| R-007 | Presets de distância pretendidos: Queima-roupa, Média, Longa, Máxima, Fora de Alcance. | Confirmado como direção |
| R-008 | Animações simples mostram acerto, número de alvos e consequências reconhecíveis. | Confirmado como intenção |
| R-009 | Direção de interface escura, viva, com cores de destaque e clima de Oblivion Flame. | Confirmado como direção |
| R-010 | Um status-base por poder representa sua fonte/natureza e orienta sua manifestação. | Confirmado em princípio |
| R-011 | FOR pode inspirar manifestação física; INT/HAR podem inspirar magia lançada, entoada, emanada ou automática. | Exemplos de referência, não regras universais |
| R-012 | Escala de rank: F, D, C, B, A, S, SS, SSS, U. SSS é extremo mensurável; U é teto ficcional. | Confirmado; limites descritivos por calibrar |
| R-013 | Cada poder apresenta rank final derivado de medidores com pesos diferentes. | Base da fórmula ponderada aceita; faixas em calibração |
| R-014 | Dano Real é booleano (ligado/desligado), sem versões fracas ou intensidades parciais. | Confirmado |
| R-015 | Quando Dano Real ligado, o dano ignora defesas após o acerto; bloqueio, esquiva ou desvio pode impedir o acerto. | Confirmado |
| R-016 | A opção Dano Real deve aumentar bastante o rank; modificador exato ainda precisa de validação. | Confirmado em alto nível |
| R-017 | Habilidades SSS/U podem ser criadas e guardadas, embora os testes da Sandbox sejam limitados a SS inicialmente. | Confirmado |
| R-018 | Dummy Indestrutível pode receber dano e outros efeitos, mas nunca ser destruído. | Confirmado; apresentação visual pendente |
| R-019 | Implementar interações simples primeiro, documentando a complexidade final pretendida. | Confirmado |
| R-020 | Alertas contextualizados explicam limitações e permitem prosseguir quando apropriado. | Confirmado em alto nível |
| R-021 | O customizador deve ser fácil de entender visualmente; cada opção/modificador explica o que é, para que serve e o que altera. | Confirmado |
| R-022 | Cada atributo modificável aparece em um card identificável com descrição da função e mudanças que causa. | Confirmado; layout detalhado por definir |
| R-023 | Pré-visualizações modulares simples mostram tamanho, formato, aparência geral e efeitos adicionados. | Confirmado; módulos e arranjo por definir |

## Diretriz de leitura do customizador
A leitura visual não substitui explicações: cada card deve identificar o atributo/opção, explicar sua finalidade e indicar claramente o que muda no poder. Módulos de prévia devem resumir tamanho, forma, aparência geral e efeitos adicionados.

## Indicadores visuais
Números de poder/dano são representações visuais, não métricas obrigatórias de balanceamento. O DPS deve ser mostrado se for simples de incluir; não precisa ser mecanicamente útil na primeira versão.

## Fórmula ponderada em avaliação
Base aceita como estrutura de trabalho: potência/impacto 30%, área/alvos 15%, alcance 10%, duração 10%, precisão/controle 10%, versatilidade/complexidade 10%, interação com defesas 15%. A equipe ainda precisa validar limiares dos ranks e modificadores. Ver [06_PROPOSTA_DE_RANKING.md](06_PROPOSTA_DE_RANKING.md).

## Referência inicial dos status
O documento de Oblivion Flame descreve FOR como força/dano físico; HP como tolerância e vontade (não pontos de vida); CON como resistência corporal; INT como capacidade e complexidade mágica; HAR como mentalidade, sabedoria e vínculo espiritual; DES como percepção, reflexos e agilidade; VEL como velocidade de deslocamento. Essas definições são fontes de inspiração; a semântica final de cada status no simulador será refinada.

## Pendências
- Faixas matemáticas para ranks e validação dos medidores por exemplos.
- Faixas matemáticas para ranks e exemplos calibrados.
- Como mostrar dano/efeitos em dummy Indestrutível sem destruí-lo.
- Regras das imunidades, classes e presets de distância.
- Plataforma, persistência, desempenho e estética visual detalhada.





