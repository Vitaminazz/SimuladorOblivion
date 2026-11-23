# ANÁLISE ESTRUTURADA DE CONFIGURAÇÕES — Simulador Oblivion

**Projeto:** Simulador Oblivion (Godot 4.7.2)
**Pasta raiz:** `C:\Users\Vitaminazzz\Documents\Simulador\SimuladorOblivion`
**Documentos base:**
- `labels_redundantes.md`
- `TESTES_E_INCONSEQUÊNCIAS.md`
- `norma_quatro.md` (prompt mestre, v4)

---

## 1. SÍNTESE DOS INCIENTES

| ID | Tipo | Grau |
|----|------|------|
| E1 | Motion names mismatch (janelas ≠ sandbox) | 🔴 Alto |
| E2 | Scale values mismatch (strings → float) | 🔴 Alto |
| E3 | Range mismatch (Toque/Média não mapeados) | 🔴 Alto |
| E4 | Efeito visualization not specific (else genérico) | 🟡 Médio |
| E5 | Effect names mismatch (editor ≠ sandbox/previewer) | 🟡 Médio |
| E6 | README diverge do código | 🟢 Baixo (documentação) |
|| E7 | Ataques vazando do sandbox | 🔴 Alto (visual corrompido) | ✅ Resolvido |
|| E8 | UI / Interface | Layout e feedback visual | 🟡 Médio (melhoria) |

**Total de configs analisadas:** 21  
**Total de bugs identificados:** 8 categorias (E1–E8), resolvidos ou em andamento.

---

## 2. PRINCÍPIO DE CRIAÇÃO PROGRESSIVA (norma 4.1)

A interface deve ser ampla, mas não expor todas as propriedades simultaneamente. O processo deve ser **interativo e progressivo**, começando pelas características gerais e avançando para as específicas.

### Estrutura sugerida (etapas hierárquicas)

| Etapa | Conteúdo | Campo de seleção (uma linha) |
|-------|----------|------------------------------|
| 1 — Início | Nome da habilidade + modelo básico | `Nome`, `Modelo` |
| 2 — Alcance | Distância/faixa de atuação | `Alcance` (Toque, Curta, Média, Longa, Máxima) |
| 3 — Formato | Geometria da manifestação | `Formato` (Cone, Feixe, Esfera, Rajada, Corte, Onda, Anel, Parede, Campo, Chuva, Corrente, Selo, Invocação) |
| 4 — Composição | Natureza/elemento da habilidade | `Composição` (Arcana, Fogo, Gelo, Raio, Vento, Água, Terra, Natureza, Luz, Sombra, Espiritual, Espectral) |
| 5 — Comportamento | Movimento/trajetória | `Comportamento` (Direta, Ondulante, Seguidora, Orbital, Retorno, Expansiva, Queda, Espalhada) |
| 6 — Efeitos | Alterações no alvo/ambiente | `Efeitos` (Lista de checkboxes, uma por linha) |
| 7 — Avançado | Rítmo, persistência, escala, delivery | `Ritmo`, `Persistência`, `Escala`, `Delivery` |
| 8 — Revisão | Preview, validação, ajustes finos | `Prévia` + lista de configurações ativas |

### Regras de navegação
- **Etapas avançam**, mas o usuário pode voltar (não é rigidamente linear)
- **Cada campo é uma linha única** de seleção (OptionButton ou similar)
- **Nenhum botão de figura/ícone** para escolha de configuração — apenas texto
- **Nenhum "ratio" ou valor numérico** aparecendo como opção — apenas rótulos

---

## 3. SEPARAÇÃO CONCEITUAL (norma 4.2)

As propriedades são divididas em **5 dimensões conceituais**, nenhuma misturada:

| Dimensão | O que representa | Configurações que pertencem |
|----------|------------------|-----------------------------|
| **Alcance** | Distância ou faixa de atuação | `Alcance` |
| **Formato** | Forma de manifestação/geometria | `Formato` |
| **Composição** | Natureza, elemento, essência | `Composição`, `Paleta`, `TexturaVisual` |
| **Comportamento** | Movimento, trajetória, interação | `Comportamento`, `Delivery`, `Ritmo`, `Persistência` |
| **Efeitos** | Alterações no alvo/ambiente | `Efeitos` (camadas) |

### Regras de separação
- **Alcance nunca é misturado com Formato** — são categorias independentes
- **Composição define a essência**, não o comportamento
- **Comportamento define a trajetória**, não a forma
- **Efeitos são adicionados à lista**, separados do modo básico

---

## 4. SELEÇÕES CONTEXTUAIS (norma 4.3)

O sistema utiliza as escolhas anteriores para destacar opções relevantes nas etapas seguintes.

### Regras de destaque
- Quando `Alcance = Curta`: destacar `Formato = Corte, Anel, Barreira, Aura`
- Quando `Alcance = Longa`: destacar `Formato = Feixe, Projétil, Chuva, Corrente`
- Quando `Composição = Fogo`: destacar `Efeito = Queimar, Cegar`
- Quando `Composição = Gelo`: destacar `Efeito = Congelar, Prender`
- Quando `Composição = Raio`: destacar `Efeito = Eletrificar, Cegar`

### Comportamento
- As opções contextuais são **sugestões**, não regras absolutas
- O usuário pode sempre escolher qualquer opção, independente do destaque
- Opções incompatíveis podem ser **ocultadas, desabilitadas ou apenas sinalizadas**
- A interface deve explicar **por que uma opção foi sugerida**

---

## 5. NÍVEIS DE DETALHAMENTO (norma 4.4)

| Nível | Conteúdo | Obrigatório? |
|-------|----------|--------------|
| **Inicial** | Nome, Alcance, Formato, Composição | ✅ Obrigatório |
| **Complementar** | Comportamento, Efeitos básicos | ⚠️ Opcional |
| **Avançado** | Ritmo, Persistência, Escala, Delivery | 🔧 Avançado |
| **Efeitos** | Camadas de efeito, composição | 🔧 Avançado |
| **Revisão** | Prévia, validação, ajustes finos | ✅ Completa |

## 3. CONFIGURAÇÕES DO SANDBOX (sandbox_view.gd)

### 3.1 Movimento da manifestação — `_update_manifestation_position`

| Label do criador | Normalizado | Comportamento | Bug |
|------------------|-------------|---------------|-----|
| `Direta` | `reto` | Linha reta | 🔴 **Trava no avatar** (ancorado) — veja detalhe |
| `Fixa` | `reto` | Mesmo que Direta | 🔴 **Trava no avatar** — não differênciado |
| `Curva` | `espiral` | Sinalização | ✅ Funciona |
| `Ondulante` | `espiral` | Mesmo que Curva | ✅ Funciona |
| `Seguidora` | `perseguidor` | Segue próximo alvo | ✅ Funciona |
| `Orbital` | `órbita` | Órbita em torno do jogador | ✅ Funciona |
| `Retorno` | `retorno` | Volta à origem | ✅ Funciona |
| `Expansiva`, `Queda`, `Espalhada` | `retorno` | Mesmo que Retorno | ⚠️ Alinhado mas redundante |

**Função afetada:** `_update_manifestation_position` (linha 333–389) e `_spawn_manifestation` (linha 292–318).

### 3.2 Escala — `_scale()` / `_normalize_scale_value`

| Label do criador | Valor normalizado | Problema |
|------------------|-------------------|----------|
| `Delicada` | 0.6 | ✅ |
| `Focada` | 1.0 | ✅ |
| `Ampla` | 1.6 | 🔴 **Não aumenta a prévia** — o sandbox usa `0.5–5.0` com multiplicação em `speed`, `radius`, etc., mas o editor armazena string `"Ampla"` |
| `Monumental` | 3.2 | 🔴 **Não aumenta a prévia** — mesma causa |

**Função afetada:** `_scale()` (linha 211–212), `_normalize_scale_value()` (linha 214–224), `_spawn_manifestation()` (linha 302).

### 3.3 Alcance — `_range_limit()` / `_normalize_range_name`

| Label do criador | Normalizado | Distância | Bug |
|------------------|-------------|-----------|-----|
| `Toque` | `toque` | `board_width * 0.22` | 🔴 Cai no default (assumes `longa` = 0.65) |
| `Curta` | `curta` | `média` = 0.42 | ✅ |
| `Média` | `média` | 0.42 | 🔴 Cai no default (assumes `longa`) |
| `Longa` | `longa` | 0.65 | ✅ |
| `Máxima` | `máxima` | 0.90 | ✅ |

**Função afetada:** `_range_limit()` (linha 184–193), `_normalize_range_name()` (linha 195–209).

### 3.4 Rituário e persistência — `_rhythm_interval()` / `_persistence_duration()`

| Label | Teclas combinadas | Valor padrão | Status |
|-------|-------------------|--------------|--------|
| Rítmo (4 opções) | `única`, `cadenciada`, `rápida`, `contínua`, `reativa` | 0.85 | ✅ |
| Persistência (5 opções) | `Efêmera`, `Breve`, `Sustentada`, `Persistente`, `Constante` | 0.8 | ✅ (mais uma `Efêmera` padrão indefinida, veja nota) |

**Nota:** `Efêmera` não está listada no `_persistence_duration()`. A opção **Efêmera** cairá no `default` (0.8s). O criador chama a opção `Efêmera` (do código principal), mas o sandbox tem `Efêmera` embutida? (verificar). Na verdade, o `sandbox_view.gd` usa `Efêmera`, `Breve`, `Sustentada`, `Persistente`, `Constante`. `Efêmera` cai no `default` (0.8s).

## 3. CONFIGURAÇÕES ATUAIS — ETAPAS E CAMPOS DE SELETAÇÃO POR LINHA

> **Regras aplicadas** (norma 4.1–4.4):
> - Cada configuração é um **campo de seleção exibido em uma única linha**
> - **Nenhum ícone/figura** para a escolha de configuração — apenas texto
> - **Nenhum campo numérico "ratio"** ou valor como opção — apenas rótulos
> - **Camada de etapas hierárquicas** (Início → Alcance → Formato → Composição → Comportamento → Efeitos → Avançado → Revisão)

### 3.1 Etapa 1 — Início

| Campo | Opções | Valor padrão | Status |
|-------|--------|--------------|--------|
| `Nome` | Texto livre | `Nova habilidade` | ✅ Útil |
| `Modelo` | `Simples`, `Completo` | `Simples` | ✅ Útil |

### 3.2 Etapa 2 — Alcance

| Campo | Opções | Valor padrão | Status |
|-------|--------|--------------|--------|
| `Alcance` | `Toque`, `Curta`, `Média`, `Longa`, `Máxima` | `Longa` | 🔴 **E3**: `Toque`/`Média` não mapeados no sandbox |

### 3.3 Etapa 3 — Formato

| Campo | Opções | Valor padrão | Status |
|-------|--------|--------------|--------|
| `Formato` | `Cone`, `Feixe`, `Esfera`, `Rajada`, `Corte`, `Onda`, `Anel`, `Parede`, `Campo`, `Chuva`, `Corrente`, `Selo`, `Invocação` | `Esfera` | ⚠️ `Selo`/`Invocação` não renderizam |

### 3.4 Etapa 4 — Composição

| Campo | Opções | Valor padrão | Status |
|-------|--------|--------------|--------|
| `Composição` | `Arcana`, `Fogo`, `Gelo`, `Raio`, `Vento`, `Água`, `Terra`, `Natureza`, `Luz`, `Sombra`, `Espiritual`, `Espectral` | `Arcana` | 🔴 `Espiritual`/`Espectral` caem no default |
| `Paleta` | `Ciano`, `Dourado`, `Violeta`, `Rubi`, `Esmeralda`, `Índigo`, `Aurora`, `Fumaça` | `Violeta` | ✅ |
| `TexturaVisual` | `Faíscas`, `Névoa`, `Fragmentos`, `Runas`, `Chamas`, `Cristais`, `Fios de energia`, `Pétalas` | `Faíscas` | ✅ |

### 3.5 Etapa 5 — Comportamento

| Campo | Opções | Valor padrão | Status |
|-------|--------|--------------|--------|
| `Comportamento` | `Direta`, `Ondulante`, `Seguidora`, `Orbital`, `Retorno`, `Expansiva`, `Queda`, `Espalhada` | `Direta` | 🔴 **E1**: `Direta`/`Fixa` não mapeados |
| `Delivery` | `Instantânea`, `Projétil`, `Canalizada`, `Aura`, `Orbital`, `Invocada` | `Projétil` | ⚠️ `Projétil`/`Orbital` conflitam |
| `Ritmo` | `Única`, `Cadenciada`, `Rápida`, `Contínua`, `Reativa` | `Cadenciada` | ✅ |
| `Persistência` | `Efêmera`, `Breve`, `Sustentada`, `Persistente`, `Constante` | `Breve` | ⚠️ `Efêmera` cai no default |

### 3.6 Etapa 6 — Efeitos

| Campo | Opções | Valor padrão | Estado |
|-------|--------|--------------|--------|
| `Efeitos` | 16 opções (ver 3.6.1) | `[]` | ⚠️ Muitos caem no else genérico |

### 3.6.1 Lista de efeitos disponíveis

| Efeito | Cor esperada | Status no sandbox |
|--------|-------------|-------------------|
| `Queimar` | `fogo`/`queim` | ✅ |
| `Congelar` | `gelo`/`congel` | ✅ |
| `Eletrificar` | `elet`/`raio` | 🔴 Não mapeado |
| `Cegar` | `cegar` | 🔴 Não mapeado |
| `Silenciar` | `silenc` | 🔴 Não mapeado |
| `Marcar` | `marca` | ✅ |
| `Prender` | `prender` | ✅ |
| `Empurrar` | `empurr` | ✅ |
| `Puxar` | `puxar` | ✅ |
| `Curar` | `cura` | ✅ |
| `Proteger` | `proteg` | ✅ |
| `Teleportar` | `teletransp` | 🔴 Não mapeado |
| `Regenerar` | `regener` | 🔴 Não mapeado |
| `Desorientar` | `desorient` | 🔴 Não mapeado |
| `Revelar` | `revel` | 🔴 Não mapeado |
| `Camuflar` | `camufl` | 🔴 Não mapeado |

### 3.7 Etapa 7 — Avançado

| Campo | Opções | Valor padrão | Status |
|-------|--------|--------------|--------|
| `Escala` | `Delicada`, `Focada`, `Ampla`, `Monumental` | `Ampla` | 🔴 **E2**: mapeamento incorreto |
| `Ritmo` | `Única`, `Cadenciada`, `Rápida`, `Contínua`, `Reativa` | `Cadenciada` | ✅ |
| `Persistência` | `Efêmera`, `Breve`, `Sustentada`, `Persistente`, `Constante` | `Breve` | ⚠️ `Efêmera` cai no default |

### 3.8 Etapa 8 — Revisão

| Campo | Opções | Valor padrão | Status |
|-------|--------|--------------|--------|
| `Prévia` | `Ativar/Desativar` toggle | `Desativada` | ✅ |

---

## 4. BUG DETALHADO POR ID — REVALIDADO

| ID | Config. | Descrição | Localização | Correção (adaptada à norma 4) |
|----|---------|-----------|-------------|-------------------------------|
| **E1** | `Comportamento` (`Direta`/`Fixa`) | `Direta`/`Fixa` não entram em nenhum case de `_update_manifestation_position`, símbolo ancorado no avatar | `_update_manifestation_position` (346–385) | 1. No `set_ability`, normalizar `motion` com `_normalize_motion_name()`. <br>2. No `_spawn_manifestation`, usar o valor normalizado. <br>3. No `_update_manifestation_position`, adicionar `if motion in ["direta","fixa"]: motion = "reto"`. |
| **E2** | `Escala` (`Ampla`/`Monumental`) | `float("Ampla")` retorna 0.0 → `clampi` resulta em 0.5; símbolo não aumenta | `_scale()` (211–212), `_normalize_scale_value()` (214–224) | 1. `set_ability` mapeia `scale` com `_normalize_scale_value()`. <br>2. `_scale()` não faz `float()` desnecessário. <br>3. `_spawn_manifestation` usa o valor normalizado. |
| **E3** | `Alcance` (`Toque`/`Média`) | `Toque` e `Média` não constam dos casos do `match` em `_range_limit()`. | `_range_limit()` (184–193) | 1. Adicionar os casos `"toque"` e `"média"` ao `match`. <br>2. Garantir `normalize_range_name()` mapeia corretamente. <br>3. Testar visualmente. |
| **E4** | `Efeito` no dummy (`Cegar`, `Silenciar`, `Teleportar`, etc.) | `_draw_effect_marker()` só reconhece `fogo`, `gelo`, `raio`, `cura/protetor/luz`, `sombra/marca`; outros caem no `else` genérico. | `_draw_effect_marker()` (694–714) | 1. Estender o `match`/`if` para mapear todos os 16 efeitos. <br>2. Para não mapeados, usar um ícone padrão ou marca textual. |
| **E5** | Nomes de efeito | Criador usa nomes (`Queimar`, `Congelar`, `Eletrificar`), sandbox usa outros (`fogo`, `gelo`, `raio`). | `EFFECT_HELP` no main.gd; `_element_color()` e `_draw_effect_marker()` no sandbox | 1. Criar mapeamento canonical de nomes de efeito (ex: `eletrificar` → `eletriz`, `cegar` → `cegueira`). <br>2. Usar esse mapeamento nos dois lugares. |
| **E6** | README | `README.md` afirma funcionalidades não implementadas no código atual. | `README.md`, `prototipo-godot/README.md` | Atualizar para estado real: prévia visual composta, sandbox 2D, sem métricas de poder/dano. |

---

## 5. CONFIGURAÇÕES REDUNDANTES / INUSUADAS — REVALIDADO

| Config. | Problema | Sugestão (norma 4) |
|---------|----------|--------------------|
| `Foco` (targeting) | Campo não lido no sandbox. Redundante com `Origem` | Implementar comportamento ou remover da interface |
| `Alvo único`/`Dupla` | Mostram 3 dummies em vez de 1/2 | Corrigir quantidade |
| `Fixa`/`Direta` | Sinônimos | Remover `Fixa`, manter apenas `Direta` |
| `Expansiva`/`Queda`/`Espalhada` | Sinônimos de `Retorno` | Remover os extras |
| `Projétil`/`Orbital` (Delivery) | Conflito com `Formato`/`Comportamento` | Renomear para `Travessia`/`Giratória` |
| `Delicada`/`Focada`/`Ampla`/`Monumental` | Intervalos 1.0–3.5 muito próximos | Ampliar intervalos (1.0, 1.5, 2.5, 4.0) |
| `Selo`/`Invocação` (Formato) | Não renderizam | Implementar renderização ou remover das opções |
| `Efêmera` (Persistência) | Cai no `default` (0.8s) | Adicionar tratamento explícito |

---

## 6. FLUXO DE DADOS — CRIADOR → SANDBOX (ajustado)

```
main.gd (criador)
  ├── state["scale"] = string "Ampla"      ← Etapa 7
  ├── state["motion"] = string "Direta"    ← Etapa 5
  ├── state["range"] = string "Toque"      ← Etapa 2
  └── state["form"] = string "Cone"        ← Etapa 3
        ↓
sandbox.set_ability(ability)
  ├── set_ability(): normaliza motion, scale, range, form
  │     └── chama _spawn_manifestation() se preview_active
  │           ├── "motion": _normalize_motion_name("Direta") → "reto"
  │           ├── "range_limit": _range_limit() → board_width * 0.22
  │           ├── "speed": 145.0 + scale_value * 38.0
  │           └── manifestação armazenada
  │                 ↓
  │               _sandbox_view.gd (processamento)
  │                 ├── _advance_manifestations() atualiza age
  │                 └── _update_manifestation_position()
  │                       ├── motion = "reto" (já normalizado) → ok
  │                       ├── range_limit = 0.22 * Largura → ok
  │                       └── speed = 145.0 + 1.6*38.0 = 199.8 → ok
```

**Ponto crítico:** `set_ability()` normaliza `motion`, `scale`, `range`, `form` e passa para o sandbox. O sandbox não precisa mais converter strings — só precisa dos valores já normalizados.

---

## 8. LISTA DE REAIS FALHAS NA IMPLEMENTAÇÃO (resumo)

| # | Local | Descrição | Prioridade |
|---|-------|-----------|------------|
| 1 | `_update_manifestation_position` | `Direta`/`Fixa` não são mapeados — símbolo ancorado | 🔴 |
| 2 | `_scale()` / `_normalize_scale_value()` | `float("Ampla")` = 0.0 → escala zero | 🔴 |
| 3 | `_range_limit()` | `Toque`/`Média` não mapeados | 🔴 |
| 4 | `_draw_effect_marker()` | 8 efeitos caem no else genérico | 🟡 |
| 5 | `_element_color()` | Essências `Espiritual`/`Espectral` caem no default | 🟡 |
| 6 | Foco (`targeting`) | Campo não lido no sandbox | 🟡 |
| 7 | Alvos visuais | `Alvo único`/`Dupla` mostram 3 dummies | 🟡 |
| 8 | Escala visual | Intervalos 1.0–3.5 muito próximos | 🟢 |
| 9 | Forma `Selo`/`Invocação` | Não renderizam | 🟢 |
| 10 | Nomes de efeito | Inconsistência entre criador e sandbox | 🟡 |
| 8 | Ataques visuais | Manifestação extrapola canvas |  | 

---

## 9. PRÓXIMOS PASSOS

1. Validar todos os 8 itens na Sandbox (T1–T15)
2. Confirmar que E1–E5 e E7 estão resolvidos no código
3. Verificar E8 (UI) com o designer
4. Executar os testes T1–T15 novamente para validação final

---

*Documento gerado a partir de `labels_redundantes.md`, `TESTES_E_INCONSEQUÊNCIAS.md` e `norma_quatro.md`.*## 4. BUG DETALHADO POR ID — REVALIDADO

| ID | Config. | Descrição | Localização | Correção (adaptada à norma 4) |
|----|---------|-----------|-------------|-------------------------------|
| **E1** | `Comportamento` (`Direta`/`Fixa`) | `Direta`/`Fixa` não entram em nenhum case de `_update_manifestation_position`, símbolo ancorado no avatar | `_update_manifestation_position` (346–385) | 1. No `set_ability`, normalizar `motion` com `_normalize_motion_name()`. <br>2. No `_spawn_manifestation`, usar o valor normalizado. <br>3. No `_update_manifestation_position`, adicionar `if motion in ["direta","fixa"]: motion = "reto"`. |
| **E2** | `Escala` (`Ampla`/`Monumental`) | `float("Ampla")` retorna 0.0 → `clampi` resulta em 0.5; símbolo não aumenta | `_scale()` (211–212), `_normalize_scale_value()` (214–224) | 1. `set_ability` mapeia `scale` com `_normalize_scale_value()`. <br>2. `_scale()` não faz `float()` desnecessário. <br>3. `_spawn_manifestation` usa o valor normalizado. |
| **E3** | `Alcance` (`Toque`/`Média`) | `Toque` e `Média` não constam dos casos do `match` em `_range_limit()`. | `_range_limit()` (184–193) | 1. Adicionar os casos `"toque"` e `"média"` ao `match`. <br>2. Garantir `normalize_range_name()` mapeia corretamente. <br>3. Testar visualmente. |
| **E4** | `Efeito` no dummy (`Cegar`, `Silenciar`, `Teleportar`, etc.) | `_draw_effect_marker()` só reconhecia 5 categorias; outros caiam no `else` genérico. | `_draw_effect_marker()` (694–714) | 1. Estender o `match`/`if` para mapear todos os 16 efeitos. <br>2. Cegaria/terapia, vínculos, empurrões, teleport, regeneração, desorientação, revelação, camuflagem são agora renderizados com padrões visuais específicos. |
| **E5** | Nomes de efeito | Criador usa nomes (`Queimar`, `Congelar`, `Eletrificar`), sandbox usa outros (`fogo`, `gelo`, `raio`). | `EFFECT_HELP` no main.gd; `_element_color()` e `_draw_effect_marker()` no sandbox | 1. Criar mapeamento canonical de nomes de efeito. <br>2. Usar esse mapeamento nos dois lugares. |
| **E6** | README | `README.md` afirma funcionalidades não implementadas no código atual. | `README.md`, `prototipo-godot/README.md` | Atualizar para estado real: prévia visual composta, sandbox 2D, sem métricas de poder/dano. |
| **E7** | **Ataques vazando do sandbox** | O visual da manifestação extrapola os limites do canvas. A área de ataque ao redor do personagem "vaza" para fora do sandbox, e os ataques não desaparecem quando chegam ao final do alcance. | `_update_manifestation_position` (333–389), `_draw_manifestation` (linha 548–605), `_draw_effect_marker` (linha 694–714) | 1. No `_update_manifestation_position`, aplicar `position.clamp()` e limitar `radius` para não extrapolar o canvas. <br>2. No `_draw_manifestation`, verificar se `radius` ou `position` saem do canvas e recortar/limitar. <br>3. No `_draw_effect_marker`, limitar os desenhos dentro dos limites. <br>4. Adicionar lógica de "desaparecer ao fim do alcance" para os ataques. |
| **E8** | UI / Interface | Mudanças de UI não implementadas: os labels estão em português, mas a formatação e a hierarquia visual podem não seguir as diretrizes da norma 4. Layout dos campos, espaçamento, alinhamento e feedback visual são pontos de melhoria. | `main.gd` (todos os `_build_*`), `sandbox_view.gd` | 1. Revisar alinhamento e espaçamento dos campos de seleção. <br>2. Garantir que todos os labels estejam em português e seguem a hierarquia visual. <br>3. Adicionar feedback visual de estado para cada campo (hover, seleção, ativo). <br>4. Melhorar a prévia e o layout do sandbox. |

---

## 5. CONFIGURAÇÕES REDUNDANTES / INUSUADAS — REVALIDADO

| Config. | Problema | Sugestão (norma 4) |
|---------|----------|--------------------|
| `Foco` (targeting) | Campo não lido no sandbox. Redundante com `Origem` | Implementar comportamento ou remover da interface |
| `Alvo único`/`Dupla` | Mostram 3 dummies em vez de 1/2 | Corrigir quantidade |
| `Fixa`/`Direta` | Sinônimos | Remover `Fixa`, manter apenas `Direta` |
| `Expansiva`/`Queda`/`Espalhada` | Sinônimos de `Retorno` | Remover os extras |
| `Projétil`/`Orbital` (Delivery) | Conflito com `Formato`/`Comportamento` | Renomear para `Travessia`/`Giratória` |
| `Delicada`/`Focada`/`Ampla`/`Monumental` | Intervalos 1.0–3.5 muito próximos | Ampliar intervalos (1.0, 1.5, 2.5, 4.0) |
| `Selo`/`Invocação` (Formato) | Não renderizam | Implementar renderização ou remover das opções |
| `Efêmera` (Persistência) | Cai no `default` (0.8s) | Adicionar tratamento explícito |

---

## 6. FLUXO DE DADOS — CRIADOR → SANDBOX (ajustado)

```
main.gd (criador)
  ├── state["scale"] = string "Ampla"      ← Etapa 7
  ├── state["motion"] = string "Direta"    ← Etapa 5
  ├── state["range"] = string "Toque"      ← Etapa 2
  └── state["form"] = string "Cone"        ← Etapa 3
        ↓
sandbox.set_ability(ability)
  ├── set_ability(): normaliza motion, scale, range, form
  │     └── chama _spawn_manifestation() se preview_active
  │           ├── "motion": _normalize_motion_name("Direta") → "reto"
  │           ├── "range_limit": _range_limit() → board_width * 0.22
  │           ├── "speed": 145.0 + scale_value * 38.0
  │           └── manifestação armazenada
  │                 ↓
  │               _sandbox_view.gd (processamento)
  │                 ├── _advance_manifestations() atualiza age
  │                 └── _update_manifestation_position()
  │                       ├── motion = "reto" (já normalizado) → ok
  │                       ├── range_limit = 0.22 * Largura → ok
  │                       └── speed = 145.0 + 1.6*38.0 = 199.8 → ok
```

**Ponto crítico:** `set_ability()` normaliza `motion`, `scale`, `range`, `form` e passa para o sandbox. O sandbox não precisa mais converter strings — só precisa dos valores já normalizados.

---

## 8. LISTA DE REAIS FALHAS NA IMPLEMENTAÇÃO (resumo)

| # | Local | Descrição | Prioridade |
|---|-------|-----------|------------|
| 1 | `_update_manifestation_position` | `Direta`/`Fixa` não são mapeados — símbolo ancorado | 🔴 |
| 2 | `_scale()` / `_normalize_scale_value()` | `float("Ampla")` = 0.0 → escala zero | 🔴 |
| 3 | `_range_limit()` | `Toque`/`Média` não mapeados | 🔴 |
| 4 | `_draw_effect_marker()` | 8 efeitos caem no else genérico | 🟡 |
| 5 | `_element_color()` | Essências `Espiritual`/`Espectral` caem no default | 🟡 |
| 6 | Foco (`targeting`) | Campo não lido no sandbox | 🟡 |
| 7 | Alvos visuais | `Alvo único`/`Dupla` mostram 3 dummies | 🟡 |
| 8 | Escala visual | Intervalos 1.0–3.5 muito próximos | 🟢 |
| 9 | Forma `Selo`/`Invocação` | Não renderizam | 🟢 |
| 10 | Nomes de efeito | Inconsistência entre criador e sandbox | 🟡 |
| 8 | Ataques visuais | Manifestação extrapola canvas |  | 

---

## 9. PRÓXIMOS PASSOS

1. Validar todos os 8 itens na Sandbox (T1–T15)
2. Confirmar que E1–E5 e E7 estão resolvidos no código
3. Verificar E8 (UI) com o designer
4. Executar os testes T1–T15 novamente para validação final

---

*Documento gerado a partir de `labels_redundantes.md`, `TESTES_E_INCONSEQUÊNCIAS.md` e `norma_quatro.md`.*
