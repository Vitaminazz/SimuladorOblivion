# Entrevista de descoberta

## Síntese das rodadas anteriores
- Oblivion Flame inspira ideias, mas não restringe as regras.
- Customizador é prioridade; Sandbox em visão superior pixelizada com dummies estáticos e reativos.
- Um status-base por poder indica sua fonte e ajuda a orientar a manifestação.
- Ranks: F, D, C, B, A, S, SS, SSS, U. SSS é extremo mensurável; U é teto ficcional.
- Poderes SSS/U podem ser criados e guardados; testes da Sandbox limitados a SS.
- Base ponderada de medidores foi considerada boa: potência/impacto 30%, área 15%, alcance 10%, duração 10%, controle 10%, versatilidade 10%, interação com defesas 15%.
- Dano Real é booleano; ignora defesas após o acerto, mas bloqueio/desvio pode impedir o acerto.
- Dummy Indestrutível pode receber dano/efeitos, mas não pode ser destruído.

## Rodada 5 — apresentação e cálculo de Dano Real (respondida)
1. `+2` e `×1,5` eram exemplos; a equipe pode escolher uma solução melhor que destaque o rank sem desbalanceá-lo.
2. Prefere a segunda opção para Indestrutível: resposta visual aos golpes/efeitos, sem barra de dano acumulado; mostrar DPS se possível. Os números são representações visuais de poder e dano, não precisam ter utilidade mecânica na primeira versão.

## Decisão de modelagem do Gestor
Dano Real será um booleano e preencherá ao máximo o medidor ponderado de interação com defesas (15% do score), sem bônus fixo ou multiplicador adicional. Isso destaca a propriedade no rank, mas evita somar modificadores que possam superinflar scores. O rótulo “Dano Real” também aparece como selo junto ao rank. Essa é a forma escolhida pela equipe, autorizada pelo usuário.

Para o dummy Indestrutível, mostrar reação visual a dano e efeitos e nunca uma animação/estado de destruição. Não exigir barra acumulativa de dano. DPS pode ser mostrado como elemento representacional se for simples; os valores não são medidas de balanceamento obrigatórias nesta fase.

## Próxima etapa de descoberta
Elaborar exemplos lado a lado de habilidades com status-base diferentes e score ponderado; calibrar fronteiras dos ranks com esses exemplos e submeter ao usuário para validação. Sem implementar ainda.

## Próximos exemplos para validação
Três perfis ilustrativos e um comparativo de Dano Real ligado/desligado foram registrados em [07_EXEMPLOS_DE_CALIBRACAO.md](07_EXEMPLOS_DE_CALIBRACAO.md). Os valores são experimentais, não regras finais.

Perguntas de revisão desses exemplos:
1. O acréscimo de até 15 pontos e a mudança B→A no golpe FOR parecem adequados?
2. “Potência/impacto” deve ser renomeado para “eficácia do efeito principal” para cobrir dano, cura e suporte?
3. Os três perfis devem continuar como casos de calibração?

## Nova diretriz UX registrada
Cada opção do customizador deve ser explicada em cards, identificando o que é, para que serve e o que altera. Pequenas prévias modulares devem mostrar tamanho, formato, aparência geral simplificada e efeitos adicionados. Detalhes em [08_UX_E_PROXIMOS_PASSOS.md](08_UX_E_PROXIMOS_PASSOS.md).

## Próxima etapa
Godot 4 foi escolhido; a próxima etapa é abrir o protótipo e revisar visualmente o fluxo, os cards e a Sandbox.

## Decisão tecnológica confirmada
O usuário escolheu Godot 4 para UI, lógica e Sandbox 2D. O projeto está em [prototipo-godot](prototipo-godot/README.md).





