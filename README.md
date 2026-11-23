# Simulador Oblivion — protótipo Godot 4

## Objetivo
Criar poderes visualmente e observar comportamentos numa Sandbox 2D. O customizador é a prioridade inicial. Oblivion Flame inspira ideias, status, raças, habilidades, ranks e atmosfera sem impor as regras do RPG.

## O que já dá para experimentar
- Escolher o status-base entre FOR, CON, DES, VEL, INT, HAR e HP.
- Alternar Cone, Feixe, Esfera e Rajada.
- Definir o alcance (Toque, Médio, Longo, Máximo).
- Ajustar a amplitude/tamanho e a cor visual da manifestação.
- Marcar efeitos Fogo, Gelo e Perfuração.
- Mirar clicando e arrastando no tabuleiro; com a simulação ativa, cada ciclo calcula acertos na cadência configurada. O arco mostra o limite de alcance e a mira fica vermelha quando ultrapassa esse limite.
- Ver prévias modulares de formato, alcance, tamanho, aparência e efeitos.
- Ver acertos com animação e marcadores dos efeitos aplicados.
- Usar as abas Forma, Efeitos e Leitura para manter os controles visíveis em telas menores.

## Limites do protótipo
- É uma demonstração visual e interativa; o rank e DPS/dano são ilustrativos.
- Fontes, pesos, regras completas e visual definitivo ainda precisam de validação.
- Efeitos e dano são visuais e temporários; ainda não mudam atributos persistentes dos dummies.
- Ainda não salva habilidades nem implementa SSS/U na Sandbox.
- O projeto foi aberto e executado em modo headless no Godot 4.7.2. O ambiente emitiu apenas avisos de acesso ao armazenamento de certificados e logs do Windows.
