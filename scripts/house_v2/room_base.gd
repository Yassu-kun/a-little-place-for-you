extends RefCounted

var title_zh: String = "房间"
var title_en: String = "Room"
var spawn_point: Vector2 = Vector2(470, 320)

var assets: RefCounted


# ============================================================
# STYLE / BASIC HELPERS
# ============================================================

func make_panel_style(bg: Color, border: Color, border_width: int = 2, corner_radius: int = 4) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(corner_radius)
	return style


func add_rect(stage: Control, pos: Vector2, size: Vector2, color: Color, z: int = 0, node_name: String = "") -> ColorRect:
	var rect: ColorRect = ColorRect.new()
	rect.name = node_name
	rect.position = pos
	rect.size = size
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.z_index = z
	stage.add_child(rect)
	return rect


func add_panel(stage: Control, pos: Vector2, size: Vector2, bg: Color, border: Color, z: int = 0, corner_radius: int = 4, node_name: String = "") -> Panel:
	var panel: Panel = Panel.new()
	panel.name = node_name
	panel.position = pos
	panel.size = size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = z
	panel.add_theme_stylebox_override("panel", make_panel_style(bg, border, 2, corner_radius))
	stage.add_child(panel)
	return panel


func add_label(stage: Control, pos: Vector2, size: Vector2, text: String, font_size: int = 16, z: int = 100) -> Label:
	var label: Label = Label.new()
	label.position = pos
	label.size = size
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.z_index = z
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", Color(0.08, 0.05, 0.04, 0.95))
	label.add_theme_constant_override("outline_size", 3)
	stage.add_child(label)
	return label


func register_hotspot(
	register_callback: Callable,
	id: String,
	rect: Rect2,
	zh: String,
	en: String,
	action: String,
	data: Dictionary = {}
) -> void:
	register_callback.call(id, rect, zh, en, action, data)


# ============================================================
# TEXTURE HELPERS
# ============================================================

func asset_texture(name: String) -> Texture2D:
	if assets == null:
		return null
	
	var value: Variant = assets.get(name)
	
	if value is Texture2D:
		return value as Texture2D
	
	return null


func make_atlas_texture(texture: Texture2D, region: Rect2) -> AtlasTexture:
	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = region
	return atlas


func add_asset_region(
	stage: Control,
	node_name: String,
	texture_name: String,
	region: Rect2,
	pos: Vector2,
	size: Vector2,
	z: int = 40,
	modulate_color: Color = Color.WHITE
) -> TextureRect:
	var texture: Texture2D = asset_texture(texture_name)
	var tr: TextureRect = TextureRect.new()
	tr.name = node_name
	tr.position = pos
	tr.size = size
	tr.z_index = z
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tr.stretch_mode = TextureRect.STRETCH_SCALE
	tr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	tr.modulate = modulate_color
	
	if texture != null:
		tr.texture = make_atlas_texture(texture, region)
	else:
		tr.visible = false
	
	stage.add_child(tr)
	return tr


func has_asset(name: String) -> bool:
	return asset_texture(name) != null


func add_shadow(stage: Control, pos: Vector2, size: Vector2, z: int = 20) -> void:
	add_panel(stage, pos, size, Color(0, 0, 0, 0.12), Color(1, 1, 1, 0.0), z, 8)


# ============================================================
# ROOM DECORATION HELPERS
# ============================================================

func draw_window(stage: Control, pos: Vector2, size: Vector2, night: bool) -> void:
	var region: Rect2 = Rect2(208, 17, 48, 30)
	if night:
		region = Rect2(208, 49, 48, 30)
	add_shadow(stage, pos + Vector2(4, 5), size, 25)
	add_asset_region(stage, "WindowTexture", "lrk_doors_windows_stairs", region, pos, size, 45)
	if not has_asset("lrk_doors_windows_stairs"):
		var glass_color: Color = Color("#A8D8F2")
		if night:
			glass_color = Color("#182D55")
		add_panel(stage, pos, size, Color("#6A4638"), Color("#2D1C15"), 44, 3)
		add_rect(stage, pos + Vector2(6, 6), size - Vector2(12, 12), glass_color, 45)
		add_rect(stage, pos + Vector2(size.x / 2.0 - 2, 6), Vector2(4, size.y - 12), Color("#6A4638").darkened(0.15), 46)
		add_rect(stage, pos + Vector2(6, size.y / 2.0 - 2), Vector2(size.x - 12, 4), Color("#6A4638").darkened(0.15), 46)
	add_panel(stage, pos, size, Color(1, 1, 1, 0.0), Color("#5A3A30"), 46, 3)
	add_rect(stage, pos + Vector2(-2, size.y - 4), Vector2(size.x + 4, 6), Color("#5A3A30"), 47)
	if night:
		add_rect(stage, pos + Vector2(18, 18), Vector2(4, 4), Color("#FFF1A8"), 48)
		add_rect(stage, pos + Vector2(46, 28), Vector2(3, 3), Color("#FFF1A8"), 48)
	else:
		add_rect(stage, pos + Vector2(10, 10), Vector2(16, 8), Color(1, 1, 1, 0.18), 48)

func draw_door(stage: Control, pos: Vector2, size: Vector2, label_text: String = "") -> void:
	add_shadow(stage, pos + Vector2(4, 6), size, 28)
	add_asset_region(stage, "DoorTextureBase", "lrk_doors_windows_stairs", Rect2(113, 16, 30, 48), pos, size, 39, Color(1, 1, 1, 0.42))
	add_panel(stage, pos, size, Color("#5C3B2C"), Color("#2D1A13"), 40, 3)
	add_panel(stage, pos + Vector2(4, 4), size - Vector2(8, 8), Color("#8A5D45"), Color("#654332"), 41, 3)
	add_rect(stage, pos + Vector2(8, 12), Vector2(size.x - 16, 3), Color("#B98967"), 42)
	add_rect(stage, pos + Vector2(8, size.y * 0.52), Vector2(size.x - 16, 3), Color("#B98967"), 42)
	add_rect(stage, pos + Vector2(size.x - 10, size.y * 0.58), Vector2(4, 4), Color("#E6CB7D"), 43)
	if label_text != "":
		add_label(stage, pos + Vector2(-44, size.y + 4), Vector2(size.x + 88, 22), label_text, 13, 90)

func draw_bed(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_shadow(stage, pos + Vector2(8, 10), size, 28)
	
	add_asset_region(
		stage,
		"BedTexture",
		"bedroom_beds",
		Rect2(64, 24, 48, 56),
		pos,
		size,
		42
	)
	
	if not has_asset("bedroom_beds"):
		add_panel(stage, pos, size, Color("#6D4636"), Color("#3C251C"), 35, 4)
		add_panel(stage, pos + Vector2(8, 8), size - Vector2(16, 16), Color("#E6D6CC"), Color("#8E6A5B"), 36, 4)
		add_rect(stage, pos + Vector2(18, 34), Vector2(size.x - 36, size.y - 48), Color("#C9573E"), 37)


func draw_nightstand(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"NightstandTexture",
		"bedroom_wardrobes",
		Rect2(160, 52, 32, 20),
		pos,
		size,
		43
	)
	
	if not has_asset("bedroom_wardrobes"):
		add_panel(stage, pos, size, Color("#8B6047"), Color("#4A2F22"), 35, 4)
	
	add_asset_region(
		stage,
		"SmallLampTexture",
		"bedroom_decorations",
		Rect2(98, 53, 12, 19),
		pos + Vector2(size.x * 0.25, -26),
		Vector2(28, 42),
		48
	)


func draw_photo_wall(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"PhotoFrameTexture",
		"bedroom_decorations",
		Rect2(132, 19, 40, 26),
		pos + Vector2(22, 0),
		Vector2(86, 58),
		45
	)
	
	if not has_asset("bedroom_decorations"):
		for i in range(3):
			var frame_pos: Vector2 = pos + Vector2(8 + i * 40, 8)
			add_panel(stage, frame_pos, Vector2(32, 42), Color("#7E5544"), Color("#3A231A"), 35, 2)
			add_rect(stage, frame_pos + Vector2(4, 4), Vector2(24, 34), Color.from_hsv(0.54 + float(i) * 0.07, 0.16, 1.0), 36)


func draw_bookshelf(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_shadow(stage, pos + Vector2(5, 7), size, 28)
	
	add_asset_region(
		stage,
		"BookshelfTexture",
		"lrk_cabinets",
		Rect2(16, 16, 48, 64),
		pos,
		size,
		46
	)
	
	if not has_asset("lrk_cabinets"):
		add_panel(stage, pos, size, Color("#6D4631"), Color("#3E281E"), 35, 3)
		for shelf in range(3):
			add_rect(stage, pos + Vector2(8, 26 + shelf * 30), Vector2(size.x - 16, 4), Color("#3E281E"), 36)


func draw_desk(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_shadow(stage, pos + Vector2(8, 8), size, 25)
	
	add_asset_region(
		stage,
		"DeskTexture",
		"bedroom_wardrobes",
		Rect2(208, 72, 48, 40),
		pos,
		size,
		42
	)
	
	if not has_asset("bedroom_wardrobes"):
		add_rect(stage, pos + Vector2(0, 22), Vector2(size.x, 18), Color("#7A533C"), 35)
		add_rect(stage, pos + Vector2(8, 40), Vector2(10, size.y - 40), Color("#4F3324"), 34)
		add_rect(stage, pos + Vector2(size.x - 18, 40), Vector2(10, size.y - 40), Color("#4F3324"), 34)
	
	add_asset_region(
		stage,
		"DeskBooks",
		"bedroom_decorations",
		Rect2(145, 55, 18, 17),
		pos + Vector2(size.x - 52, 2),
		Vector2(42, 34),
		50
	)


func draw_diary(stage: Control, pos: Vector2) -> void:
	add_panel(stage, pos, Vector2(34, 24), Color("#B6875B"), Color("#6D4A31"), 70, 3)
	add_rect(stage, pos + Vector2(22, 3), Vector2(8, 18), Color("#F5EFD7"), 71)
	add_rect(stage, pos + Vector2(5, 7), Vector2(13, 2), Color("#D8C2A0"), 72)
	add_rect(stage, pos + Vector2(5, 13), Vector2(13, 2), Color("#D8C2A0"), 72)


func draw_plushie(stage: Control, pos: Vector2) -> void:
	add_panel(stage, pos + Vector2(8, 16), Vector2(42, 36), Color("#E9A9BA"), Color("#8E5966"), 65, 12)
	add_panel(stage, pos + Vector2(8, 6), Vector2(15, 18), Color("#E9A9BA"), Color("#8E5966"), 64, 8)
	add_panel(stage, pos + Vector2(35, 6), Vector2(15, 18), Color("#E9A9BA"), Color("#8E5966"), 64, 8)
	add_label(stage, pos + Vector2(9, 22), Vector2(42, 22), "• ᴗ •", 12, 66)


func draw_chest(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_panel(stage, pos, size, Color("#996B41"), Color("#56341F"), 45, 4)
	add_rect(stage, pos + Vector2(5, 6), Vector2(size.x - 10, size.y - 12), Color("#B98755"), 46)
	add_rect(stage, pos + Vector2(0, size.y / 2.0 - 2), Vector2(size.x, 4), Color("#6E4B2F"), 47)
	add_rect(stage, pos + Vector2(size.x / 2.0 - 5, size.y / 2.0 - 5), Vector2(10, 10), Color("#F4D17E"), 48)


func draw_plant(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"PlantTexture",
		"lrk_decorations",
		Rect2(0, 64, 32, 48),
		pos,
		size,
		54
	)
	
	if not has_asset("lrk_decorations"):
		add_panel(stage, pos + Vector2(10, size.y - 26), Vector2(size.x - 20, 26), Color("#9C6C46"), Color("#5A3728"), 45, 4)
		add_rect(stage, pos + Vector2(size.x / 2.0 - 5, size.y - 44), Vector2(10, 20), Color("#4F9E5A"), 46)


func draw_wardrobe(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_shadow(stage, pos + Vector2(6, 8), size, 25)
	
	add_asset_region(
		stage,
		"WardrobeTexture",
		"bedroom_wardrobes",
		Rect2(16, 32, 48, 64),
		pos,
		size,
		50
	)
	
	if not has_asset("bedroom_wardrobes"):
		add_panel(stage, pos, size, Color("#704A38"), Color("#3E281E"), 45, 3)


func draw_sofa(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_shadow(stage, pos + Vector2(8, 8), size, 25)
	add_asset_region(stage, "SofaTextureBase", "lrk_livingroom", Rect2(16, 32, 112, 32), pos, size, 41, Color(1, 1, 1, 0.38))
	add_panel(stage, pos + Vector2(0, 18), Vector2(size.x, size.y - 18), Color("#D6C0AF"), Color("#7B6256"), 42, 10)
	add_panel(stage, pos, Vector2(size.x, 28), Color("#E6D2C1"), Color("#7B6256"), 43, 10)
	add_panel(stage, pos + Vector2(10, 24), Vector2(size.x / 2.0 - 16, size.y - 34), Color("#C8AF9D"), Color("#7B6256"), 44, 8)
	add_panel(stage, pos + Vector2(size.x / 2.0 + 6, 24), Vector2(size.x / 2.0 - 16, size.y - 34), Color("#C8AF9D"), Color("#7B6256"), 44, 8)
	add_panel(stage, pos + Vector2(-4, 22), Vector2(18, size.y - 24), Color("#CDB6A4"), Color("#7B6256"), 43, 8)
	add_panel(stage, pos + Vector2(size.x - 14, 22), Vector2(18, size.y - 24), Color("#CDB6A4"), Color("#7B6256"), 43, 8)

func draw_table(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"TableTexture",
		"lrk_livingroom",
		Rect2(16, 160, 48, 32),
		pos,
		size,
		45
	)
	
	if not has_asset("lrk_livingroom"):
		add_rect(stage, pos + Vector2(0, 10), Vector2(size.x, 18), Color("#8B6047"), 40)
		add_rect(stage, pos + Vector2(8, 28), Vector2(8, size.y - 28), Color("#6B4935"), 39)


func draw_tv(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_shadow(stage, pos + Vector2(6, 8), size, 25)
	add_asset_region(stage, "TVTextureBase", "lrk_livingroom", Rect2(336, 344, 80, 56), pos, size, 44, Color(1, 1, 1, 0.36))
	add_panel(stage, pos, size, Color("#201915"), Color("#5F4335"), 45, 4)
	add_rect(stage, pos + Vector2(6, 6), Vector2(size.x - 12, size.y - 18), Color("#2C4761"), 46)
	add_rect(stage, pos + Vector2(10, 10), Vector2(size.x - 20, size.y - 30), Color("#3E79A6"), 47)
	add_rect(stage, pos + Vector2(size.x / 2.0 - 8, size.y - 12), Vector2(16, 6), Color("#7A5845"), 46)

func draw_fridge(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"FridgeTexture",
		"lrk_kitchen",
		Rect2(352, 179, 32, 61),
		pos,
		size,
		48
	)
	
	if not has_asset("lrk_kitchen"):
		add_panel(stage, pos, size, Color("#E8ECEE"), Color("#87929B"), 40, 4)


func draw_counter(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"CounterTexture",
		"lrk_kitchen",
		Rect2(23, 139, 145, 65),
		pos,
		size,
		44
	)
	
	if not has_asset("lrk_kitchen"):
		add_panel(stage, pos, size, Color("#8E6A58"), Color("#5A3C30"), 40, 3)


func draw_sink(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"SinkTexture",
		"bathroom_fixtures",
		Rect2(105, 13, 32, 21),
		pos,
		size,
		45
	)
	
	if not has_asset("bathroom_fixtures"):
		add_panel(stage, pos, size, Color("#9AA8B5"), Color("#65717A"), 40, 4)


func draw_stove(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"StoveTexture",
		"lrk_kitchen",
		Rect2(144, 80, 32, 42),
		pos,
		size,
		45
	)
	
	if not has_asset("lrk_kitchen"):
		add_panel(stage, pos, size, Color("#6B747D"), Color("#404850"), 40, 4)


func draw_bathtub(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"BathtubTexture",
		"bathroom_fixtures",
		Rect2(15, 16, 65, 32),
		pos,
		size,
		46
	)
	
	if not has_asset("bathroom_fixtures"):
		add_panel(stage, pos, size, Color("#DDE6ED"), Color("#98A6B1"), 40, 16)


func draw_toilet(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"ToiletTexture",
		"bathroom_fixtures",
		Rect2(165, 16, 22, 44),
		pos,
		size,
		46
	)
	
	if not has_asset("bathroom_fixtures"):
		add_panel(stage, pos + Vector2(10, 0), Vector2(size.x - 20, 24), Color("#EEF3F7"), Color("#A8B5BE"), 41, 8)
		add_panel(stage, pos + Vector2(6, 20), Vector2(size.x - 12, size.y - 20), Color("#F8FBFD"), Color("#A8B5BE"), 40, 12)


func draw_mirror(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_asset_region(
		stage,
		"MirrorTexture",
		"bathroom_cabinets",
		Rect2(64, 16, 16, 64),
		pos,
		size,
		44
	)
	
	if not has_asset("bathroom_cabinets"):
		add_panel(stage, pos, size, Color("#8B6D61"), Color("#4A332C"), 40, 4)
		add_rect(stage, pos + Vector2(6, 6), size - Vector2(12, 12), Color("#CDEAF5"), 41)

# ============================================================
# STAGE 4/5 COZY LAYOUT + INTERACTION HELPERS
# Append-only helper section. It keeps existing asset functions untouched.
# ============================================================

func draw_small_rug(stage: Control, pos: Vector2, size: Vector2, color: Color, border: Color) -> void:
	var c: Color = color
	var b: Color = border
	c.a = 0.62
	b.a = 0.46
	add_panel(stage, pos, size, c, b, 12, 10, "SmallCozyRug")
	add_panel(stage, pos + Vector2(12, 10), size - Vector2(24, 20), color.darkened(0.08), Color(1, 1, 1, 0.0), 13, 8, "SmallCozyRugInner")


func draw_floor_pillow(stage: Control, pos: Vector2, size: Vector2, color: Color) -> void:
	add_panel(stage, pos, size, color, color.darkened(0.25), 34, 10, "FloorPillow")
	add_panel(stage, pos + Vector2(6, 5), size - Vector2(12, 10), color.lightened(0.06), Color(1, 1, 1, 0.0), 35, 8, "FloorPillowShine")


func draw_wall_shelf(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_rect(stage, pos, size, Color("#704C3B"), 40, "WallShelf")
	add_rect(stage, pos + Vector2(10, -14), Vector2(10, 14), Color("#E8B6C8"), 41, "ShelfBookA")
	add_rect(stage, pos + Vector2(26, -18), Vector2(10, 18), Color("#CFE4B8"), 41, "ShelfBookB")
	add_rect(stage, pos + Vector2(42, -12), Vector2(16, 12), Color("#EBDDA2"), 41, "ShelfBox")


func draw_tiny_kitchen_stuff(stage: Control, pos: Vector2) -> void:
	add_panel(stage, pos, Vector2(42, 24), Color("#E7D3AE"), Color("#8A6347"), 44, 4, "TinyKitchenBasket")
	add_rect(stage, pos + Vector2(7, 7), Vector2(28, 3), Color("#8A6347"), 45)
	add_rect(stage, pos + Vector2(10, 14), Vector2(22, 3), Color("#8A6347"), 45)


func draw_bedroom_vanity(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_shadow(stage, pos + Vector2(6, 6), size, 25)
	add_panel(stage, pos, size, Color("#8B6248"), Color("#4A3024"), 44, 4, "BedroomVanity")
	add_rect(stage, pos + Vector2(12, 12), Vector2(size.x - 24, 4), Color("#BE9470"), 45)
	add_panel(stage, pos + Vector2(size.x / 2.0 - 20, -34), Vector2(40, 32), Color("#C8E3EE"), Color("#6A4B3F"), 45, 18, "BedroomVanityMirror")
	add_panel(stage, pos + Vector2(size.x / 2.0 - 16, size.y - 4), Vector2(32, 16), Color("#D5A9BC"), Color("#8A6072"), 43, 8, "BedroomVanityStool")


func draw_towel_rack(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_panel(stage, pos, size, Color("#C9DDE4"), Color("#6B8E9A"), 44, 4, "TowelRack")
	add_rect(stage, pos + Vector2(10, 10), Vector2(size.x - 20, 4), Color("#6B8E9A"), 45)
	add_panel(stage, pos + Vector2(14, 18), Vector2(18, size.y - 24), Color("#F4E7EF"), Color("#C7A5B5"), 46, 4, "PinkTowel")
	add_panel(stage, pos + Vector2(40, 18), Vector2(18, size.y - 24), Color("#E2F2F6"), Color("#A5C7D0"), 46, 4, "BlueTowel")


func draw_bath_mat(stage: Control, pos: Vector2, size: Vector2) -> void:
	add_panel(stage, pos, size, Color("#8CC6D7"), Color("#DFF5FA"), 12, 10, "BathMat")
	add_panel(stage, pos + Vector2(12, 8), size - Vector2(24, 16), Color("#74B4C8"), Color(1, 1, 1, 0.0), 13, 8, "BathMatInner")


# ============================================================
# EXTRA COZY HELPERS — ADDITIVE, DO NOT REMOVE ASSETS
# ============================================================

func draw_string_lights(stage: Control, pos: Vector2, count: int = 5) -> void:
	for i in range(count):
		var x: float = pos.x + float(i) * 24.0
		
		add_rect(
			stage,
			Vector2(x, pos.y),
			Vector2(20, 2),
			Color("#6A4A38"),
			38,
			"StringLightWire%d" % i
		)
		
		add_panel(
			stage,
			Vector2(x + 6, pos.y + 5),
			Vector2(8, 8),
			Color("#FFE8A8"),
			Color("#B98E5D"),
			39,
			8,
			"StringLightBulb%d" % i
		)
	
	
