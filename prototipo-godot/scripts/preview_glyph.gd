extends Control

const C_MUTED := Color(0.35, 0.42, 0.53)
const C_GUIDE := Color(0.50, 0.60, 0.74, 0.44)
const C_PLAYER := Color(0.31, 0.73, 1.0)

var preview_kind := "shape"
var preview_value := "Cone"
var preview_color := Color(0.30, 0.76, 1.00)
var preview_scale := "Média"
var effect_names: Array[String] = []

func set_preview(kind: String, value: String, tint: Color, scale_level: String, effects: Array[String] = []) -> void:
	preview_kind = kind
	preview_value = value
	preview_color = tint
	preview_scale = scale_level
	effect_names = effects.duplicate()
	queue_redraw()

func _draw() -> void:
	var center: Vector2 = size * 0.5
	match preview_kind:
		"shape": _draw_shape(center, preview_color)
		"space": _draw_space(center, preview_color)
		"motion": _draw_motion(center, preview_color)
		"essence": _draw_essence(center, preview_color)
		"effects": _draw_effects(center)
		_: _draw_fallback(center)

func _draw_shape(center: Vector2, color: Color) -> void:
	var scale: float = _scale_factor()
	var tint := Color(color.r, color.g, color.b, 0.68)
	match preview_value:
		"Cone":
			draw_colored_polygon(PackedVector2Array([center + Vector2(-22, 0) * scale, center + Vector2(18, -17) * scale, center + Vector2(18, 17) * scale]), tint)
		"Feixe":
			draw_line(center + Vector2(-25, 0) * scale, center + Vector2(25, 0) * scale, color, 5.0 * scale)
		"Projétil":
			draw_circle(center + Vector2(8, 0) * scale, 8.0 * scale, tint)
			draw_line(center + Vector2(-24, 0) * scale, center + Vector2(0, 0) * scale, color, 2.0)
		"Esfera":
			draw_circle(center, 14.0 * scale, tint)
			draw_arc(center, 14.0 * scale, 0.0, TAU, 24, color, 1.5)
		"Rajada":
			_draw_star(center, 16.0 * scale, color)
		"Corte":
			draw_arc(center + Vector2(-7, 3), 20.0 * scale, -0.85, 0.70, 18, color, 4.0 * scale)
		"Onda":
			for offset in [0.0, 8.0, 16.0]:
				draw_arc(center + Vector2(-18, 0), (9.0 + offset) * scale, -0.80, 0.80, 14, Color(color.r, color.g, color.b, 0.9 - offset * 0.025), 1.5)
		"Anel":
			draw_arc(center, 17.0 * scale, 0.0, TAU, 26, color, 3.0)
		"Parede":
			draw_rect(Rect2(center + Vector2(-8, -20) * scale, Vector2(16, 40) * scale), tint)
			draw_rect(Rect2(center + Vector2(-8, -20) * scale, Vector2(16, 40) * scale), color, false, 1.5)
		"Campo":
			draw_circle(center, 21.0 * scale, Color(color.r, color.g, color.b, 0.18), true)
			draw_arc(center, 21.0 * scale, 0.0, TAU, 32, color, 1.5)
		"Chuva":
			for x in [-14.0, 0.0, 14.0]:
				draw_line(center + Vector2(x, -20) * scale, center + Vector2(x - 5, 17) * scale, color, 2.0)
		"Corrente":
			for x in [-18.0, -6.0, 6.0, 18.0]:
				draw_circle(center + Vector2(x, 0) * scale, 5.0 * scale, Color(color.r, color.g, color.b, 0.25), true)
				draw_arc(center + Vector2(x, 0) * scale, 5.0 * scale, 0.0, TAU, 12, color, 1.5)
		"Selo":
			_draw_seal(center, 18.0 * scale, color)
		"Invocação":
			_draw_summon(center, 18.0 * scale, color)
		_:
			_draw_fallback(center)

func _draw_space(center: Vector2, color: Color) -> void:
	var origin := center + Vector2(-25, 0)
	var distance_ratio := 0.0
	match preview_value.to_lower():
		"queima-roupa", "toque":
			distance_ratio = 0.28
		"média", "media":
			distance_ratio = 0.48
		"longa":
			distance_ratio = 0.72
		"máxima", "maxima":
			distance_ratio = 0.96
	if distance_ratio > 0.0:
		var endpoint := origin + Vector2(50.0 * distance_ratio, 0)
		draw_line(origin, endpoint, C_GUIDE, 1.0)
		draw_line(origin, endpoint, color, 2.5)
		draw_circle(endpoint, 4.0, color)
	else:
		draw_line(origin + Vector2(13, -7), origin + Vector2(27, 7), color, 2.0)
		draw_line(origin + Vector2(27, -7), origin + Vector2(13, 7), color, 2.0)
	draw_circle(origin, 4.0, C_PLAYER)

func _draw_motion(center: Vector2, color: Color) -> void:
	match preview_value:
		"Instantânea", "Instantâneo":
			_draw_star(center, 15.0, color)
		"Pulsante", "Pulso":
			for radius in [7.0, 14.0, 21.0]:
				draw_arc(center, radius, 0.0, TAU, 22, Color(color.r, color.g, color.b, 0.84 - radius * 0.018), 1.5)
		"Contínua", "Contínuo", "Canalizada":
			draw_line(center + Vector2(-25, 0), center + Vector2(25, 0), color, 4.0)
			for x in [-16.0, 0.0, 16.0]:
				draw_circle(center + Vector2(x, 0), 3.0, Color.WHITE)
		"Projetada", "Direta":
			_draw_arrow(center + Vector2(-24, 0), center + Vector2(25, 0), color)
		"Expansiva", "Expansão":
			for radius in [7.0, 15.0, 23.0]:
				draw_arc(center, radius, -0.95, 0.95, 16, color, 1.5)
		"Orbital", "Órbita":
			draw_arc(center, 19.0, 0.0, TAU, 24, color, 1.5)
			draw_circle(center + Vector2(18, -5), 4.0, color)
			draw_circle(center, 5.0, C_PLAYER)
		"Retorno", "Retornante":
			draw_arc(center, 21.0, -0.55, PI + 0.55, 22, color, 2.0)
			_draw_arrow(center + Vector2(-18, 9), center + Vector2(-24, 1), color)
		"Oscilante", "Serpenteante", "Ondulante":
			var points := PackedVector2Array([center + Vector2(-25, 0), center + Vector2(-13, -11), center + Vector2(0, 10), center + Vector2(13, -11), center + Vector2(25, 0)])
			draw_polyline(points, color, 2.5, true)
		"Seguidora":
			_draw_arrow(center + Vector2(-24, 0), center + Vector2(14, 0), color)
			draw_arc(center + Vector2(16, 0), 9.0, -PI * 0.6, PI * 0.6, 14, color, 1.5)
		_:
			_draw_arrow(center + Vector2(-22, 0), center + Vector2(22, 0), color)

func _draw_essence(center: Vector2, color: Color) -> void:
	var soft := Color(color.r, color.g, color.b, 0.26)
	draw_circle(center, 18.0, soft)
	match preview_value:
		"Fogo", "Chama":
			_draw_flame(center, color)
		"Gelo", "Geada":
			_draw_crystal(center, color)
		"Elétrico", "Raio":
			_draw_lightning(center, color)
		"Sombra", "Trevas":
			draw_circle(center + Vector2(-5, 0), 13.0, Color(0.08, 0.06, 0.16, 0.9))
			draw_arc(center, 16.0, -1.15, 1.15, 18, color, 2.0)
		"Luz":
			for angle in [0.0, PI * 0.5, PI, PI * 1.5]:
				draw_line(center + Vector2.from_angle(angle) * 8.0, center + Vector2.from_angle(angle) * 22.0, color, 2.0)
			draw_circle(center, 8.0, color)
		"Vento", "Ar":
			for offset in [-8.0, 0.0, 8.0]:
				draw_arc(center + Vector2(-7, offset), 15.0, -0.65, 0.75, 14, color, 1.5)
		"Água":
			for offset in [-7.0, 7.0]:
				draw_arc(center + Vector2(0, offset), 13.0, 0.10, PI - 0.10, 14, color, 1.5)
		"Terra", "Pedra":
			draw_colored_polygon(PackedVector2Array([center + Vector2(-15, 10), center + Vector2(-8, -11), center + Vector2(12, -8), center + Vector2(16, 11)]), color)
		"Natureza", "Planta":
			draw_line(center + Vector2(0, 17), center + Vector2(0, -16), color, 2.0)
			draw_circle(center + Vector2(-8, -6), 7.0, color)
			draw_circle(center + Vector2(8, -11), 7.0, color)
		"Vazio", "Void":
			draw_circle(center, 13.0, Color(0.02, 0.02, 0.06))
			draw_arc(center, 17.0, 0.0, TAU, 24, color, 2.0)
		"Arcano", "Arcana":
			_draw_seal(center, 16.0, color)
		_:
			draw_arc(center, 15.0, 0.0, TAU, 22, color, 2.0)
			draw_circle(center, 5.0, color)

func _draw_effects(center: Vector2) -> void:
	if effect_names.is_empty():
		draw_circle(center, 10.0, C_MUTED)
		return
	var visible_count: int = mini(effect_names.size(), 5)
	var start: float = -float(visible_count - 1) * 10.0
	for index in range(visible_count):
		var point := center + Vector2(start + float(index) * 20.0, 0)
		var color := _effect_color(effect_names[index])
		draw_circle(point, 7.0, Color(color.r, color.g, color.b, 0.35))
		draw_arc(point, 7.0, 0.0, TAU, 14, color, 1.5)

func _draw_fallback(center: Vector2) -> void:
	draw_arc(center, 14.0, 0.0, TAU, 20, preview_color, 1.5)
	draw_line(center + Vector2(-8, 0), center + Vector2(8, 0), preview_color, 1.5)

func _draw_star(center: Vector2, radius: float, color: Color) -> void:
	var points := PackedVector2Array()
	for index in range(8):
		var angle: float = float(index) * TAU / 8.0 - PI * 0.5
		var point_radius: float = radius if index % 2 == 0 else radius * 0.45
		points.append(center + Vector2.from_angle(angle) * point_radius)
	draw_colored_polygon(points, Color(color.r, color.g, color.b, 0.48))
	draw_polyline(PackedVector2Array([points[0], points[1], points[2], points[3], points[4], points[5], points[6], points[7], points[0]]), color, 1.5, true)

func _draw_seal(center: Vector2, radius: float, color: Color) -> void:
	var points := PackedVector2Array()
	for index in range(6):
		var angle: float = float(index) * TAU / 6.0 - PI * 0.5
		points.append(center + Vector2.from_angle(angle) * radius)
	draw_polyline(PackedVector2Array([points[0], points[1], points[2], points[3], points[4], points[5], points[0]]), color, 1.5, true)
	draw_arc(center, radius * 0.62, 0.0, TAU, 18, color, 1.0)

func _draw_summon(center: Vector2, radius: float, color: Color) -> void:
	_draw_seal(center + Vector2(0, 9), radius, color)
	draw_circle(center + Vector2(0, -10), 5.0, color)
	draw_rect(Rect2(center + Vector2(-6, -4), Vector2(12, 15)), Color(color.r, color.g, color.b, 0.62))

func _draw_arrow(from: Vector2, to: Vector2, color: Color) -> void:
	var direction := (to - from).normalized()
	var side := direction.rotated(PI * 0.5)
	draw_line(from, to, color, 2.5)
	draw_colored_polygon(PackedVector2Array([to, to - direction * 9.0 + side * 4.0, to - direction * 9.0 - side * 4.0]), color)

func _draw_flame(center: Vector2, color: Color) -> void:
	draw_colored_polygon(PackedVector2Array([center + Vector2(-11, 13), center + Vector2(-7, -4), center + Vector2(1, -20), center + Vector2(13, 4), center + Vector2(7, 14)]), color)
	draw_circle(center + Vector2(0, 7), 7.0, Color(1.0, 0.78, 0.35, 0.9))

func _draw_crystal(center: Vector2, color: Color) -> void:
	draw_colored_polygon(PackedVector2Array([center + Vector2(0, -21), center + Vector2(13, -1), center + Vector2(0, 20), center + Vector2(-13, -1)]), color)
	draw_line(center + Vector2(0, -18), center + Vector2(0, 16), Color.WHITE, 1.0)

func _draw_lightning(center: Vector2, color: Color) -> void:
	draw_colored_polygon(PackedVector2Array([center + Vector2(-3, -21), center + Vector2(10, -21), center + Vector2(2, -3), center + Vector2(13, -3), center + Vector2(-8, 22), center + Vector2(-2, 3), center + Vector2(-12, 3)]), color)

func _scale_factor() -> float:
	match preview_scale:
		"Delicada", "Compacta", "Pequena", "Sutil": return 0.72
		"Focada", "Média", "Normal": return 1.0
		"Ampla", "Grande": return 1.22
		"Monumental", "Massiva", "Enorme": return 1.45
		_: return 1.0

func _effect_color(effect_name: String) -> Color:
	match effect_name:
		"Queimadura", "Queimar", "Fogo": return Color(1.0, 0.37, 0.20)
		"Congelamento", "Congelar", "Gelo": return Color(0.35, 0.81, 1.0)
		"Choque", "Eletrificar", "Elétrico", "Raio": return Color(0.92, 0.80, 0.24)
		"Empurrar", "Empurrão", "Puxar", "Puxão": return Color(0.58, 0.82, 1.0)
		"Curar", "Cura", "Regenerar", "Regeneração": return Color(0.31, 0.90, 0.56)
		"Proteger", "Escudo", "Barreira": return Color(0.43, 0.67, 1.0)
		"Prender", "Ligação", "Prisão": return Color(0.79, 0.57, 1.0)
		"Silenciar", "Silêncio", "Cegar", "Cegueira": return Color(0.76, 0.65, 0.91)
		"Marcar", "Marca": return Color(1.0, 0.66, 0.31)
		"Teleportar", "Desorientar", "Revelar", "Camuflar": return Color(0.68, 0.47, 1.0)
		_: return preview_color
