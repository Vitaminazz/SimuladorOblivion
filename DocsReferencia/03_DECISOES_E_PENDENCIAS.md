# Decisões e pendências

## Decisões confirmadas
| ID | Decisão | Data | Fonte |
|---|---|---|---|
| D-001 | Descoberta e estruturação antecedem programação/tecnologia definitiva. | 2026-10-29 | Usuário/prompt mestre |
| D-002 | Seis personas simuladas; Gestor valida etapas. | 2026-10-29 | Prompt mestre |
| D-003 | Relatórios reaproveitáveis com Gemini. | 2026-10-29 | Usuário |
| D-004 | Oblivion Flame inspira ideias, status, raças, habilidades, ranks e atmosfera, sem impor regras do RPG. | 2026-10-29 | Usuário |
| D-005 | Customizador é prioridade; Sandbox final simples/pixelizada em visão superior. | 2026-10-29 | Usuário |
| D-006 | Dummies parados e reativos; categorias Fraco, Normal, Elite, Indestrutível. | 2026-10-29 | Usuário |
| D-007 | Um status-base por poder, que comunica fonte/natureza e orienta manifestação. | 2026-10-29 | Usuário |
| D-008 | Escala F, D, C, B, A, S, SS, SSS, U. U = teto ficcional; SSS = feito extremo mensurável. | 2026-10-29 | Usuário |
| D-009 | Testes da Sandbox limitados inicialmente até SS; poderes SSS/U podem ser criados e guardados. | 2026-10-29 | Usuário |
| D-010 | Rank deriva de medidores ponderados; sete dimensões/pesos são aceitos como base de trabalho. | 2026-10-29 | Usuário |
| D-011 | Dano Real é binário, ligado/desligado, sem versões parciais. | 2026-10-29 | Usuário |
| D-012 | Dano Real ignora defesas contra dano após acertar, mas bloqueio/desvio pode impedir o acerto. | 2026-10-29 | Usuário |
| D-013 | Dummy Indestrutível pode sofrer dano/efeitos, mas nunca é destruído. | 2026-10-29 | Usuário |
| D-014 | Números de poder/dano são representacionais; DPS é desejável se simples, sem exigir utilidade de balanceamento na primeira versão. | 2026-10-29 | Usuário |
| D-015 | Customizador deve explicar cada opção visualmente em cards: o que é, para que serve e o que altera. | 2026-10-29 | Usuário |
| D-016 | Pré-visualizações pequenas e modulares mostram tamanho, formato, aparência geral simplificada e efeitos adicionados. | 2026-10-29 | Usuário |
| D-017 | Godot 4 foi escolhida para o primeiro protótipo; Control nodes para interface, GDScript para regras/estado e desenho 2D nativo para Sandbox. | 2026-10-29 | Usuário |

| D-018 | A mira define o alvo/área; durante a simulação, a habilidade repete os impactos de acordo com um cooldown configurável. | 2026-10-29 | Usuário/revisão do protótipo |
| D-019 | Cooldown inicial é apresentado em segundos e ajustável de 0,25 s a 10 s; iniciar executa um disparo imediato e os seguintes respeitam o intervalo. | 2026-10-29 | Decisão provisória de implementação |

## Decisão tecnológica confirmada
Godot 4 foi escolhida para o protótipo. Opções comparadas e responsabilidades estão em [09_OPCOES_TECNOLOGICAS.md](09_OPCOES_TECNOLOGICAS.md).
A base ponderada aceita é: potência/impacto 30%, área/alvos 15%, alcance 10%, duração 10%, precisão/controle 10%, versatilidade/complexidade 10%, interação com defesas 15%.

Em vez de bônus adicionais ou multiplicadores arbitrários, quando **Dano Real** estiver ligado ele recebe a nota máxima no medidor ponderado de interação com defesas. Isso pode acrescentar até 15 pontos ao score antes do cálculo do rank e realçar o resultado sem empilhar modificadores. O selo “Dano Real” deve aparecer junto ao rank para comunicar a propriedade. Não há níveis intermediários dessa propriedade.

O desenho acima é a decisão de modelagem da equipe conforme autorização do usuário; os limiares do rank e o efeito final dos pesos ainda precisam de exemplos de calibração.

## Dano Real e Indestrutível
Dano Real é binário. Depois que o ataque acerta, ignora defesas contra dano; não torna o ataque inevitável, então bloqueio, interceptação, esquiva ou desvio podem impedir o dano. Dummy Indestrutível pode sofrer dano e efeitos, mas nunca entra em estado de destruição.

## Apresentação na primeira versão
Exibir reações visuais de impacto/efeito no dummy Indestrutível sem uma barra acumulativa obrigatória. Números de dano/poder são decorativos/representacionais, não métricas de balanceamento. Mostrar DPS é desejável se couber com simplicidade.

## Pendências
| ID | Pergunta | Estado |
|---|---|---|
| Q-011 | Faixas de score e limiares dos ranks | Proposta de medidores aceita; calibrar com exemplos |
| Q-012 | Mostrar DPS como indicador visual, se simples; não precisa ter precisão/uso de balanceamento. | Confirmado condicionalmente |
| Q-013 | Como mostrar dano/efeitos no dummy Indestrutível sem destruí-lo | Direção confirmada: reações visuais sem dano acumulado obrigatório |
| Q-014 | Como representar status-base em feitos/medidores sem dupla contagem | Aberta |
| Q-015 | Como calibrar exemplos F–SS e descrever SSS/U fora dos testes iniciais | Aberta |
| Q-016 | Cooldown representa intervalo entre disparos ou recuperação após a execução completa de habilidades com duração? | Aberta; protótipo usa intervalo entre disparos |
| Q-017 | Próxima prioridade: geometria específica por formato, configuração dos dummies/imunidades ou composição/elemento? | Aberta; sugestões registradas em 08_UX_E_PROXIMOS_PASSOS.md |
| Q-018 | Tempo de conjuração/duração devem ser campos separados do cooldown? | Aberta; recomendado separar |

Exemplos preliminares de calibração estão em [07_EXEMPLOS_DE_CALIBRACAO.md](07_EXEMPLOS_DE_CALIBRACAO.md). Valores de notas e limiares seguem como propostas a validar.

## Registro de alterações
2026-10-29 — Rodada 5: equipe escolhe representar Dano Real pelo medidor ponderado (nota máxima quando ligado), sem usar `+2 ×1,5`; DPS/números de dano serão visuais/representacionais na primeira versão; dummy Indestrutível reage sem destruição.
2026-10-29 — Rodada 6: adicionado ciclo de disparos na Sandbox, com mira persistente, iniciar/pausar, cooldown configurável e atualização visual por impacto. DPS/rank reagem à cadência no protótipo; as regras continuam ilustrativas.









