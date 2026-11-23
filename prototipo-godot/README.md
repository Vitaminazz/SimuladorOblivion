# Simulador Oblivion — protótipo Godot 4

## Abrir
1. [Baixe Godot 4.7.2 para Windows](https://godotengine.org/download/windows/) (versão padrão, sem suporte C#) e extraia o executável.
2. Na tela inicial do Godot, importe o arquivo `project.godot` desta pasta como projeto existente.
3. Abra o projeto e execute a cena principal.

## O que já dá para experimentar
- Nomear e explorar combinações prontas de manifestações.
- Configurar forma e origem, espaço, comportamento, aparência e efeitos em abas separadas.
- Ajustar alcance máximo, escala da forma e quantidade de dummies; o círculo da Sandbox marca o limite atual.
- Escolher entrega e trajetória sem duplicar opções. Cadência controla o intervalo entre manifestações, não a velocidade do projétil.
- Usar duração Fugaz para percorrer o alcance e desaparecer no limite, ou uma duração em cena (1,5 s, 3 s ou 5 s); manifestações temporizadas param no alcance máximo.
- Combinar composição visual e cor sem sugerir que esses controles já alteram regras de combate.
- Ativar efeitos em camadas e ver respostas visuais nos dummies.
- Mirar clicando e arrastando sobre a Sandbox; ativar ou pausar a prévia contínua.
- Usar “No alvo” como origem: passe a mira sobre um dummy para marcá-lo; a marca permanece enquanto você ajusta a direção.
- Escolher a trajetória Seguidora para perseguir o dummy mais próximo da mira sem trocar de alvo durante o disparo. Com “No alvo”, a mira define a direção a partir do dummy marcado, sem fazer o projétil voltar para a própria origem.
- Observar prévias modulares separadas para forma, alcance, movimento, aparência e efeitos.

As interações de combate descritas pela documentação, como cooldown em segundos, status-base, Dano Real, rank, DPS e resistência dos dummies, ainda são conceituais nesta versão e não fazem parte da interface atual.

## Limites deliberados do protótipo
- É uma demonstração de interação e legibilidade; rank e DPS não são medidores ativos nesta versão.
- Faixas finais, pesos, regras completas e visual definitivo ainda precisam de validação.
- Efeitos e dano são visuais e temporários; ainda não mudam atributos persistentes dos dummies.
- Ainda não salva habilidades nem implementa SSS/U na Sandbox.
- O projeto foi executado em modo headless no Godot 4.7.2 após esta revisão, sem erros de parse ou inicialização.
