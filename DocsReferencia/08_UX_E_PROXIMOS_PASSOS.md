# Diretrizes de UX do customizador e próximos passos

## Diretriz confirmada pelo usuário
O customizador deve ser fácil de compreender visualmente. Cada coisa configurável deve deixar claro o que é e para que serve. A interface deve dar prévias pequenas e modulares, sem exigir um desenho final detalhado, mostrando ao menos:
- tamanho;
- formato;
- aparência geral simplificada;
- efeitos adicionados.

Cada atributo modificável também deve ter um card identificável que explique:
1. **Nome e representação visual** do atributo/opção.
2. **O que faz** no poder.
3. **O que altera** no resultado ou comportamento.
4. **Estado atual** (selecionado, valor, ativado/desativado, se aplicável).
5. **Prévia de impacto** simples, quando der para mostrar visualmente.

## Organização de tela — proposta inicial, não aprovada
Uma tela principal do customizador pode reunir pequenos módulos de prévia e os cards de configuração, mantendo as informações separadas por conceito. Exemplo de módulos:
- **Forma e tamanho:** silhueta/área simplificada, com escala visual aproximada.
- **Aparência:** cor, material/elemento e visual geral, sem animação sofisticada.
- **Efeitos:** lista/mini ícones dos efeitos adicionados e uma indicação do resultado esperado.
- **Atributo-base:** card indicando o status-base e uma explicação de como ele inspira a manifestação.
- **Resumo:** combinação selecionada e rank provisório, com alertas se houver dados incompletos.

A UX/UI ainda deve comparar se as prévias ficam fixas, em módulos redimensionáveis ou aparecem ao lado das etapas/cards. Não transformar esta sugestão de organização em decisão final sem revisão do usuário.

## Princípios para os cards
- Nome e ícone não bastam: explicar efeito da escolha em linguagem simples.
- Separar atributo-base, forma, tamanho, composição, comportamento e efeitos.
- Mostrar claramente o que mudou quando uma opção é ativada ou modificada.
- Reutilizar padrões para os mesmos tipos de atributo e efeito.
- Orientar sem esconder opções ou impedir combinações incomuns.
- Alertas explicam possíveis consequências, não usam linguagem punitiva.
- Evitar números obrigatórios quando uma representação visual ou descrição for mais clara.
- Manter leitura funcional em tema escuro e com destaques coloridos.

## Próximos passos do projeto

### 1. Consolidar requisitos atuais — concluído
Registrar cards explicativos, prévias modulares, rank, Dano Real, dummies e apresentação representacional.

### 2. UX/UI desenhar o fluxo do customizador
Propor a sequência de criação e a navegação entre status-base, forma/tamanho, aparência, efeitos, atributos modificáveis e revisão. Definir quais módulos permanecem visíveis e como se atualizam.

### 3. Criar wireframe de baixa fidelidade
Desenhar uma tela exemplo com a Sandbox como contexto e o customizador em foco. Usar texto, blocos e previews simples; ainda sem escolher tecnologia ou arte final.

### 4. Validar se os cards são autoexplicativos (próxima revisão)
Revisar com o usuário se cada card responde “o que é?”, “para que serve?” e “o que altera?”. Ajustar rótulos, explicações e hierarquia.

### 5. Completar o modelo de poderes
Definir o significado dos status-base, dimensões configuráveis, dependências, modificadores e quais opções podem ser combinadas. Usar exemplos FOR, INT e HAR já discutidos.

### 6. Definir escopo da primeira versão (MVP)
Separar o essencial do customizador das interações avançadas; documentar o que é apenas preview/representação e quais efeitos funcionam na primeira Sandbox até SS.

### 7. Escolher a base tecnológica — concluído
Godot 4 foi escolhido para concentrar a interface, a lógica demonstrativa e a Sandbox 2D. O protótipo inicial foi preparado.

### 8. Executar e revisar o protótipo
Abrir os arquivos do projeto no Godot 4, observar o fluxo, identificar problemas de clareza e ajustar cards, prévias e Sandbox em ciclos curtos.

## Próxima entrega recomendada
Executar o projeto no Godot 4 e revisar visualmente a primeira versão. Com essa revisão, consolidar a primeira lista de ajustes e o escopo do próximo incremento.

## Revisão do gestor de requisitos — cadência e próxima expansão

### Correção aplicada: execução pelo cooldown
Antes, soltar o mouse disparava um único cálculo de acerto. A mira agora fica posicionada na Sandbox; o botão **Iniciar** executa um disparo imediato e repete a habilidade até **Pausar**, respeitando o cooldown. Mover a mira durante a execução altera os próximos disparos. O cooldown está configurável entre 0,25 e 10 segundos, com indicação aproximada de ataques por segundo. Dano e DPS continuam identificados como representações do protótipo.

### Próximas adições sugeridas, em ordem
1. **Propriedades específicas de cada forma** — Cone: abertura; Feixe: largura e duração; Esfera/Rajada: raio. Cada campo deve ter card explicativo, valor atual e prévia sincronizada. Isso corrige a limitação atual em que o slider genérico de amplitude não controla cada geometria com precisão.
2. **Tempo de conjuração e duração separados do cooldown** — conjuração é o tempo até o primeiro disparo/efeito; duração é quanto tempo um canal, aura ou efeito permanece; cooldown é quando pode voltar a disparar. Começar com conjuração e duração opcionais, sem exigir esses campos para habilidades instantâneas.
3. **Comportamento do efeito** — distinguir impacto imediato, dano ao longo do tempo, cura, controle e aura. Quando selecionado, cada tipo revela os campos relevantes (por exemplo, duração e frequência de pulsos), em vez de mostrar todos os campos de uma vez.
4. **Configuração dos dummies** — quantidade, distância (Queima-roupa/Média/Longa/Máxima/Fora de alcance), resistência (Fraco/Normal/Elite/Indestrutível) e imunidades com ícones/tooltip. Dano Real continua binário: ignora defesas após acerto; não transforma erro em acerto e não destrói o Indestrutível.
5. **Composição/elemento e origem da manifestação** — elemento (fogo, gelo, etc.) separado do formato, e origem (corporal, projetada, aura, automática) separada do status-base. Evita acoplar rótulos prontos como “flecha de fogo” a uma única opção.

### Sequência de implementação recomendada
- **Próximo incremento:** propriedades por forma + conjuração/duração, mantendo cooldown já disponível.
- **Incremento seguinte:** configuração dos dummies e imunidades, incluindo respostas visuais coerentes.
- **Depois:** composição/origem e consolidação dos medidores do rank com exemplos de calibração.

Essa sequência mantém o customizador como foco, dá significado à cadência e deixa as mecânicas do alvo prontas antes de prometer efeitos persistentes. A prioridade entre esses incrementos ainda precisa de confirmação do usuário.

