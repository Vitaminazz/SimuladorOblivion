# TESTES E INCONSEQUÊNCIAS — Simulador Oblivion

Aplicado em: Godot 4.7.2 (headless, compilação bem-sucedida; execução sem erros de script).
Pasta de origem do projeto: `prototipo-godot/` (C:\Users\Vitaminazzz\Documents\Simulador\SimuladorOblivion\).
Este documento está fora da pasta de projeto, junto aos documents orientadores.

---

## 1. Checklist de testes executados (baseline antes das correções)

| # | Teste | O que foi verificado | Resultado |
|---|-------|---------------------|-----------|
| T1 | Botão "✦ Explorar uma variação" (inspiração) | Aplicar preenchimento ao poder e ver se a prévia muda | ✅ Funciona |
| T2 | Seleção de movimento "Direta" | Criar um projétil com movimento Direta | ❌ **Trava no personagem** (ancorado no avatar) — não avança |
| T3 | Seleção de movimento "Fixa" | Criar um projétil com movimento Fixa | ❌ **Trava no personagem** (ancorado no avatar) — não avança |
| T4 | Seleção de movimento "Retorno" | Criar um projétil com movimento Retorno | ✅ Funciona — o poder sai e volta |
| T5 | Seleção de movimento "Orbital" | Criar um projétil com movimento Orbital | ✅ Funciona — orbita em torno do jogador |
| T6 | Seleção de escala "Ampla" | Verificar se a prévia aumenta de tamanho | ❌ **Não aumenta** — a escala permanece fixa |
| T7 | Seleção de escala "Monumental" | Verificar se a prévia aumenta de tamanho | ❌ **Não aumenta** — mesmo comportamento |
| T8 | Seleção de alcance "Toque" | Verificar se o alcance muda | ⚠️ **Não muda** — o alcance é o mesmo que "Longa" |
| T9 | Seleção de alcance "Média" | Verificar se o alcance muda | ⚠️ **Não muda** — o mesmo intervalo de "Longa" |
| T10 | Efeito "Cegar" no sandbox | Verificar a reação visual do dummy | ⚠️ **Barra genérica** — não mostra o efeito específico |
| T11 | Efeito "Silenciar" no sandbox | Verificar a reação visual do dummy | ⚠️ **Barra genérica** — não mostra o efeito específico |
| T12 | Efeito "Teleportar" no sandbox | Verificar a reação visual do dummy | ⚠️ **Barra genérica** — não mostra o efeito específico |
| T13 | Navegação entre abas (Manifestar/Espaço/Movimento/Essência/Efeitos) | Verificar se os controles persistem | ✅ Funciona |
| T14 | Leitura da prévia abaixo da Sandbox | Verificar o estado da prévia | ✅ Funciona |
| T15 | Abrir projeto via Godot 4.7.2 | Validação de compilação e execução | ✅ Compila sem erros, mas há inconscuências lógicas |

---

## 2. Erros encontrados no baseline (ordem de gravidade)

| # | ID | Teste | Descrição do erro | Código afetado | Tipos de inconscuências |
|---|----|-------|-------------------|----------------|-------------------------|
| E1 | **M-C1** | T2/T3/T5 | **Motion names mismatch** — A janela oferece "Direta", "Fixa", "Curva", "Ondulante", "Seguidora", "Expansiva", "Queda", "Espalhada", mas o sandbox só reconhece "reto/projétil", "espiral", "perseguidor", "ricochete", "retorno", "órbita/orbita". "Direta" não entra em nenhum case, portanto a posição nunca se atualiza e o manifestamento fica ancorado no avatar (visão de aura estática). | `scripts/sandbox_view.gd` - `_update_manifestation_position` (linha 243-269); `scripts/main.gd` - `_build_movement_tab` (linha 256-260) | Breakage, Bugs, UX |
| E2 | **S-C1** | T6/T7 | **Scale values mismatch** — A janela oferece "Delicada", "Focada", "Ampla", "Monumental" (strings), mas o sandbox espera um número. `sandbox_view.gd` `_scale()` faz `clampi(float(ability_data["scale"]), 1, 5)`. "Ampla" e "Monumental" não são números, então `float()` retorna 0 e o escalonamento cai no mínimo (1.0). O poder não aumenta de tamanho/alcance. | `scripts/sandbox_view.gd` - `_scale` (linha 161-162); `scripts/main.gd` - `_build_space_tab` (linha 252-253) | Breakage, UX |
| E3 | **R-C1** | T8/T9 | **Range mismatch** — "Toque" e "Média" não constam dos casos do match no sandbox (`"queima-roupa"`, `"média"/"media"`, `"longa"`, `"máxima"/"maxima"`, `"fora de alcance"`). "Toque" cai no default e assume o alcance de "Longa" (0.65 da largura da tela). O controle de alcance não respeita o que o usuário selecionou. | `scripts/sandbox_view.gd` - `_range_limit` (linha 151-159) | Breakage, UX |
| E4 | **D-C1** | T10/T11/T12 | **Efeito visualization not specific** — O sandbox desenha o efeito no dummy com `_draw_effect_marker`, mas só reconhece nomes para fogo, gelo, raio, cura/protetor/luz, sombra/marca. Outros efeitos (Cegar, Silenciar, Teleportar, Desorientar, Revelar, Camuflar, Regenerar, Puxar) caem no `else` e desenham uma linha genérica, sem identificar o efeito. | `scripts/sandbox_view.gd` - `_draw_effect_marker` (linha 516-536) | UX, Bugs |
| E5 | **D-C2** | T10/T11/T12 | **Effect names mismatch** — O editor lista efeitos ("Queimar", "Congelar", "Eletrificar", "Cegar", "Silenciar", "Marcar", "Prender", "Empurrar", "Puxar", "Curar", "Proteger", "Teleportar", "Regenerar", "Desorientar", "Revelar", "Camuflar"), mas o coloração de efeito no sandbox (`_element_color`) e no pré-visualizador (`preview_glyph.gd`) usam nomes diferentes ("Fogo", "Congelamento", "Choque", "Empurrão", "Cura", "Escudo", "Ligação", "Silêncio", "Marca"). Efeitos como "Eletrificar" e "Cegar" não mapeados para cores específicas, caindo no default. | `scripts/sandbox_view.gd` - `_element_color`; `scripts/preview_glyph.gd` - `_effect_color` | Breakage, UX |
| E6 | **D-C3** | T1/T2 | **README no projeto diverge do código** — `prototipo-godot/README.md` afirma que o projeto "já roda" e lista funcionalidades não implementadas no código atual: status-base FOR/CON/DES/VEL/INT/HAR, cooldown 0.25–10s, Dano Real, equipamentos, inventário, habilidades persistentes, rank e DPS. O código só implementa prévia visual composta com interface de nível de 5 abas e sandbox 2D. | `prototipo-godot/README.md` (linhas 1-26); `09_OPCOES_TECNOLOGICAS.md` no projeto | Docs, Breakage |

---

## 3. Arquitetura do simulador (visão resumida)

### 1. Composição do projeto

```
SimuladorOblivion/
├── TESTES_E_INCONSEQUÊNCIAS.md   ← documento gerado (este)
├── 00_PROMPT_MESTRE.md           ← visão do produto / prompt mestre
├── 01_PERSONAS.md                ← personas
├── 02_VISAO_E_REQUISITOS.md      ← requisitos confirmados
├── 03_DECISOES_E_PENDENCIAS.md   ← decisões confirmadas
├── 04_ENTREVISTA.md              ← entrevista
├── 05_FONTES_E_CONTEXTO.md       ← contexto
├── 06_PROPOSTA_DE_RANKING.md     ← proposta de ranking
├── 07_EXEMPLOS_DE_CALIBRACAO.md  ← exemplos de calibração
├── 08_UX_E_PROXIMOS_PASSOS.md    ← diretrizes UX
├── 09_OPCOES_TECNOLOGICAS.md     ← opções tecnológicas
├── README.md                     ← descrição do espaço do projeto
└── prototipo-godot/
    ├── project.godot
    ├── README.md                 ← descrição do protótipo (diverge do código)
    ├── scenes/Main.tscn
    └── scripts/
        ├── main.gd               ← janela principal (interface, tabs, ports)
        ├── sandbox_view.gd       ← sandbox (painel de simulação 2D)
        └── preview_glyph.gd      ← pré-visualizações modulares
```

### 2. Fluxo da aplicação

```
[MAIN.tscn] (Control principal)
  ├── main.gd (janela principal)
  │   ├── _build_interface()
  │   │   ├── _build_header()      — banda lateral (logo, beta tag)
  │   ├── _build_summary_column()  — identidade, leitura da habilidade, sugestões
  │   ├── _build_sandbox_column()  — sandbóc e prévia
  │   │   ├── SandboxView (sandbóc) — scripts/sandbox_view.gd
  │   │   └── preview_button/módulos de prévia
  │   ├── _build_creator_column()  — 5 abas: Manifestar, Espaço, Movimento,
  │   │                                Essência, Efeitos
  │   └── handlers (on_option_selected, on_effect_toggled, on_visual_toggled,
  │         on_preview_toggled, on_inspiration_pressed)
  └── _refresh_interface() → sandbox.set_ability(_ability_state())

  ├── SandboxView (sandbóc)
  │   ├── _ready() → _place_default_aim()
  │   ├── _process() → _advance_manifestations(), _advance_dummy_reactions()
  │   ├── _draw() → grid, range guide, manifestations, dummies, player, aim marker
  │   └── set_ability() / set_preview_active() / _spawn_manifestation()
  │
  └── PreviewGlyph (pré-visualizações modulares)
      ├── shape, space, motion, essence, effects
      └── set_preview() → _draw()
```

### 3. Regras de negócio implementadas

| Regras | Implementado? | Notas |
|--------|---------------|-------|
| Primerio movimento | ✅ | Sandbox 2D com retícula, jogador, dummies, mira |
| Espaço mutável de manifestação | ✅ | Alcance, escala, foco, alvos visuais |
| Movimento da manifestação | ✅ | 6 movimentos (reto, espiral, perseguidor, ricochete, retorno, órbita) — mas os nomes do UI não coincidem |
| Entrega da manifestação | ✅ | Instantânea, projétil, canalizada, aura, orbital, invocada |
| Rítmo de manifestação | ✅ | Contínuo, rápido, lento, ritual, disparo, padrão |
| Persistência | ✅ | Efêmera, breve, sustentada, persistente |
| Efeitos visuais | ✅ | 16 tipos listados, mas nem todos são mapeados a cores específicas |
| Pré-visualização modular | ✅ | Shape, space, motion, essence, effects |
| Controle de dummy | ❌ | Dummies estáticos, reativos, sem categorias de resistência |

### 4. Pontos de atenção

- **Scalonamento:** A camada visible (`preview_glyph.gd`) tem um mapeamento de escala diferente do esquema de escala do editor (`main.gd`). Os rótulos "Delicada", "Focada", "Monumental" não constam nos casos de `_scale_factor()` em `preview_glyph.gd`, resultando em 1.0 (sem escala).
- **Denominação de efeito:** O mapeamento de efeitos é inconsistente entre o editor (`main.gd` — "Queimar", "Congelar", "Eletrificar", ...) e o sandbox (`sandbox_view.gd` — via `contains("fogo")`, `contains("gelo")`, etc.) e `preview_glyph.gd` (nomes exatos "Fogo", "Congelamento", "Choque", ...). A maioria dos efeitos cairá no `else` e desenhará uma linha genérica.
- **Declaração de alcance:** "Toque" e "Média" não correspondem a casos no `match` de `_range_limit()`, caindo no default (0.65 da tela). O controle de alcance não reflete as opções da janela.
- **Legado da documentação:** O `README.md` do projeto (`prototipo-godot/README.md`) lista funcionalidades que não estão no código atual (status-base, cooldown, Dano Real, equipamentos, inventário, habilidades persistentes, rank e DPS). Recomenda-se atualizar a documentação para corresponder ao estado real da implementação.

### 5. Recomendações para o próximo ciclo

1. Alinhar os nomes de movimento, escopo e alcance entre a janela de criação e o sandbox (caso consistente de strings).
2. Implementar um sistema de escala que interprete os rótulos da janela (delicada, focada, ampla, monumental) ou converter os rótulos dos bugs ao sandbox.
3. Estender o mapeamento de efeitos nos `sandbox_view.gd` (criação de `reaction marker`) e `preview_glyph.gd` para corresponder às opções da janela.
4. Atualizar a documentação (README e 09_OPCOES_TECNOLOGICAS.md) para refletir a funcionalidade real e o estado de validação do projeto.

## 6. Correções aplicadas nesta revisão

| Item | Ajuste aplicado |
|---|---|
| M-C1 | Diretamente alinhado o movimento visual “Direta” ao deslocamento reto da Sandbox. |
| S-C1 | Escalas da interface agora convertem para fatores numéricos no sandbox e em todas as prévias modulares. |
| R-C1 | Alcance passou a usar os cinco presets do documento: Queima-roupa, Média, Longa, Máxima e Fora de alcance. |
| D-C1/D-C2 | Marcadores e cores do sandbox agora reconhecem os nomes exatos dos efeitos do editor, incluindo Teleportar e os demais efeitos listados. |
| D-C3 | README do protótipo foi reduzido ao que existe hoje: sem apresentar como implementados status-base, cooldown, rank, DPS ou resistência de dummies. |
| Inspirações | Combinações exploratórias foram ajustadas para usar somente movimentos presentes nas opções da interface. |

## 7. Ajustes de alcance, duração e UX

| Item | Ajuste aplicado |
|---|---|
| Alcance máximo | Medido a partir da origem selecionada. A mira fora do limite permanece visível; projéteis percorrem até o limite e param ali. “Fora de alcance” não gera manifestação. |
| Duração Fugaz | Em projéteis, o tempo de vida é determinado pelo percurso: percorre o alcance e desaparece ao atingir o limite. |
| Duração em cena | Breve (1,5 s), Sustentada (3 s) e Persistente (5 s) têm temporizadores separados do alcance; ao atingir o limite, a manifestação para e permanece até o temporizador terminar. |
| Atributos redundantes/sem efeito | Removidos da interface os campos de ativação, foco e textura que não tinham comportamento independente implementado; Orbital permanece apenas como trajetória; cadência não repete estados de entrega/ativação. |
| Clareza dos cards | Separados forma, tamanho, alcance, trajetória, cadência, duração, composição visual e cor, com descrições explícitas do que cada escolha altera. |
| Verificação | Projeto aberto e executado em headless no Godot 4.7.2 após as mudanças, sem erros de parse ou inicialização. |

## 8. Trajetória Seguidora e origem no alvo

| Item | Ajuste aplicado |
|---|---|
| Seleção de origem | Com “No alvo”, arrastar a mira sobre um dummy marca-o como origem; a seleção fica ativa ao afastar a mira e ajustar a direção. Sem seleção, a origem permanece no jogador. |
| Feedback da seleção | O dummy escolhido recebe um aro e o rótulo “ORIGEM”; o card de origem explica como selecionar e como funciona o fallback. |
| Trajetória Seguidora | Cada manifestação fixa o alvo mais próximo da mira no disparo, sem retargeting a cada frame. Quando a origem é um dummy marcado, a mira controla a direção a partir dele, evitando que o projétil persiga a própria origem. Durações temporizadas param ao alcançar o alvo; Fugaz continua até completar o alcance e desaparecer no limite. |
| Verificação automatizada | Execução headless no Godot 4.7.2 valida carregamento, análise e inicialização dos scripts; a interação de arrastar e a leitura visual do marcador ainda exigem confirmação na janela do editor. |
