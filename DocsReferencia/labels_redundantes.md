# RELATÓRIO DE LABELS REDUNDANTES E CONFIGURAÇÕES CONFUSAS
## Simulador Oblivion (Godot 4.7.2)

Aplicado em: 2026-11-17
Foco: Identificar labels redundantes, inutilizadas ou confusas dentro do código e da interface do usuário.

---

## 1. ANÁLISE POR ABAS DO CRIADOR

### 1.1 ABAS DE CONFIGURAÇÃO

| Aba | Label | Options | Estado | Problema |
|-----|-------|---------|--------|----------|
| Manifestar | ATIVAÇÃO | Gesto, Conjuração, Corpo, Arma ou foco, Emanação, Aura, Reativa, Passiva | ✅ Usado | — |
| Manifestar | ORIGEM | Jogador, Ponto de mira, Ao redor, No alvo | ✅ Usado | — |
| Manifestar | FORMA | Cone, Feixe, Projétil, Esfera, Rajada, Corte, Onda, Anel, Parede, Campo, Chuva, Corrente, Selo, Invocação | ⚠️ Unused shapes | Selo, Invocação não têm renderização definida |
| Espaço | ALCANCE | Toque, Curta, Média, Longa, Máxima | ✅ Usado | — |
| Espaço | ESCALA | Delicada, Focada, Ampla, Monumental | ✅ Usado | Valores muito próximos (1.0–3.5) |
| Espaço | FOCO | Livre, Mira, Próximo alvo, Área escolhida | ❌ INUSUADO | Nenhum código lê `targeting` |
| Espaço | ALVOS VISUAIS | Alvo único, Dupla, Grupo, Multidão | ⚠️ Confuso | Descrição não bate com o visual (3 dummies sempre) |
| Movimento | ENTREGA | Instantânea, Projétil, Canalizada, Aura, Orbital, Invocada | ⚠️ Redundante | "Projétil" e "Orbital" são também movimentos |
| Movimento | MOVIMENTO | Fixa, Direta, Curva, Ondulante, Seguidora, Expansiva, Orbital, Retorno, Queda, Espalhada | ⚠️ Redundante | Muitos caem no mesmo `match` (ver abaixo) |
| Movimento | RITMO | Única, Cadenciada, Rápida, Contínua, Reativa | ✅ Usado | Pontos de atenção abaixo |
| Movimento | PERSISTÊNCIA | Efêmera, Breve, Sustentada, Persistente | ✅ Usado | — |
| Essência | ESSÊNCIA | Arcana, Fogo, Gelo, Raio, Vento, Água, Terra, Natureza, Luz, Sombra, Espiritual, Espectral | ✅ Usado | — |
| Essência | PALETA | Ciano, Dourado, Violeta, Rubi, Esmeralda, Índigo, Aurora, Fumaça | ✅ Usado | — |
| Essência | TEXTURA VISUAL | Faíscas, Névoa, Fragmentos, Runas, Chamas, Cristais, Fios de energia, Pétalas | ✅ Usado | — |
| Efeitos | EFEITOS | 16 opções | ⚠️ Parcialmente mapeados | Ver seção 2 |

---

## 2. LABELS REDUNDANTES / INUSUADOS

### 2.1 Movimento — 7 opções caem no mesmo comportamento

| Label | Mapeamento atual | Impacto |
|-------|------------------|---------|
| Fixa | → `reto` | Mesmo que Direta |
| Direta | → `reto` | Mesmo que Fixa |
| Curva | → `espiral` | Mesmo que Ondulante |
| Ondulante | → `espiral` | Mesmo que Curva |
| Seguidora | → `perseguidor` | — |
| Expansiva | → `retorno` | Mesmo que Queda e Espalhada |
| Queda | → `retorno` | Mesmo que Expansiva e Espalhada |
| Espalhada | → `retorno` | Mesmo que Expansiva e Queda |
| Orbital | → `órbita` | — |
| Retorno | → `retorno` | — |

**Resultado:** 10 opções, mas apenas 5 comportamentos distintos:
- `reto` (Fixa + Direta)
- `espiral` (Curva + Ondulante)
- `perseguidor` (Seguidora)
- `retorno` (Expansiva + Queda + Espalhada)
- `órbita` (Orbital)
- `default` (qualquer outra)

**Correção sugerida:** Unificar os sinônimos ou remover as opções redundantes.
- Ex: Remover "Fixa" (é sinônimo de "Direta")
- Ex: Remover "Curva" e "Ondulante" (sinônimos)
- Ex: Remover "Expansiva", "Queda", "Espalhada" (sinônimos)

---

### 2.2 Entrega — conflito com Movimento

| Label antigo | Novo nome (atual) | Problema |
|--------------|-------------------|----------|
| Projétil | travessia | "Projétil" já é uma **forma** (shape) |
| Orbital | giratória | "Orbital" já é um **movimento** |

**Correção sugerida:** Usar nomes que não colidam com as outras categorias:
- ★ Recomendado: `Imediata`, `Travessia`, `Direcionada`, `Aura`, `Giratória`, `Invocada`
- 🚫 Evitar: `Projétil`, `Orbital`, `Corte`, `Invocação` (já usados em outras categorias)

---

### 2.3 Foco — não é lido em nenhum código

| Label | Opções | Status |
|-------|--------|--------|
| FOCO | Livre, Mira, Próximo alvo, Área escolhida | ❌ INUSUADO |

**Confirmação:** O código **não** lê o campo `targeting` em nenhum lugar.
- `sandbox_view.gd` não possui `_ability_text("targeting", ...)`
- A princípio, "Foco" é redundante com "Origem" (pois não muda o comportamento)

**Correção sugerida:**
- Se mantiver: implementar o comportamento (ex: manifestação aparece no player, some, aparece no alvo)
- Se remover: apagar a aba "Foco" ou renomear para algo mais específico

---

### 2.4 Alvos Visuais — descrição incorreta

| Opção | Comportamento atual | Problema |
|-------|---------------------|----------|
| Alvo único | Mostra 3 dummies | ❌ Não mostra 1 dummy |
| Dupla | Mostra 3 dummies | ❌ Não mostra 2 dummies |
| Grupo | Mostra 6 dummies | ✅ OK |
| Multidão | Mostra 3 dummies | ❌ Não mostra muitos dummies |

**Confirmação:** A descrição diz "Quantidade de dummies usados só como referência na Sandbox", mas a visualização mostra 3 dummies independente da escolha. Apenas "Grupo" e "Multidão" devem mudar o número.

**Correção sugerida:**
- `Alvo único` → 1 dummy
- `Dupla` → 2 dummies
- `Grupo` → 6 dummies
- `Multidão` → 9 dummies

---

### 2.5 Escala — intervalos muito próximos

| Opção | Valor atual | Problema |
|-------|-------------|----------|
| Delicada | 1.0 | Muito próximo de Focada |
| Focada | 1.5 | — |
| Ampla | 2.5 | — |
| Monumental | 3.5 | Diferença ainda pequena para o visual |

**Correção sugerida:** Ampliar o intervalor para que cada opção seja mais perceptível:
- `Delicada` → 1.0 (leve)
- `Focada` → 1.5
- `Ampla` → 2.5
- `Monumental` → 4.0+ (quase 180% do tamanho máximo)

---

### 2.6 Forma — shapes não renderizados

| Shape | Renderização no `_draw_manifestation` | Status |
|-------|------------------------------------------|--------|
| Cone | ✅ | OK |
| Feixe | ✅ | OK |
| Projétil | ✅ | OK |
| Esfera | ✅ | OK |
| Rajada | ✅ | OK |
| Corte | ❌ | Não renderiza (cai no `_` default) |
| Onda | ✅ | OK |
| Anel | ✅ | OK |
| Parede | ✅ | OK |
| Campo | ✅ | OK |
| Chuva | ✅ | OK |
| Corrente | ✅ | OK |
| Selo | ❌ | Não renderiza (cai no `_` default) |
| Invocação | ❌ | Não renderiza (cai no `_` default) |

**Correção sugerida:** Implementar renderização para "Corte", "Selo" e "Invocação", ou removê-los das opções.

---

## 3. LISTA DE CONFIGURAÇÕES QUE FIZEM O MESMO EFEITO

### 3.1 Movimento (mesma tag, mesmo resultado)

| Configuração | Outras com mesmo efeito | Comportamento compartilhado |
|--------------|-------------------------|-----------------------------|
| Fixa | Direta | `reto` (linha reta) |
| Curva | Ondulante | `espiral` (curva) |
| Expansiva | Queda, Espalhada | `retorno` (volta ao origem) |
| Orbital | — | `órbita` (vira em torno) |
| Seguidora | — | `perseguidor` (segue alvo) |

**Conclusão:** 10 opções → 5 comportamentos únicos.

---

### 3.2 Entrega (mesmo campo, nomes conflitantes)

| Configuração | Conflicto |
|--------------|-----------|
| Projétil | É também uma `shape` ("Forma" da aba Manifestar) |
| Orbital | É também um `motion` (da aba Movimento) |
| Canalizada | Não é um termo clássico de magia |
| Invocada | É uma `shape` ("Invocação") |

**Conclusão:** Usar nomes que não colidam com outras categorias.

---

## 4. PRÓXIMO PASSO

Para o próximo ciclo:
1. Responder às perguntas sobre reações/configurações
2. Apontar quais labels devem ser removidas ou renomeadas
3. Decidir se "Foco" vira feature de verdade ou é removido

---

## 5. TÍTULO DA ARQUIVO
**Relatório de Labels Redundantes e Configurações Confusas — v1.0**

---

*Gerado em 2026-11-17*
*Montado a partir da análise do código `sandbox_view.gd` e `main.gd`*
