# Opções tecnológicas para o primeiro protótipo

## O que o produto pede da tecnologia
- UI rica de cards, explicações, prévias modulares e edição progressiva.
- Sandbox 2D pixelizada com quadrícula, alvos, mira, áreas, efeitos e animações pequenas.
- Modelo da habilidade separado da apresentação visual, para preservar liberdade criativa e permitir regras avançadas depois.
- Uso pessoal, sem exigir infraestrutura de servidor na primeira versão.
- Possibilidade de começar prototipando sem decidir toda a tecnologia futura.

## Opção A — Aplicação web local: React + TypeScript + Vite + PixiJS

**Onde cada peça entra**
- React: telas, navegação do customizador, cards explicativos, menus, modais, preview modular.
- TypeScript: formato dos dados de poder, status, medidores, efeitos e estado de simulação.
- Vite: execução local durante o desenvolvimento e montagem da versão web.
- PixiJS: desenho da Sandbox 2D — grade, jogador, dummies, formas, áreas e efeitos pixelizados.
- Persistência: primeiro arquivo exportável ou armazenamento local do navegador; decidir depois que os fluxos estiverem claros.

**Vantagens:** melhor encaixe para uma interface densa de edição; facilita fazer um protótipo navegável rapidamente; a Sandbox fica numa área de desenho isolada; funciona no navegador sem empacotar aplicativo. React organiza telas em componentes reutilizáveis, Vite fornece servidor e montagem da aplicação, e PixiJS oferece desenho 2D com WebGL/WebGL2. Fontes: [React](https://react.dev/learn/describing-the-ui), [Vite](https://vite.dev/guide/), [PixiJS renderers](https://pixijs.com/guides/components/renderers/).

**Limites:** será uma aplicação aberta no navegador; integração com sistema operacional e acesso direto a arquivos locais são mais limitados. Pode ser empacotada como aplicativo depois, se necessário.

**Recomendação:** melhor escolha para o primeiro protótipo e para validar o customizador antes de assumir trabalho de empacotamento desktop.

## Opção B — Godot 4 como aplicação completa

**Onde cada peça entra**
- Godot Control nodes: cards, telas, menus, navegação e prévias.
- Godot 2D: grade da Sandbox, dummies, mira, áreas, efeitos e animações.
- GDScript: dados, regras, medidores e simulação.
- Exportação nativa: executar como aplicativo para desktop; opção de exportar para web se necessário.

**Vantagens:** uma única ferramenta cobre UI, desenho 2D, animação e exportação; voltada a experiências 2D. A documentação descreve ferramentas específicas de 2D e controles de UI próprios. Fontes: [Godot 2D](https://docs.godotengine.org/en/stable/tutorials/2d/introduction_to_2d.html), [Control nodes](https://docs.godotengine.org/en/stable/classes/class_control.html).

**Limites:** o estilo e comportamento de uma interface cheia de cards e formulários precisam ser construídos com o sistema visual do Godot; a adaptação e manutenção do customizador dependem do fluxo do motor. Não está instalado neste computador, então adiciona uma instalação antes de começar.

**Boa escolha se:** a Sandbox e o comportamento de jogo forem o produto principal desde o começo e a interface de criação puder se adaptar ao padrão do motor.

## Opção C — Aplicativo desktop com Tauri 2 + React + TypeScript + PixiJS

**Onde cada peça entra**
- React/TypeScript/Vite/PixiJS: mesmos papéis da Opção A.
- Tauri: janela e empacotamento como aplicativo desktop; integração local poderá ser adicionada quando houver uma necessidade concreta.

**Vantagens:** combina interface web rica com janela de aplicativo; Tauri usa a WebView do sistema e uma camada nativa em Rust, em vez de incluir um navegador completo no pacote. Fontes: [arquitetura Tauri](https://v2.tauri.app/concept/architecture/), [introdução Tauri](https://v2.tauri.app/start/).

**Limites:** introduz Rust, configuração de empacotamento e diferenças entre WebViews antes de sabermos se o usuário precisa de aplicativo instalado. Pode ser adicionado depois sem redesenhar os componentes web, desde que a integração com arquivos seja mantida isolada.

**Boa escolha se:** a prioridade for já distribuir/executar como aplicativo desktop, e instalação/configuração extra forem aceitáveis.

## Opção D — Electron + React + TypeScript + PixiJS

**Onde cada peça entra:** React/TypeScript/Vite/PixiJS formam UI e Sandbox; Electron fornece janela desktop, acesso ao sistema e distribuição.

**Vantagens:** caminho conhecido para aplicativos desktop baseados em tecnologias web; mantém Chromium e Node.js junto ao aplicativo. Fonte: [Electron](https://www.electronjs.org/docs/latest/).

**Limites:** inclui runtime Chromium/Node no aplicativo e tende a ser mais pesado; para este simulador pessoal, não vejo benefício suficiente sobre a Opção C ou sobre começar na web.

## Comparação rápida
| Critério | A: Web | B: Godot | C: Tauri desktop | D: Electron desktop |
|---|---|---|---|---|
| Rapidez do primeiro protótipo | Alta | Média | Média | Média |
| Facilidade para UI de cards | Alta | Média | Alta | Alta |
| Sandbox 2D | PixiJS | Nativa | PixiJS | PixiJS |
| Roda direto no navegador | Sim | Sim, com limitações do export | Não como produto principal | Não |
| Aplicativo desktop | Não inicialmente | Sim | Sim | Sim |
| Tecnologia extra a instalar | Node, já presente | Godot | Rust/Tauri | Runtime do Electron via dependências |
| Custo de início | Baixo | Médio | Médio/alto | Médio |

## Recomendação inicial da equipe (antes da escolha do usuário)
Começar pela **Opção A: React + TypeScript + Vite + PixiJS no navegador**, fazendo um protótipo funcional da tela de customização e uma Sandbox pequena. Ela testa exatamente o ponto de maior incerteza — clareza e alcance do customizador — com a instalação já disponível e sem obrigar a escolher desktop agora. Se a experiência mostrar que o uso precisa ser instalado ou acessar arquivos diretamente, empacotar a mesma base com Tauri (Opção C) será uma etapa posterior.

## Preparação do primeiro protótipo (comum às opções web)
1. Criar a estrutura mínima sem back-end, conta ou nuvem.
2. Montar a interface escura com cards que expliquem função e impacto.
3. Ligar os cards às prévias modulares de tamanho, forma, aparência e efeitos.
4. Desenhar jogador e alguns dummies na Sandbox, com mira e uma forma de área simples.
5. Demonstrar um efeito com resposta visual; mostrar rank e números apenas como representações.
6. Manter os dados do poder separados da camada que desenha a Sandbox.

## Decisão confirmada pelo usuário — 2026-10-29
**Godot Engine 4.7.2 stable** foi escolhido como versão-base para o primeiro protótipo.
- **Godot Control nodes:** interface, cards, menus, prévias e layout.
- **GDScript:** estado/dados do poder, status, efeitos e lógica demonstrativa.
- **Godot 2D e desenho customizado:** Sandbox, grade, dummies, mira, formas e animações curtas.
- **Projeto local sem servidor ou banco externo:** persistência de habilidades será considerada depois de validar o fluxo.

O projeto fonte está em [prototipo-godot](prototipo-godot/README.md). A versão 4.7.2 é a versão estável indicada no [site oficial de download para Windows](https://godotengine.org/download/windows/) na data da decisão. Godot não está instalado nem disponível no PATH desta máquina, por isso os arquivos foram preparados, mas não abertos/executados aqui. Node 22.19 está instalado, mas não será utilizado na base Godot.

Esta escolha concentra a UI de cards e a Sandbox 2D no mesmo motor. Nenhuma camada web ou biblioteca extra de desenho foi adicionada.

