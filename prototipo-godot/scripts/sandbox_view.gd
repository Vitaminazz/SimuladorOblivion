extends Control

signal preview_changed(text: String)

const BACKGROUND := Color(0.035, 0.050, 0.078)
const GRID := Color(0.11, 0.15, 0.21, 0.52)
const PLAYER := Color(0.26, 0.72, 1.00)
const DUMMY := Color(0.91, 0.30, 0.35)
const OUT_OF_RANGE := Color(1.0, 0.35, 0.35)
const TARGET_LAYOUT: Array[Vector2] = [
	Vector2(0.69, 0.23), Vector2(0.79, 0.37), Vector2(0.69, 0.51),
	Vector2(0.81, 0.66), Vector2(0.67, 0.79), Vector2(0.55, 0.34),
	Vector2(0.55, 0.68), Vector2(0.88, 0.20), Vector2(0.88, 0.82),
	Vector2(0.32, 0.20), Vector2(0.32, 0.82), Vector2(0.16, 0.51),
	Vector2(0.92, 0.51)
]

var ability_data: Dictionary = {}
var preview_active := false
var aim_point := Vector2.ZERO
var is_dragging := false
var animation_time := 0.0
var rhythm_clock := 0.0
var active_manifestations: Array[Dictionary] = []
var dummy_reactions: Dictionary = {}
var last_notice := ""
var selected_source_target := -1

func _ready() -> void:
	custom_minimum_size = Vector2(420, 300)
	mouse_filter = Control.MOUSE_FILTER_STOP
	ability_data = _default_ability()
	call_deferred("_place_default_aim")

func _place_default_aim() -> void:
	if aim_point == Vector2.ZERO:
		aim_point = Vector2(size.x * 0.72, size.y * 0.50)
	queue_redraw()

func set_ability(ability: Dictionary) -> void:
	ability_data = _default_ability()
	for key in ability:
		if key == "motion":
			ability_data[key] = _normalize_motion_name(str(ability[key]))
		elif key == "scale":
			ability_data[key] = _normalize_scale_value(ability[key])
		else:
			ability_data[key] = ability[key]
	if _uses_target_origin():
		if selected_source_target >= _target_count():
			selected_source_target = -1
		_update_source_target_from_aim(aim_point)
	else:
		selected_source_target = -1
	active_manifestations.clear()
	dummy_reactions.clear()
	rhythm_clock = 0.0
	_emit_notice(_ability_summary())
	if preview_active:
		_spawn_manifestation()
	queue_redraw()

func set_preview_active(enabled: bool) -> void:
	preview_active = enabled
	rhythm_clock = 0.0
	if preview_active:
		_spawn_manifestation()
		_emit_notice("Prévia contínua ativada: %s" % _ability_text("name", "Nova habilidade"))
	else:
		_emit_notice("Prévia pausada: a manifestação atual termina naturalmente.")
	queue_redraw()

func _process(delta: float) -> void:
	animation_time += delta
	if preview_active:
		rhythm_clock += delta
		var interval := _rhythm_interval()
		if rhythm_clock >= interval:
			rhythm_clock = fmod(rhythm_clock, interval)
			_spawn_manifestation()
	_advance_manifestations(delta)
	_advance_dummy_reactions(delta)
	if preview_active or not active_manifestations.is_empty() or not dummy_reactions.is_empty():
		queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			_set_aim_point(event.position)
		else:
			is_dragging = false
			_emit_notice("Mira ajustada para a prévia da habilidade.")
		accept_event()
	elif event is InputEventMouseMotion and is_dragging:
		_set_aim_point(event.position)
	queue_redraw()

func _set_aim_point(point: Vector2) -> void:
	var previous_aim := aim_point
	aim_point = point
	_update_source_target_from_aim(previous_aim)

func _default_ability() -> Dictionary:
	return {
		"name": "Nova habilidade",
		"origin": "Jogador",
		"shape": "Esfera",
		"range": "Longa",
		"scale": 3,
		"motion": "Fixo",
		"rhythm": "Pulso",
		"persistence": "Breve",
		"essence": "Arcano",
		"palette": Color(0.31, 0.73, 1.0),
		"effects": [],
		"target_density": "Normal"
	}

func _ability_text(key: String, fallback: String) -> String:
	return str(ability_data.get(key, fallback))

func _ability_color() -> Color:
	var stored_color: Variant = ability_data.get("palette", Color(0.31, 0.73, 1.0))
	if stored_color is Color:
		return stored_color
	return Color(0.31, 0.73, 1.0)

func _effects() -> Array[String]:
	var result: Array[String] = []
	var raw_effects: Variant = ability_data.get("effects", [])
	if raw_effects is Array:
		for effect in raw_effects:
			result.append(str(effect))
	return result

func _shape() -> String:
	return _ability_text("shape", "Esfera").to_lower()

func _normalize_motion_name(motion_name: String) -> String:
	var normalized := motion_name.to_lower().strip_edges()
	if normalized in ["fixa", "direta", "fixo", "direto"]:
		return "reto"
	if normalized in ["curva", "ondulante"]:
		return "espiral"
	if normalized == "seguidora":
		return "perseguidor"
	if normalized in ["expansiva", "queda", "espalhada"]:
		return "retorno"
	if normalized == "orbital":
		return "órbita"
	if normalized == "retorno":
		return "retorno"
	return "reto"

func _player_position() -> Vector2:
	return Vector2(size.x * 0.17, size.y * 0.50)

func _target_positions() -> Array[Vector2]:
	var result: Array[Vector2] = []
	var count := _target_count()
	for index in range(count):
		var layout_point: Vector2 = TARGET_LAYOUT[index]
		result.append(Vector2(size.x * layout_point.x, size.y * layout_point.y))
	return result

func _target_count() -> int:
	var density: Variant = ability_data.get("target_density", "Normal")
	if density is int:
		return clampi(int(density), 0, TARGET_LAYOUT.size())
	if density is float:
		return clampi(int(density), 0, TARGET_LAYOUT.size())
	var density_str := str(density).to_lower()
	if density_str == "alvo único":
		return 1
	if density_str == "dupla":
		return 2
	if density_str == "grupo":
		return 6
	if density_str == "multidão":
		return 9
	match density_str:
		"vazio", "nenhum": return 0
		"baixo", "baixa", "isolado": return 1
		"alto", "alta", "grupo": return 6
		"enxame", "muitos": return 9
		_:
			return 3

func _range_limit() -> float:
	var board_width := size.x
	var range_name := _normalize_range_name(_ability_text("range", "Longa"))
	match range_name:
		"toque", "queima-roupa", "corpo a corpo": return board_width * 0.22
		"média", "media": return board_width * 0.42
		"longa": return board_width * 0.65
		"máxima", "maxima": return board_width * 0.78
		"fora de alcance": return 0.0
		_: return board_width * 0.65

func _normalize_range_name(range_name: String) -> String:
	var normalized := range_name.to_lower().strip_edges()
	if normalized in ["toque", "queima-roupa", "corpo a corpo"]:
		return "toque"
	if normalized in ["curta", "curto"]:
		return "média"
	if normalized in ["média", "media"]:
		return "média"
	if normalized in ["longa"]:
		return "longa"
	if normalized in ["máxima", "maxima"]:
		return "máxima"
	if normalized == "fora de alcance":
		return "fora de alcance"
	return "longa"

func _scale() -> float:
	return clampf(_normalize_scale_value(_ability_text("scale", "3")), 0.5, 5.0)

func _normalize_scale_value(scale: Variant) -> float:
	if scale is float or scale is int:
		return clampf(float(scale), 0.5, 5.0)
	var scale_str := str(scale).strip_edges().to_lower()
	if scale_str in ["delicada", "pequena", "sutil"]:
		return 0.6
	if scale_str in ["focada", "média", "media", "normal"]:
		return 1.0
	if scale_str in ["ampla", "grande"]:
		return 1.6
	if scale_str in ["monumental", "enorme", "massiva"]:
		return 3.2
	return 1.0

func _rhythm_interval() -> float:
	var rhythm_name := _ability_text("rhythm", "Pulso").to_lower()
	if rhythm_name.begins_with("lenta") or rhythm_name.begins_with("lento"):
		return 1.20
	if rhythm_name.begins_with("rápida") or rhythm_name.begins_with("rapida"):
		return 0.22
	return 0.65

func _persistence_kind() -> String:
	return _ability_text("persistence", "Breve").to_lower().split(" · ")[0]

func _persistence_duration() -> float:
	var persistence := _persistence_kind()
	if persistence == "fugaz":
		return 0.0 if _delivery() == "travessia" else 0.45
	match persistence:
		"breve": return 1.5
		"sustentada": return 3.0
		"persistente": return 5.0
		_: return 1.5

func _uses_range_lifetime() -> bool:
	return _persistence_kind() == "fugaz" and _delivery() == "travessia"

func _aim_is_in_range() -> bool:
	var range_limit := _range_limit()
	return range_limit > 0.0 and aim_point.distance_to(_range_origin()) <= range_limit

func _range_origin() -> Vector2:
	var origin_name := _ability_text("origin", "Jogador").to_lower()
	if origin_name in ["mira", "ponto de mira", "ambiente"]:
		return aim_point
	if origin_name == "ao redor" or origin_name == "ao redor do usuário":
		return _around_player_position()
	if origin_name == "no alvo":
		return _selected_source_position()
	return _player_position()

func _manifestation_origin() -> Vector2:
	var origin_name := _ability_text("origin", "Jogador").to_lower()
	if origin_name == "mira" or origin_name == "ponto de mira" or origin_name == "ambiente":
		return aim_point
	if origin_name == "ao redor" or origin_name == "ao redor do usuário":
		return _around_player_position()
	if origin_name == "no alvo":
		return _selected_source_position()
	return _player_position()

func _uses_target_origin() -> bool:
	return _ability_text("origin", "Jogador").to_lower() == "no alvo"

func _selected_source_position() -> Vector2:
	var targets := _target_positions()
	if selected_source_target >= 0 and selected_source_target < targets.size():
		return targets[selected_source_target]
	return _player_position()

func _update_source_target_from_aim(previous_point: Vector2) -> void:
	if not _uses_target_origin():
		return
	var target_index := _target_index_crossed(previous_point, aim_point)
	if target_index >= 0 and target_index != selected_source_target:
		selected_source_target = target_index
		_emit_notice("Dummy %d marcado como origem. Arraste a mira para definir a direção." % (target_index + 1))
		queue_redraw()

func _target_index_crossed(start: Vector2, end: Vector2) -> int:
	var segment := end - start
	var segment_length_squared := segment.length_squared()
	var selected_index := -1
	var latest_projection := -1.0
	var targets := _target_positions()
	for index in range(targets.size()):
		var target: Vector2 = targets[index]
		if _distance_to_segment(target, start, end) > 18.0:
			continue
		var projection := 1.0
		if segment_length_squared > 0.01:
			projection = clampf((target - start).dot(segment) / segment_length_squared, 0.0, 1.0)
		if projection >= latest_projection:
			latest_projection = projection
			selected_index = index
	return selected_index

func _around_player_position() -> Vector2:
	var offset := minf(32.0, _range_limit() * 0.1)
	return _player_position() + Vector2(0, -offset)

func _spawn_manifestation() -> void:
	if size.x <= 1.0 or size.y <= 1.0:
		return
	var range_limit := _range_limit()
	if range_limit <= 0.0:
		_emit_notice("Sem manifestação: o alcance está definido como Fora de alcance.")
		return
	var source := _manifestation_origin()
	var direction := (aim_point - source).normalized()
	if direction.length_squared() < 0.01:
		direction = (aim_point - _player_position()).normalized()
	if direction.length_squared() < 0.01:
		direction = Vector2.RIGHT
	var delivery_name := _delivery()
	var aim_distance := source.distance_to(aim_point)
	if delivery_name == "imediata" and aim_distance > range_limit:
		_emit_notice("A mira está além do alcance máximo; aproxime o ponto para executar o impacto.")
		return
	var endpoint := source + direction * minf(aim_distance, range_limit)
	var scale_value := _scale()
	var motion_name := _normalize_motion_name(_ability_text("motion", "Fixo"))
	var tracking_target_index := -1
	if motion_name == "perseguidor" and not (_uses_target_origin() and selected_source_target >= 0):
		tracking_target_index = _nearest_target_index(aim_point)
	var manifestation: Dictionary = {
			"position": source,
			"origin": source,
			"endpoint": endpoint,
			"direction": direction,
			"age": 0.0,
			"duration": _persistence_duration(),
			"speed": 145.0 + scale_value * 38.0,
			"radius": 10.0 + scale_value * 11.0,
			"shape": _shape(),
			"motion": motion_name,
			"tracking_target_index": tracking_target_index,
			"range_limit": range_limit,
			"delivery": delivery_name,
			"range_lifetime": _uses_range_lifetime(),
			"travelled_distance": 0.0,
			"reached_target": false,
			"at_range_limit": false,
			"reacted": []
		}
	active_manifestations.append(manifestation)

func _advance_manifestations(delta: float) -> void:
	for index in range(active_manifestations.size() - 1, -1, -1):
		var manifestation: Dictionary = active_manifestations[index]
		var age := float(manifestation.get("age", 0.0)) + delta
		manifestation["age"] = age
		var range_lifetime := bool(manifestation.get("range_lifetime", false))
		var duration := float(manifestation.get("duration", 1.5))
		if (range_lifetime and bool(manifestation.get("at_range_limit", false))) or (not range_lifetime and age >= duration):
			active_manifestations.remove_at(index)
			continue
		_update_manifestation_position(manifestation, delta)
		_apply_visual_reactions(manifestation)
		active_manifestations[index] = manifestation

func _update_manifestation_position(manifestation: Dictionary, delta: float) -> void:
	var position: Vector2 = manifestation.get("position", Vector2.ZERO)
	var origin: Vector2 = manifestation.get("origin", Vector2.ZERO)
	var endpoint: Vector2 = manifestation.get("endpoint", origin)
	var direction: Vector2 = manifestation.get("direction", Vector2.RIGHT)
	var age := float(manifestation.get("age", 0.0))
	var duration := maxf(float(manifestation.get("duration", 0.8)), 0.01)
	var speed := float(manifestation.get("speed", 180.0))
	var range_limit := float(manifestation.get("range_limit", 260.0))
	var motion_name := _normalize_motion_name(str(manifestation.get("motion", "fixo")))
	var delivery_type := str(manifestation.get("delivery", "projétil")).to_lower()
	var range_lifetime := bool(manifestation.get("range_lifetime", false))
	var travel_distance := minf(age * speed, range_limit)
	var at_range_limit := false
	var canvas_size := size - Vector2(1, 1)

	if motion_name in ["órbita", "orbita"]:
		var orbit_radius := minf(range_limit / TAU, 28.0 + _scale() * 9.0)
		var orbit_length := TAU * maxf(orbit_radius, 1.0)
		var orbit_distance := minf(age * speed, range_limit) if range_lifetime else fmod(age * speed, orbit_length)
		var orbit_angle := orbit_distance / maxf(orbit_radius, 1.0)
		position = origin + Vector2(cos(orbit_angle), sin(orbit_angle)) * orbit_radius
		at_range_limit = age * speed >= range_limit
	elif delivery_type == "imediata":
		position = endpoint
	elif delivery_type == "direcionada":
		position = endpoint
	elif delivery_type == "aura" or delivery_type == "invocada":
		position = origin
	elif motion_name == "espiral":
		var perpendicular := Vector2(-direction.y, direction.x)
		var wobble := sin(age * 11.0) * (8.0 + _scale() * 3.0)
		position = origin + direction * travel_distance + perpendicular * wobble
		if position.distance_to(origin) > range_limit:
			position = origin + (position - origin).normalized() * range_limit
		at_range_limit = age * speed >= range_limit
	elif motion_name == "perseguidor":
		var travelled := float(manifestation.get("travelled_distance", 0.0))
		var reached_target := bool(manifestation.get("reached_target", false))
		var target_index := int(manifestation.get("tracking_target_index", -1))
		var targets := _target_positions()
		if travelled < range_limit:
			if reached_target:
				if range_lifetime:
					var step_distance := minf(speed * delta, range_limit - travelled)
					position += direction * step_distance
					travelled += step_distance
			elif target_index >= 0 and target_index < targets.size():
				var target: Vector2 = targets[target_index]
				var to_target := target - position
				var distance_to_target := to_target.length()
				if distance_to_target <= 18.0:
					position = target
					reached_target = true
				else:
					var desired := to_target / distance_to_target
					direction = direction.lerp(desired, clampf(delta * 3.5, 0.0, 1.0)).normalized()
					var step_distance := minf(speed * delta, minf(range_limit - travelled, distance_to_target))
					position += direction * step_distance
					travelled += step_distance
					if position.distance_to(target) <= 18.0:
						position = target
						reached_target = true
			else:
				var step_distance := minf(speed * delta, range_limit - travelled)
				position += direction * step_distance
				travelled += step_distance
			manifestation["travelled_distance"] = travelled
		manifestation["reached_target"] = reached_target
		at_range_limit = travelled >= range_limit
	elif motion_name == "retorno" and not range_lifetime:
		var return_distance := sin(clampf(age / duration, 0.0, 1.0) * PI) * range_limit
		position = origin + direction * return_distance
	elif delivery_type == "travessia":
		position = origin + direction * travel_distance
		at_range_limit = age * speed >= range_limit
	else:
		position = endpoint

	position = position.clamp(Vector2.ZERO, canvas_size)
	if range_lifetime and at_range_limit and motion_name not in ["órbita", "orbita", "perseguidor"]:
		position = (origin + direction * range_limit).clamp(Vector2.ZERO, canvas_size)
	if delivery_type == "travessia" and motion_name in ["reto", "direto"]:
		manifestation["radius"] = clampf(manifestation.get("radius", 26.0), 4.0, canvas_size.x / 4.0)
	manifestation["position"] = position
	manifestation["direction"] = direction
	manifestation["at_range_limit"] = at_range_limit

func _nearest_target_index(position: Vector2) -> int:
	var nearest_index := -1
	var shortest_distance := INF
	var targets := _target_positions()
	for index in range(targets.size()):
		var distance := targets[index].distance_squared_to(position)
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_index = index
	return nearest_index

func _apply_visual_reactions(manifestation: Dictionary) -> void:
	if not bool(ability_data.get("target_reactions", true)):
		return
	var reacted: Array = []
	var stored_reacted: Variant = manifestation.get("reacted", [])
	if stored_reacted is Array:
		reacted = stored_reacted
	var targets := _target_positions()
	for index in range(targets.size()):
		if reacted.has(index):
			continue
		if _manifestation_touches(targets[index], manifestation):
			reacted.append(index)
			_apply_dummy_reaction(index)
	manifestation["reacted"] = reacted

func _manifestation_touches(target: Vector2, manifestation: Dictionary) -> bool:
	var shape_name := str(manifestation.get("shape", "esfera"))
	var position: Vector2 = manifestation.get("position", Vector2.ZERO)
	var origin: Vector2 = manifestation.get("origin", Vector2.ZERO)
	var direction: Vector2 = manifestation.get("direction", Vector2.RIGHT)
	var radius := float(manifestation.get("radius", 28.0))
	var range_limit := float(manifestation.get("range_limit", 260.0))
	match shape_name:
		"cone":
			var offset := target - origin
			var target_distance := offset.length()
			if target_distance > range_limit or target_distance <= 0.1:
				return false
			var half_angle := deg_to_rad(12.0 + _scale() * 6.0)
			return absf(direction.angle_to(offset.normalized())) <= half_angle
		"feixe", "raio":
			return _distance_to_segment(target, origin, position) <= maxf(7.0, radius * 0.22)
		"onda":
			return absf(target.distance_to(origin) - radius) <= 15.0
		"anel":
			return absf(target.distance_to(position) - radius) <= 13.0
		"parede":
			var normal := Vector2(-direction.y, direction.x)
			var local := target - position
			return absf(local.dot(normal)) <= radius and absf(local.dot(direction)) <= 13.0
		"corrente":
			return _distance_to_segment(target, origin, position) <= 14.0
		"escudo":
			return target.distance_to(origin) <= radius
		_:
			return target.distance_to(position) <= radius

func _distance_to_segment(point: Vector2, start: Vector2, end: Vector2) -> float:
	var segment := end - start
	var length_squared := segment.length_squared()
	if length_squared <= 0.01:
		return point.distance_to(start)
	var projection := clampf((point - start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(start + segment * projection)

func _apply_dummy_reaction(index: int) -> void:
	dummy_reactions[index] = {
		"age": 0.0,
		"duration": maxf(0.55, minf(_persistence_duration(), 2.8)),
		"effect": _primary_effect(),
		"color": _reaction_color(),
		"phase": animation_time
	}

func _advance_dummy_reactions(delta: float) -> void:
	for key in dummy_reactions.keys():
		var state: Dictionary = dummy_reactions[key]
		var age := float(state.get("age", 0.0)) + delta
		state["age"] = age
		if age >= float(state.get("duration", 1.0)):
			dummy_reactions.erase(key)
		else:
			dummy_reactions[key] = state

func _primary_effect() -> String:
	var selected_effects := _effects()
	if not selected_effects.is_empty():
		return selected_effects[0]
	return _ability_text("essence", "Arcano")

func _reaction_color() -> Color:
	return _element_color(_primary_effect()).lerp(_ability_color(), 0.35)

func _element_color(element_name: String) -> Color:
	var normalized := element_name.to_lower()
	if normalized.contains("fogo") or normalized.contains("queim") or normalized.contains("queimar"):
		return Color(1.0, 0.37, 0.20)
	if normalized.contains("gelo") or normalized.contains("congel") or normalized.contains("congelar"):
		return Color(0.35, 0.81, 1.0)
	if normalized.contains("raio") or normalized.contains("elet") or normalized.contains("eletriz") or normalized.contains("choque") or normalized.contains("soco"):
		return Color(0.86, 0.72, 1.0)
	if normalized.contains("vento") or normalized.contains("empurr") or normalized.contains("empurrão") or normalized.contains("puxar") or normalized.contains("puxão"):
		return Color(0.67, 0.95, 0.86)
	if normalized.contains("sombra") or normalized.contains("marca") or normalized.contains("telear") or normalized.contains("teletransp"):
		return Color(0.68, 0.47, 1.0)
	if normalized.contains("cura") or normalized.contains("proteg") or normalized.contains("luz") or normalized.contains("curar") or normalized.contains("proteger") or normalized.contains("rezar"):
		return Color(0.95, 0.83, 0.38)
	if normalized.contains("natureza") or normalized.contains("veneno") or normalized.contains("venon") or normalized.contains("veneno"):
		return Color(0.36, 0.88, 0.50)
	if normalized.contains("cegar") or normalized.contains("cegueira") or normalized.contains("silenc") or normalized.contains("silêncio") or normalized.contains("silenciar"):
		return Color(0.50, 0.50, 0.60)
	if normalized.contains("prender") or normalized.contains("grade") or normalized.contains("vetar"):
		return Color(0.40, 0.60, 0.40)
	if normalized.contains("destru") or normalized.contains("derrubar") or normalized.contains("desorient") or normalized.contains("revel") or normalized.contains("camufl") or normalized.contains("regener"):
		return Color(0.80, 0.40, 0.40)
	return _ability_color()

func _clamp_position(pos: Vector2) -> Vector2:
	return pos.clamp(Vector2.ZERO, size - Vector2(1, 1))

func _draw() -> void:
	draw_rect(_clamp_draw_rect(Rect2(Vector2.ZERO, size)), BACKGROUND)
	_draw_grid()
	_draw_range_guide()
	_draw_active_manifestations()
	_draw_dummies()
	_draw_player()
	_draw_aim_marker()

func _clamp_draw_rect(rect: Rect2) -> Rect2:
	var clamped := rect
	clamped.position = _clamp_position(rect.position)
	clamped.end = _clamp_position(rect.end)
	clamped.size = clamped.end - clamped.position
	return clamped

func _clamp_point(point: Vector2) -> Vector2:
	return _clamp_position(point)


func _draw_grid() -> void:
	for x in range(0, int(size.x) + 1, 32):
		draw_line(Vector2(x, 0), Vector2(x, size.y), GRID, 1.0)
	for y in range(0, int(size.y) + 1, 32):
		draw_line(Vector2(0, y), Vector2(size.x, y), GRID, 1.0)

func _draw_range_guide() -> void:
	var radius := _range_limit()
	if radius > 0.0:
		var center := _range_origin()
		draw_arc(center, radius, 0.0, TAU, 64, Color(0.31, 0.73, 1.0, 0.28), 1.0)
		draw_string(ThemeDB.fallback_font, center + Vector2(18, -radius + 14), "LIMITE · %s" % _ability_text("range", "Longa").to_upper(), HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Color(0.52, 0.72, 0.91, 0.8))
	else:
		draw_string(ThemeDB.fallback_font, Vector2(14, 20), "SEM ALCANCE · nenhuma manifestação será disparada", HORIZONTAL_ALIGNMENT_LEFT, size.x - 28.0, 10, OUT_OF_RANGE)

func _draw_active_manifestations() -> void:
	for manifestation in active_manifestations:
		_draw_manifestation(manifestation)

func _draw_manifestation(manifestation: Dictionary) -> void:
	var position: Vector2 = manifestation.get("position", Vector2.ZERO)
	var origin: Vector2 = manifestation.get("origin", Vector2.ZERO)
	var direction: Vector2 = manifestation.get("direction", Vector2.RIGHT)
	var duration := maxf(float(manifestation.get("duration", 0.8)), 0.01)
	var age := float(manifestation.get("age", 0.0))
	var progress := clampf(age / duration, 0.0, 1.0)
	if bool(manifestation.get("range_lifetime", false)):
		progress = clampf(age * float(manifestation.get("speed", 180.0)) / maxf(float(manifestation.get("range_limit", 1.0)), 1.0), 0.0, 1.0)
	var pulse := 0.86 + sin(animation_time * 8.0 + age * 5.0) * 0.14
	var radius := float(manifestation.get("radius", 26.0)) * pulse
	var color := _ability_color()
	var fill := Color(color.r, color.g, color.b, 0.16 * (1.0 - progress))
	var outline := Color(color.r, color.g, color.b, 0.85 * (1.0 - progress * 0.42))
	var shape_name := str(manifestation.get("shape", "esfera"))
	match shape_name:
		"cone":
			var cone_length := minf(float(manifestation.get("range_limit", 260.0)), maxf(56.0, position.distance_to(origin) + 68.0))
			var half_angle := deg_to_rad(12.0 + _scale() * 6.0)
			var edge_a := origin + direction.rotated(-half_angle) * cone_length
			var edge_b := origin + direction.rotated(half_angle) * cone_length
			draw_colored_polygon(PackedVector2Array([origin, edge_a, edge_b]), fill)
			draw_line(origin, edge_a, outline, 1.5)
			draw_line(origin, edge_b, outline, 1.5)
		"feixe", "raio":
			var beam_end := position
			if str(manifestation.get("delivery", "")) == "direcionada":
				beam_end = manifestation.get("endpoint", position)
			draw_line(origin, beam_end, Color(color.r, color.g, color.b, 0.18), radius * 0.34)
			draw_line(origin, beam_end, outline, maxf(2.0, radius * 0.10))
		"onda":
			var wave_radius := clampf(progress * float(manifestation.get("range_limit", 260.0)), 4.0, float(manifestation.get("range_limit", 260.0)))
			draw_arc(origin, wave_radius, 0.0, TAU, 48, outline, 2.0)
		"anel":
			draw_arc(position, radius, 0.0, TAU, 32, outline, 2.0)
			draw_arc(position, maxf(4.0, radius - 7.0), 0.0, TAU, 32, Color(color.r, color.g, color.b, 0.28), 1.0)
		"parede":
			_draw_wall(position, direction, radius, fill, outline)
		"corrente":
			_draw_chain(origin, position, color, outline)
		"escudo":
			draw_arc(origin, radius, -PI * 0.20, PI * 1.20, 32, outline, 2.4)
			draw_arc(origin, maxf(6.0, radius - 7.0), -PI * 0.20, PI * 1.20, 32, Color(color.r, color.g, color.b, 0.26), 1.0)
		"rajada":
			_draw_burst(position, radius, fill, outline)
		"corte":
			_draw_cut(position, direction, radius, fill, outline)
		"selo":
			_draw_seal(position, radius, fill, outline)
		"invocação":
			_draw_summon(position, radius, fill, outline)
		_:
			draw_circle(position, radius, fill, true)
			draw_arc(position, radius, 0.0, TAU, 32, outline, 2.0)
	manifestation["position"] = position
	manifestation["direction"] = direction

func _draw_cut(position: Vector2, direction: Vector2, radius: float, fill: Color, outline: Color) -> void:
	var normal := direction.rotated(PI * 0.5) * radius * 0.6
	var end := position + direction * radius * 0.8
	var side := normal * radius * 0.6
	var points := PackedVector2Array([
		position + side,
		position - side,
		end + side,
		end - side
	])
	draw_colored_polygon(points, fill)
	draw_polyline([position, end], outline, 1.5, true)

func _draw_seal(center: Vector2, radius: float, fill: Color, outline: Color) -> void:
	var points := PackedVector2Array()
	for index in range(6):
		var angle := TAU * float(index) / 6.0
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	draw_polyline(points, outline, 1.5, true)
	draw_colored_polygon(points, fill)
	draw_circle(center, radius * 0.3, fill)

func _draw_summon(center: Vector2, radius: float, fill: Color, outline: Color) -> void:
	_draw_seal(center + Vector2(0, -radius * 0.3), radius * 0.5, fill, outline)
	draw_circle(center, radius * 0.2, fill)
	draw_line(center, center + Vector2(0, radius * 0.6), outline, 1.2)

func _draw_burst(position: Vector2, radius: float, fill: Color, outline: Color) -> void:
	var points := PackedVector2Array()
	for index in range(12):
		var angle := TAU * float(index) / 12.0
		var alternating_radius := radius if index % 2 == 0 else radius * 0.58
		points.append(position + Vector2(cos(angle), sin(angle)) * alternating_radius)
	draw_colored_polygon(points, fill)
	draw_polyline(points, outline, 1.7, true)

func _draw_wall(position: Vector2, direction: Vector2, half_length: float, fill: Color, outline: Color) -> void:
	var normal := Vector2(-direction.y, direction.x)
	var thickness := 7.0 + _scale() * 1.5
	var points := PackedVector2Array([
		position + normal * half_length + direction * thickness,
		position - normal * half_length + direction * thickness,
		position - normal * half_length - direction * thickness,
		position + normal * half_length - direction * thickness
	])
	draw_colored_polygon(points, fill)
	draw_polyline(points, outline, 1.5, true)

func _draw_chain(origin: Vector2, end: Vector2, color: Color, outline: Color) -> void:
	var distance := origin.distance_to(end)
	var links := int(max(1, int(distance / 18.0)))
	for index in range(links + 1):
		var ratio := float(index) / float(links)
		var point := origin.lerp(end, ratio)
		draw_circle(point, 4.0, Color(color.r, color.g, color.b, 0.28), true)
		draw_arc(point, 4.0, 0.0, TAU, 12, outline, 1.0)

func _draw_dummies() -> void:
	var targets := _target_positions()
	for index in range(targets.size()):
		var point: Vector2 = targets[index]
		var reaction: Dictionary = {}
		if dummy_reactions.has(index):
			reaction = dummy_reactions[index]
		_draw_dummy(point, reaction)
		if _uses_target_origin() and index == selected_source_target:
			draw_arc(point, 19.0, 0.0, TAU, 28, Color(0.55, 0.90, 1.0, 0.92), 2.0)
			draw_string(ThemeDB.fallback_font, point + Vector2(-22, -25), "ORIGEM", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Color(0.72, 0.94, 1.0))

func _draw_dummy(point: Vector2, reaction: Dictionary) -> void:
	var reaction_color := DUMMY
	var reaction_alpha := 0.0
	if not reaction.is_empty():
		var duration := maxf(float(reaction.get("duration", 1.0)), 0.01)
		var age := float(reaction.get("age", 0.0))
		reaction_alpha = clampf(1.0 - age / duration, 0.0, 1.0)
		var stored_color: Variant = reaction.get("color", DUMMY)
		if stored_color is Color:
			reaction_color = stored_color
		var pulse := 9.0 + sin(animation_time * 12.0 + float(reaction.get("phase", 0.0))) * 2.0
		draw_circle(point, pulse, Color(reaction_color.r, reaction_color.g, reaction_color.b, reaction_alpha * 0.20), true)
		draw_arc(point, pulse + 3.0, 0.0, TAU, 24, Color(reaction_color.r, reaction_color.g, reaction_color.b, reaction_alpha * 0.72), 1.2)
		_draw_effect_marker(point, str(reaction.get("effect", "")), reaction_color, reaction_alpha)
	var body_color := DUMMY.lerp(reaction_color, reaction_alpha * 0.45)
	draw_rect(Rect2(point + Vector2(-5, -5), Vector2(10, 12)), body_color)
	draw_rect(Rect2(point + Vector2(-4, -12), Vector2(8, 7)), Color(0.97, 0.49, 0.52))
	draw_rect(Rect2(point + Vector2(-9, -3), Vector2(4, 10)), body_color)
	draw_rect(Rect2(point + Vector2(5, -3), Vector2(4, 10)), body_color)
	draw_string(ThemeDB.fallback_font, point + Vector2(-21, 20), "DUMMY", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Color(0.88, 0.61, 0.64))

func _draw_effect_marker(point: Vector2, effect_name: String, color: Color, alpha: float) -> void:
	var normalized := effect_name.to_lower()
	if normalized.contains("fogo") or normalized.contains("queim") or normalized.contains("queimar"):
		for index in range(3):
			var flame_x := point.x - 7.0 + float(index) * 7.0
			var flicker := sin(animation_time * 14.0 + float(index)) * 3.0
			draw_rect(Rect2(Vector2(flame_x, point.y - 23.0 - flicker), Vector2(4.0, 8.0 + flicker)), Color(color.r, color.g, color.b, alpha))
	elif normalized.contains("gelo") or normalized.contains("congel"):
		for index in range(3):
			var shard_point := point + Vector2(-9.0 + float(index) * 9.0, -19.0)
			var shard := PackedVector2Array([shard_point + Vector2(0, -5), shard_point + Vector2(4, 3), shard_point + Vector2(-4, 3)])
			draw_colored_polygon(shard, Color(color.r, color.g, color.b, alpha))
	elif normalized.contains("raio") or normalized.contains("elet"):
		var points := PackedVector2Array([point + Vector2(-8, -15), point + Vector2(-2, -21), point + Vector2(1, -14), point + Vector2(8, -22)])
		draw_polyline(points, Color(color.r, color.g, color.b, alpha), 1.8, true)
	elif normalized.contains("cura") or normalized.contains("proteg") or normalized.contains("luz"):
		draw_arc(point + Vector2(0, -6), 12.0, 0.0, TAU, 20, Color(color.r, color.g, color.b, alpha), 1.6)
	elif normalized.contains("sombra") or normalized.contains("marca"):
		draw_circle(point + Vector2(0, -18), 5.0, Color(color.r, color.g, color.b, alpha * 0.72), true)
	elif normalized.contains("cegar") or normalized.contains("cegueira") or normalized.contains("silenc"):
		# Blindness/effect: zigzag line across the target
		var points := PackedVector2Array()
		for i in range(9):
			var x := point.x - 8.0 + float(i) * 2.0
			var y := point.y - 20.0 + float(i % 2) * 6.0
			points.append(Vector2(x, y))
		draw_polyline(points, Color(color.r, color.g, color.b, alpha), 1.8, true)
	elif normalized.contains("prender") or normalized.contains("grade") or normalized.contains("vetar"):
		# Binding: geometric grid overlay
		for i in range(4):
			var x1 := point.x - 12.0 + float(i) * 6.0
			var y1 := point.y - 12.0
			var x2 := point.x - 12.0
			var y2 := point.y - 12.0 + float(i) * 6.0
			draw_line(Vector2(x1, y1), Vector2(x2, y2), Color(color.r, color.g, color.b, alpha * 0.6), 1.2)
	elif normalized.contains("empurr") or normalized.contains("empurrão") or normalized.contains("puxar") or normalized.contains("puxão"):
		# Push/pull: arrow with motion indicator
		var angle := PI * 0.25
		var points := PackedVector2Array([point + Vector2(-6, -8), point + Vector2(6, -8), point + Vector2(3, -2)])
		draw_polyline(points, Color(color.r, color.g, color.b, alpha), 1.6, true)
		draw_line(point + Vector2(3, -2), point + Vector2(10, -14), Color(color.r, color.g, color.b, alpha * 0.5), 1.0)
	elif normalized.contains("teletransp") or normalized.contains("telear") or normalized.contains("teleport"):
		# Teleport: sparkle/star effect
		for i in range(8):
			var angle := float(i) * TAU / 8.0
			var dist := 10.0 + sin(animation_time * 8.0 + float(i)) * 3.0
			var x := point.x + cos(angle) * dist
			var y := point.y - 6.0 + sin(angle) * dist
			draw_circle(Vector2(x, y), 2.5, Color(color.r, color.g, color.b, alpha * 0.5), true)
	elif normalized.contains("regener"):
		# Regeneration: pulsing glow
		var pulse := 1.0 + sin(animation_time * 6.0) * 0.3
		draw_arc(point, 10.0 * pulse, 0.0, TAU, 16, Color(color.r, color.g, color.b, alpha * 0.15), 1.0)
		draw_circle(point, 3.0 + sin(animation_time * 6.0) * 1.0, Color(color.r, color.g, color.b, alpha), 1.2)
	elif normalized.contains("desorient"):
		# Disorient: spiral/blur lines
		for i in range(5):
			var radius := 5.0 + float(i) * 4.0
			draw_arc(point, radius, -PI * 0.5, PI * 0.5, 8, Color(color.r, color.g, color.b, alpha * 0.3), 1.0)
		draw_line(point, point + Vector2(0, -16), Color(color.r, color.g, color.b, alpha * 0.6), 1.2)
	elif normalized.contains("revel"):
		# Reveal: spotlight beam
		var points := PackedVector2Array([point + Vector2(-4, -12), point + Vector2(-1, -20), point + Vector2(6, -8)])
		draw_polyline(points, Color(color.r, color.g, color.b, alpha), 1.5, true)
		draw_arc(point, 12.0, 0.0, TAU, 12, Color(color.r, color.g, color.b, alpha * 0.12), 1.0)
	elif normalized.contains("camufl"):
		# Camouflage: pattern overlay
		for i in range(6):
			for j in range(4):
				var x := point.x - 14.0 + float(i) * 5.0 + float(j) * 5.0
				var y := point.y - 8.0 + float(i + j) * 3.0
				draw_circle(Vector2(x, y), 1.5, Color(color.r, color.g, color.b, alpha * 0.3), true)
	else:
			# Default for any unhandled effect
			draw_line(point + Vector2(-7, -18), point + Vector2(7, -18), Color(color.r, color.g, color.b, alpha), 1.4)

func _draw_player() -> void:
	var point := _player_position()
	draw_rect(Rect2(point + Vector2(-6, -7), Vector2(12, 15)), PLAYER)
	draw_rect(Rect2(point + Vector2(-4, -13), Vector2(8, 6)), Color(0.57, 0.86, 1.0))
	draw_rect(Rect2(point + Vector2(-10, -4), Vector2(4, 8)), PLAYER)
	draw_rect(Rect2(point + Vector2(6, -4), Vector2(4, 8)), PLAYER)
	draw_string(ThemeDB.fallback_font, point + Vector2(-18, 24), "JOGADOR", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Color(0.61, 0.83, 1.0))

func _draw_aim_marker() -> void:
	var marker_color := Color(0.95, 0.91, 0.68, 0.9) if _aim_is_in_range() else OUT_OF_RANGE
	draw_line(aim_point + Vector2(-7, 0), aim_point + Vector2(7, 0), marker_color, 1.5)
	draw_line(aim_point + Vector2(0, -7), aim_point + Vector2(0, 7), marker_color, 1.5)
	if preview_active:
		draw_arc(aim_point, 11.0 + sin(animation_time * 5.0) * 2.0, 0.0, TAU, 20, Color(marker_color.r, marker_color.g, marker_color.b, 0.35), 1.0)

func _ability_summary() -> String:
	return "%s · %s de %s · %s" % [
		_ability_text("name", "Nova habilidade"),
		_ability_text("shape", "Esfera"),
		_ability_text("essence", "Arcano"),
		_ability_text("motion", "Fixo")
	]

func _emit_notice(text: String) -> void:
	if text == last_notice:
		return
	last_notice = text
	preview_changed.emit(text)

func _delivery() -> String:
	var delivery := _ability_text("delivery", "Projétil").to_lower()
	if delivery in ["impacto imediato", "instantanea", "instantânea"]:
		return "imediata"
	if delivery in ["projétil", "projeto"]:
		return "travessia"
	if delivery in ["canalizada", "canalizado"]:
		return "direcionada"
	if delivery == "aura":
		return "aura"
	if delivery in ["invocada", "invocação"]:
		return "invocada"
	return "travessia"
