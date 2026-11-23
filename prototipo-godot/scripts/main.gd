extends Control

const SandboxView = preload("res://scripts/sandbox_view.gd")
const PreviewGlyph = preload("res://scripts/preview_glyph.gd")

const C_BG := Color(0.027, 0.035, 0.059)
const C_PANEL := Color(0.063, 0.078, 0.118)
const C_PANEL_ALT := Color(0.082, 0.102, 0.149)
const C_BORDER := Color(0.18, 0.22, 0.30)
const C_TEXT := Color(0.90, 0.93, 0.98)
const C_MUTED := Color(0.58, 0.65, 0.76)
const C_ACCENT := Color(0.31, 0.73, 1.0)
const C_PURPLE := Color(0.68, 0.47, 1.0)
const C_GOOD := Color(0.33, 0.88, 0.64)

const EFFECT_HELP: Dictionary = {
	"Queimar": "Fagulhas e calor no alvo.",
	"Congelar": "Cristais e frio visual.",
	"Eletrificar": "Arcos rápidos de energia.",
	"Cegar": "Clarão breve e luminoso.",
	"Silenciar": "Selo que reduz a presença visual.",
	"Marcar": "Runa flutuante de identificação.",
	"Prender": "Laços ou correntes visuais.",
	"Empurrar": "Recuo visual breve.",
	"Puxar": "Atração visual em direção à origem.",
	"Curar": "Anel de restauração e brilho verde.",
	"Proteger": "Bolha ou placa de proteção.",
	"Teleportar": "Rastro e reposicionamento visual.",
	"Regenerar": "Partículas que retornam em pulsos.",
	"Desorientar": "Órbita e distorção ao redor do alvo.",
	"Revelar": "Pulso que ilumina a área.",
	"Camuflar": "Névoa que suaviza a silhueta."
}

var ability_name := "Nova manifestação"
var selected_origin := "Jogador"
var selected_shape := "Esfera"
var selected_range := "Longa"
var selected_scale := "Ampla"
var selected_delivery := "Projétil"
var selected_motion := "Direta"
var selected_rhythm := "Cadenciada · 0,65 s"
var selected_persistence := "Fugaz · até o limite"
var selected_essence := "Arcana"
var selected_palette := "Violeta"
var selected_target_density := "Grupo"
var selected_effects: Array[String] = []
var reactive_targets_enabled := true
var preview_is_active := false
var inspiration_index := -1

var sandbox: SandboxView
var name_input: LineEdit
var preview_button: Button = null
var result_label: Label = null
var summary_title: Label
var summary_label: Label
var context_label: Label
var validation_label: Label
var preview_glyphs: Dictionary = {}
var pickers: Dictionary = {}
var effect_boxes: Dictionary = {}
var visual_boxes: Dictionary = {}

func _ready() -> void:
	_build_interface()
	_refresh_interface()

func _build_interface() -> void:
	var background := ColorRect.new()
	background.color = C_BG
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	add_child(margin)

	var page := VBoxContainer.new()
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page.add_theme_constant_override("separation", 14)
	margin.add_child(page)
	_build_header(page)

	var body := HBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)
	page.add_child(body)

	_build_summary_column(body)
	_build_sandbox_column(body)
	_build_creator_column(body)

func _build_header(parent: VBoxContainer) -> void:
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 14)
	parent.add_child(header)

	var brand := VBoxContainer.new()
	brand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	brand.add_theme_constant_override("separation", 2)
	header.add_child(brand)
	brand.add_child(_label("OBLIVION  /  POWER LAB", 22, C_TEXT))
	brand.add_child(_label("Laboratório vivo para imaginar, compor e observar habilidades", 12, C_MUTED))

	var beta_tag := _label("CRIADOR VIVO  •  BETA", 11, C_ACCENT)
	beta_tag.custom_minimum_size.x = 210
	beta_tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	beta_tag.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	beta_tag.autowrap_mode = TextServer.AUTOWRAP_OFF
	header.add_child(beta_tag)

func _build_summary_column(parent: HBoxContainer) -> void:
	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(258, 0)
	column.add_theme_constant_override("separation", 12)
	parent.add_child(column)

	var identity_box := _section_card(column, "IDENTIDADE", "Dê uma direção à ideia. Todo o restante pode mudar livremente depois.")
	name_input = LineEdit.new()
	name_input.text = ability_name
	name_input.placeholder_text = "Nome da habilidade"
	name_input.text_changed.connect(_on_name_changed)
	identity_box.add_child(name_input)

	var inspiration_button := Button.new()
	inspiration_button.text = "✦ Explorar uma variação"
	inspiration_button.pressed.connect(_on_inspiration_pressed)
	identity_box.add_child(inspiration_button)

	var summary_box := _section_card(column, "LEITURA DA HABILIDADE", "O editor junta as escolhas em uma descrição simples, sem limitar combinações incomuns.")
	summary_title = _label("", 14, C_ACCENT)
	summary_box.add_child(summary_title)
	summary_label = _label("", 11, C_TEXT)
	summary_box.add_child(summary_label)

	var context_box := _section_card(column, "SUGESTÃO CONTEXTUAL", "As sugestões guiam a criação, mas nunca bloqueiam uma ideia diferente.")
	context_label = _label("", 11, C_MUTED)
	context_box.add_child(context_label)

	var validation_box := _section_card(column, "REVISÃO", "Resumo das escolhas e do que esta prévia consegue representar.")
	validation_label = _label("", 11, C_GOOD)
	validation_box.add_child(validation_label)

func _build_sandbox_column(parent: HBoxContainer) -> void:
	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.size_flags_stretch_ratio = 1.0
	column.add_theme_constant_override("separation", 12)
	parent.add_child(column)

	var sandbox_card := _panel_container(column)
	sandbox_card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var sandbox_box := VBoxContainer.new()
	sandbox_box.add_theme_constant_override("separation", 8)
	sandbox_card.add_child(sandbox_box)

	var heading := HBoxContainer.new()
	sandbox_box.add_child(heading)
	var titles := VBoxContainer.new()
	titles.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	titles.add_child(_label("SANDBOX  /  PRÉVIA VIVA", 14, C_TEXT))
	titles.add_child(_label("Arraste a mira. O círculo indica o alcance máximo; projéteis param no limite.", 11, C_MUTED))
	heading.add_child(titles)
	preview_button = Button.new()
	preview_button.text = "▶  Ativar prévia"
	preview_button.toggle_mode = true
	preview_button.custom_minimum_size.x = 128
	preview_button.toggled.connect(_on_preview_toggled)
	heading.add_child(preview_button)

	sandbox = SandboxView.new()
	sandbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sandbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sandbox.custom_minimum_size = Vector2(420, 310)
	sandbox.preview_changed.connect(_on_preview_changed)
	sandbox_box.add_child(sandbox)

	result_label = _label("A prévia está pronta. Ative-a para ver a manifestação ganhar movimento.", 11, C_MUTED)
	sandbox_box.add_child(result_label)

	_build_preview_modules(column)

func _build_preview_modules(parent: VBoxContainer) -> void:
	var preview_card := _section_card(parent, "PRÉVIAS MODULARES", "Pequenos sinais visuais mostram o que cada parte da habilidade está alterando.")
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	preview_card.add_child(row)
	_add_preview_module(row, "FORMA", "shape")
	_add_preview_module(row, "ALCANCE", "space")
	_add_preview_module(row, "MOVIMENTO", "motion")
	_add_preview_module(row, "APARÊNCIA", "essence")
	_add_preview_module(row, "EFEITOS", "effects")

func _add_preview_module(parent: HBoxContainer, title: String, kind: String) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size = Vector2(70, 94)
	panel.add_theme_stylebox_override("panel", _panel_style(C_PANEL_ALT))
	parent.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	panel.add_child(box)
	var heading := _label(title, 9, C_MUTED)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(heading)
	var glyph := PreviewGlyph.new()
	glyph.custom_minimum_size = Vector2(60, 42)
	glyph.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(glyph)
	preview_glyphs[kind] = glyph

func _build_creator_column(parent: HBoxContainer) -> void:
	var tabs := TabContainer.new()
	tabs.custom_minimum_size.x = 348
	tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(tabs)

	var manifestation_tab := _make_tab(tabs, "Forma")
	var space_tab := _make_tab(tabs, "Espaço")
	var movement_tab := _make_tab(tabs, "Comportamento")
	var essence_tab := _make_tab(tabs, "Aparência")
	var effects_tab := _make_tab(tabs, "Efeitos")

	_build_manifestation_tab(manifestation_tab)
	_build_space_tab(space_tab)
	_build_movement_tab(movement_tab)
	_build_essence_tab(essence_tab)
	_build_effects_tab(effects_tab)

func _build_manifestation_tab(tab: VBoxContainer) -> void:
	_add_select_card(tab, "FORMA", "A geometria visível da habilidade. Muda o desenho e a região que pode alcançar; não define elemento ou movimento.", ["Cone", "Feixe", "Esfera", "Rajada", "Corte", "Onda", "Anel", "Parede", "Campo", "Chuva", "Corrente", "Selo"], selected_shape, "shape")
	_add_select_card(tab, "ORIGEM", "Onde a manifestação começa. Em “No alvo”, arraste a mira sobre um dummy para marcá-lo; a seleção permanece ao mover a mira e, sem seleção, o jogador é usado como origem.", ["Jogador", "Ponto de mira", "Ao redor", "No alvo"], selected_origin, "origin")

func _build_space_tab(tab: VBoxContainer) -> void:
	_add_select_card(tab, "ALCANCE MÁXIMO", "Distância máxima a partir da origem. O círculo da Sandbox mostra esse limite; projéteis param nele.", ["Queima-roupa", "Média", "Longa", "Máxima", "Fora de alcance"], selected_range, "range")
	_add_select_card(tab, "TAMANHO DA FORMA", "Escala o espaço ocupado pela manifestação, não a distância que ela percorre.", ["Delicada", "Focada", "Ampla", "Monumental"], selected_scale, "scale")
	_add_select_card(tab, "QUANTIDADE DE ALVOS", "Muda somente quantos dummies aparecem para observar a área e as reações.", ["Alvo único", "Dupla", "Grupo", "Multidão"], selected_target_density, "density")

func _build_movement_tab(tab: VBoxContainer) -> void:
	_add_select_card(tab, "ENTREGA", "Como a manifestação aparece: impacto imediato, trajeto de projétil, canal, aura ou invocação.", ["Impacto imediato", "Projétil", "Canalizada", "Aura", "Invocada"], selected_delivery, "delivery")
	_add_select_card(tab, "TRAJETÓRIA", "Define o caminho do projétil. Não altera a cadência dos disparos nem o alcance máximo.", ["Direta", "Ondulante", "Seguidora", "Orbital", "Retorno"], selected_motion, "motion")
	_add_select_card(tab, "CADÊNCIA", "Intervalo entre novas manifestações enquanto a prévia está ativa. Não altera a velocidade do projétil.", ["Lenta · 1,2 s", "Cadenciada · 0,65 s", "Rápida · 0,22 s"], selected_rhythm, "rhythm")
	_add_select_card(tab, "DURAÇÃO EM CENA", "Fugaz percorre o alcance e some no limite. As outras opções mantêm a manifestação pelo tempo indicado; projéteis param ao atingir o alcance e órbitas permanecem dentro dele.", ["Fugaz · até o limite", "Breve · 1,5 s", "Sustentada · 3 s", "Persistente · 5 s"], selected_persistence, "persistence")

func _build_essence_tab(tab: VBoxContainer) -> void:
	_add_select_card(tab, "COMPOSIÇÃO VISUAL", "Define a natureza visual e o símbolo da manifestação. Nesta prévia, não altera regras de dano ou interação.", ["Arcana", "Fogo", "Gelo", "Raio", "Vento", "Água", "Terra", "Natureza", "Luz", "Sombra", "Espiritual", "Espectral"], selected_essence, "essence")
	_add_select_card(tab, "COR", "Altera a cor da manifestação sem mudar sua forma, alcance ou trajetória.", ["Ciano", "Dourado", "Violeta", "Rubi", "Esmeralda", "Índigo", "Aurora", "Fumaça"], selected_palette, "palette")

func _build_effects_tab(tab: VBoxContainer) -> void:
	var effects_box := _section_card(tab, "CAMADAS DE EFEITO", "Marque quantas ideias quiser. No beta, cada uma gera uma resposta visual reconhecível.")
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	effects_box.add_child(grid)
	for effect_name in EFFECT_HELP.keys():
		_add_effect_card(grid, str(effect_name), str(EFFECT_HELP[effect_name]))

	var response_box := _section_card(tab, "REAÇÃO DA SANDBOX", "Escolhas de apresentação para deixar a prévia mais viva sem transformá-la em combate.")
	_add_visual_check(response_box, "Reações visuais nos alvos", "Ativa ou desativa o brilho e o marcador visual quando uma manifestação alcança um dummy.", "reaction", reactive_targets_enabled)

func _make_tab(tabs: TabContainer, tab_name: String) -> VBoxContainer:
	var scroll := ScrollContainer.new()
	scroll.name = tab_name
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs.add_child(scroll)
	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.add_theme_constant_override("separation", 10)
	scroll.add_child(column)
	return column

func _add_select_card(parent: VBoxContainer, title: String, help_text: String, options: Array[String], selected: String, key: String) -> OptionButton:
	var card := _section_card(parent, title, help_text)
	var picker := OptionButton.new()
	picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for option in options:
		picker.add_item(option)
	_select_picker_value(picker, selected)
	picker.item_selected.connect(_on_option_selected.bind(key))
	card.add_child(picker)
	pickers[key] = picker
	return picker

func _add_effect_card(parent: GridContainer, effect_name: String, help_text: String) -> void:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _panel_style(C_PANEL_ALT))
	parent.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 2)
	panel.add_child(box)
	var checkbox := CheckBox.new()
	checkbox.text = effect_name
	checkbox.tooltip_text = help_text
	checkbox.toggled.connect(_on_effect_toggled.bind(effect_name))
	box.add_child(checkbox)
	box.add_child(_label(help_text, 9, C_MUTED))
	effect_boxes[effect_name] = checkbox

func _add_visual_check(parent: VBoxContainer, title: String, help_text: String, key: String, pressed: bool) -> void:
	var checkbox := CheckBox.new()
	checkbox.text = title
	checkbox.tooltip_text = help_text
	checkbox.set_pressed_no_signal(pressed)
	checkbox.toggled.connect(_on_visual_toggled.bind(key))
	parent.add_child(checkbox)
	parent.add_child(_label(help_text, 10, C_MUTED))
	visual_boxes[key] = checkbox

func _on_name_changed(new_name: String) -> void:
	ability_name = new_name.strip_edges()
	_refresh_interface()

func _on_option_selected(index: int, key: String) -> void:
	var picker: OptionButton = pickers.get(key, null) as OptionButton
	if picker == null:
		return
	var value: String = picker.get_item_text(index)
	match key:
		"origin": selected_origin = value
		"shape": selected_shape = value
		"range": selected_range = value
		"scale": selected_scale = value
		"density": selected_target_density = value
		"delivery": selected_delivery = value
		"motion": selected_motion = value
		"rhythm": selected_rhythm = value
		"persistence": selected_persistence = value
		"essence": selected_essence = value
		"palette": selected_palette = value
	_refresh_interface()

func _on_effect_toggled(pressed: bool, effect_name: String) -> void:
	if pressed and not selected_effects.has(effect_name):
		selected_effects.append(effect_name)
	elif not pressed:
		selected_effects.erase(effect_name)
	_refresh_interface()

func _on_visual_toggled(pressed: bool, key: String) -> void:
	match key:
		"reaction": reactive_targets_enabled = pressed
	_refresh_interface()

func _on_preview_toggled(pressed: bool) -> void:
	if preview_button == null:
		return
	preview_is_active = pressed
	preview_button.text = "■  Pausar prévia" if pressed else "▶  Ativar prévia"
	if sandbox:
		sandbox.set_preview_active(pressed)
	if result_label:
		result_label.text = "A manifestação está ativa e responde às suas escolhas." if pressed else "A prévia foi pausada; suas escolhas continuam visíveis."
		result_label.add_theme_color_override("font_color", C_GOOD if pressed else C_MUTED)

func _on_preview_changed(message: String) -> void:
	if result_label:
		result_label.text = message
		result_label.add_theme_color_override("font_color", C_TEXT)

func _on_inspiration_pressed() -> void:
	inspiration_index = (inspiration_index + 1) % 4
	match inspiration_index:
		0:
			ability_name = "Jardim de Cristal"
			selected_origin = "Ponto de mira"
			selected_shape = "Campo"
			selected_range = "Média"
			selected_scale = "Ampla"
			selected_delivery = "Invocada"
			selected_motion = "Ondulante"
			selected_rhythm = "Cadenciada · 0,65 s"
			selected_persistence = "Persistente · 5 s"
			selected_essence = "Gelo"
			selected_palette = "Ciano"
			_set_effects(["Congelar", "Prender", "Marcar"])
		1:
			ability_name = "Rastro do Eclipse"
			selected_origin = "Jogador"
			selected_shape = "Corrente"
			selected_range = "Longa"
			selected_scale = "Focada"
			selected_delivery = "Projétil"
			selected_motion = "Retorno"
			selected_rhythm = "Cadenciada · 0,65 s"
			selected_persistence = "Breve · 1,5 s"
			selected_essence = "Sombra"
			selected_palette = "Índigo"
			_set_effects(["Marcar", "Teleportar", "Desorientar"])
		2:
			ability_name = "Coroa de Aurora"
			selected_origin = "Ao redor"
			selected_shape = "Anel"
			selected_range = "Queima-roupa"
			selected_scale = "Ampla"
			selected_delivery = "Aura"
			selected_motion = "Orbital"
			selected_rhythm = "Cadenciada · 0,65 s"
			selected_persistence = "Sustentada · 3 s"
			selected_essence = "Luz"
			selected_palette = "Aurora"
			_set_effects(["Curar", "Proteger", "Revelar"])
		_:
			ability_name = "Monção das Runas"
			selected_origin = "Ponto de mira"
			selected_shape = "Chuva"
			selected_range = "Máxima"
			selected_scale = "Monumental"
			selected_delivery = "Canalizada"
			selected_motion = "Direta"
			selected_rhythm = "Rápida · 0,22 s"
			selected_persistence = "Breve · 1,5 s"
			selected_essence = "Raio"
			selected_palette = "Dourado"
			_set_effects(["Eletrificar", "Cegar", "Empurrar"])
	_sync_controls()
	_refresh_interface()
	result_label.text = "Uma combinação exploratória foi aplicada. Ajuste qualquer parte para torná-la sua."
	result_label.add_theme_color_override("font_color", C_ACCENT)

func _set_effects(new_effects: Array[String]) -> void:
	selected_effects = new_effects.duplicate()
	for effect_name_variant in effect_boxes:
		var effect_name: String = str(effect_name_variant)
		var checkbox: CheckBox = effect_boxes[effect_name] as CheckBox
		checkbox.set_pressed_no_signal(selected_effects.has(effect_name))

func _sync_controls() -> void:
	if name_input:
		name_input.text = ability_name
	_set_picker_value("origin", selected_origin)
	_set_picker_value("shape", selected_shape)
	_set_picker_value("range", selected_range)
	_set_picker_value("scale", selected_scale)
	_set_picker_value("density", selected_target_density)
	_set_picker_value("delivery", selected_delivery)
	_set_picker_value("motion", selected_motion)
	_set_picker_value("rhythm", selected_rhythm)
	_set_picker_value("persistence", selected_persistence)
	_set_picker_value("essence", selected_essence)
	_set_picker_value("palette", selected_palette)

func _set_picker_value(key: String, value: String) -> void:
	var picker: OptionButton = pickers.get(key, null) as OptionButton
	if picker:
		_select_picker_value(picker, value)

func _select_picker_value(picker: OptionButton, value: String) -> void:
	for option_index in range(picker.item_count):
		if picker.get_item_text(option_index) == value:
			picker.select(option_index)
			return

func _refresh_interface() -> void:
	var palette: Color = _palette_color(selected_palette)
	if summary_title:
		summary_title.text = ability_name if not ability_name.is_empty() else "Manifestação sem nome"
	if summary_label:
		summary_label.text = _ability_summary()
	if context_label:
		context_label.text = _context_suggestion()
	if validation_label:
		validation_label.text = _preview_state_text()
	if sandbox:
		sandbox.set_ability(_ability_state())
	if not preview_glyphs.is_empty():
		var shape_glyph: PreviewGlyph = preview_glyphs.get("shape") as PreviewGlyph
		var space_glyph: PreviewGlyph = preview_glyphs.get("space") as PreviewGlyph
		var motion_glyph: PreviewGlyph = preview_glyphs.get("motion") as PreviewGlyph
		var essence_glyph: PreviewGlyph = preview_glyphs.get("essence") as PreviewGlyph
		var effects_glyph: PreviewGlyph = preview_glyphs.get("effects") as PreviewGlyph
		shape_glyph.set_preview("shape", selected_shape, palette, selected_scale, selected_effects)
		space_glyph.set_preview("space", selected_range, palette, selected_scale, selected_effects)
		motion_glyph.set_preview("motion", selected_motion, palette, selected_scale, selected_effects)
		essence_glyph.set_preview("essence", selected_essence, palette, selected_scale, selected_effects)
		effects_glyph.set_preview("effects", "", palette, selected_scale, selected_effects)

func _ability_state() -> Dictionary:
	var state: Dictionary = {}
	state["name"] = ability_name
	state["origin"] = selected_origin
	state["shape"] = selected_shape
	state["range"] = selected_range
	state["scale"] = selected_scale
	state["delivery"] = selected_delivery
	state["motion"] = selected_motion
	state["rhythm"] = selected_rhythm
	state["persistence"] = selected_persistence
	state["essence"] = selected_essence
	state["palette"] = _palette_color(selected_palette)
	state["effects"] = selected_effects.duplicate()
	state["target_density"] = selected_target_density
	state["target_reactions"] = reactive_targets_enabled
	return state

func _ability_summary() -> String:
	var effect_text := "sem camadas extras"
	if not selected_effects.is_empty():
		effect_text = _join_words(selected_effects)
	return "%s · %s · origem %s · alcance %s · escala %s · trajetória %s · duração %s. Composição visual: %s. Efeitos: %s." % [selected_shape, selected_delivery.to_lower(), selected_origin.to_lower(), selected_range.to_lower(), selected_scale.to_lower(), selected_motion.to_lower(), selected_persistence.to_lower(), selected_essence.to_lower(), effect_text]

func _context_suggestion() -> String:
	if selected_range == "Fora de alcance":
		return "Fora de alcance: a mira continua visível para comparação, mas a Sandbox não executa a manifestação."
	if selected_range == "Queima-roupa":
		return "Alcance curto: a manifestação para perto do jogador. Aumente o alcance se quiser testar trajetos mais longos."
	if selected_range == "Longa" or selected_range == "Máxima":
		return "Distância amplia Feixe, Projétil, Chuva e Corrente. Você ainda pode manter uma forma de proximidade por estilo."
	if selected_shape == "Campo" or selected_shape == "Parede" or selected_shape == "Anel":
		return "Uma forma de área pode combinar com Aura, Proteger, Curar ou Marcar. São sugestões; não restringem outras combinações."
	if selected_essence == "Fogo" or selected_essence == "Raio":
		return "Fogo e Raio podem ser combinados com Queimar ou Eletrificar. A sugestão não impede outros efeitos."
	return "Experimente combinar movimento, persistência e efeitos: cada parte mantém sua função separada no criador."

func _preview_state_text() -> String:
	if selected_range == "Fora de alcance":
		return "A prévia não dispara: o alcance está definido como Fora de alcance."
	if selected_persistence.begins_with("Fugaz") and selected_delivery == "Projétil" and selected_motion == "Retorno":
		return "Fugaz termina ao atingir o limite. Use uma duração em segundos para observar o trajeto de retorno."
	if selected_persistence.begins_with("Fugaz") and selected_delivery == "Projétil":
		return "Fugaz: percorre o alcance selecionado e desaparece ao chegar ao limite."
	if selected_persistence.begins_with("Fugaz"):
		return "Fugaz: como esta entrega não percorre o cenário, a manifestação dura apenas um pulso visual."
	return "%s: a manifestação permanece em cena pelo tempo indicado; projéteis param no limite e órbitas ficam dentro dele." % selected_persistence

func _join_words(words: Array[String]) -> String:
	if words.size() == 1:
		return words[0]
	if words.size() == 2:
		return "%s e %s" % [words[0], words[1]]
	var first_words: Array[String] = words.slice(0, words.size() - 1)
	return "%s e %s" % [", ".join(PackedStringArray(first_words)), words[words.size() - 1]]

func _palette_color(name: String) -> Color:
	match name:
		"Ciano": return Color(0.31, 0.73, 1.0)
		"Dourado": return Color(1.0, 0.77, 0.30)
		"Violeta": return C_PURPLE
		"Rubi": return Color(1.0, 0.31, 0.34)
		"Esmeralda": return Color(0.27, 0.87, 0.58)
		"Índigo": return Color(0.40, 0.35, 0.94)
		"Aurora": return Color(0.96, 0.76, 1.0)
		"Fumaça": return Color(0.62, 0.67, 0.79)
		_: return C_ACCENT

func _section_card(parent: Node, title: String, description: String) -> VBoxContainer:
	var panel := _panel_container(parent)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 7)
	panel.add_child(box)
	box.add_child(_label(title, 12, C_TEXT))
	box.add_child(_label(description, 10, C_MUTED))
	return box

func _panel_container(parent: Node) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _panel_style(C_PANEL))
	parent.add_child(panel)
	return panel

func _panel_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = C_BORDER
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	style.set_content_margin_all(11)
	return style

func _label(text_value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label
