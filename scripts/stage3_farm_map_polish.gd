extends Node2D

# ============================================================
# STAGE 3 — CLEAN FARM MAP POLISH LAYER
# Godot 4.x
#
# Replace:
#   res://scripts/stage3_farm_map_polish.gd
#
# Purpose:
# - Make the map prettier without re-building the whole map.
# - Do NOT cover shop/storage/well/animal pen/big house.
# - Do NOT add huge opaque rectangles or duplicate fences.
# - Add clear, small, cozy details around existing zones.
# ============================================================

const FARM_ORIGIN: Vector2 = Vector2(540, 255)
const WORLD_SIZE: Vector2 = Vector2(1900, 1200)

const TEXTURE_BASE: String = "res://assets/love_garden/texture_packs/"
const TINY_BASE: String = TEXTURE_BASE + "tiny_wonder/Tiny Wonder Farm Free/"
const SMALLBURG_BASE: String = TEXTURE_BASE + "smallburg/assets/"

var tiny_farm_plants: Texture2D
var tiny_farm_objects: Texture2D
var smallburg_flowers: Texture2D


func _ready() -> void:
	# Keep this as a decoration-layer child.
	# It must stay low enough not to compete with buildings/animals/player.
	z_index = 1
	z_as_relative = true
	load_assets()
	build_polish()


func load_assets() -> void:
	tiny_farm_plants = safe_load_texture(TINY_BASE + "objects&items/plants free.png")
	tiny_farm_objects = safe_load_texture(TINY_BASE + "objects&items/farm objects free.png")
	smallburg_flowers = safe_load_texture(SMALLBURG_BASE + "tileset_v2/flower_gardens/flower_gardens_wood_plants.png")


func safe_load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	return null


# ============================================================
# BASIC HELPERS
# ============================================================

func clear_children() -> void:
	for child in get_children():
		child.queue_free()


func make_panel_style(bg: Color, border: Color, border_width: int = 2, radius: int = 6) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	return style


func add_rect(node_name: String, pos: Vector2, size: Vector2, color: Color, z: int = 0) -> ColorRect:
	var rect: ColorRect = ColorRect.new()
	rect.name = node_name
	rect.position = pos
	rect.size = size
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.z_index = z
	add_child(rect)
	return rect


func add_panel(node_name: String, pos: Vector2, size: Vector2, bg: Color, border: Color, z: int = 0, radius: int = 6) -> Panel:
	var panel: Panel = Panel.new()
	panel.name = node_name
	panel.position = pos
	panel.size = size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = z
	panel.add_theme_stylebox_override("panel", make_panel_style(bg, border, 2, radius))
	add_child(panel)
	return panel


func make_atlas(texture: Texture2D, region: Rect2) -> AtlasTexture:
	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = region
	return atlas


func add_region_sprite(
	node_name: String,
	texture: Texture2D,
	region: Rect2,
	pos: Vector2,
	scale_value: Vector2 = Vector2(2, 2),
	z: int = 10
) -> Sprite2D:
	var sprite: Sprite2D = Sprite2D.new()
	sprite.name = node_name
	sprite.position = pos
	sprite.centered = true
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = scale_value
	sprite.z_index = z

	if texture != null:
		sprite.texture = make_atlas(texture, region)
	else:
		sprite.visible = false

	add_child(sprite)
	return sprite


func add_flower_cluster(base_pos: Vector2, name_prefix: String, z: int = 8) -> void:
	# Small flower cluster only. No big panels.
	add_rect(name_prefix + "_leaf_a", base_pos + Vector2(10, 12), Vector2(8, 7), Color("#5FA65B"), z)
	add_rect(name_prefix + "_leaf_b", base_pos + Vector2(22, 10), Vector2(7, 8), Color("#6EBA62"), z)
	add_rect(name_prefix + "_flower_a", base_pos + Vector2(6, 4), Vector2(10, 10), Color("#F3A6C8"), z + 1)
	add_rect(name_prefix + "_flower_b", base_pos + Vector2(20, 2), Vector2(9, 9), Color("#FFF1A8"), z + 1)
	add_rect(name_prefix + "_flower_c", base_pos + Vector2(31, 8), Vector2(8, 8), Color("#D8B6FF"), z + 1)


func add_bush(base_pos: Vector2, size: Vector2, node_name: String, z: int = 7) -> void:
	add_panel(node_name, base_pos, size, Color("#5FA65B"), Color("#3F7E3C"), z, 12)
	add_panel(
		node_name + "_shine",
		base_pos + Vector2(8, 6),
		Vector2(size.x * 0.42, size.y * 0.30),
		Color(0.80, 1.0, 0.65, 0.16),
		Color(1, 1, 1, 0.0),
		z + 1,
		10
	)


func add_small_sign(node_name: String, pos: Vector2, text: String, z: int = 10) -> void:
	add_rect(node_name + "_post", pos + Vector2(34, 26), Vector2(7, 32), Color("#6D4A31"), z)
	add_panel(node_name + "_board", pos, Vector2(76, 34), Color("#9B6B45"), Color("#5D3B2B"), z + 1, 5)

	var label: Label = Label.new()
	label.name = node_name + "_text"
	label.position = pos
	label.size = Vector2(76, 34)
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.z_index = z + 2
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", Color("#2E1C14"))
	label.add_theme_constant_override("outline_size", 2)
	add_child(label)


func add_step_stone(node_name: String, pos: Vector2, size: Vector2 = Vector2(40, 15), z: int = 4) -> void:
	add_panel(node_name, pos, size, Color("#C6A574"), Color("#9F7950"), z, 8)


# ============================================================
# MAIN BUILD
# ============================================================

func build_polish() -> void:
	clear_children()

	# IMPORTANT:
	# We are not drawing huge covers anymore.
	# Each function only adds small details around the existing map.
	polish_starter_cottage_top_left()
	polish_crop_field()
	polish_pond()
	polish_paths_subtle()
	polish_animal_pen()
	polish_shop_storage()
	polish_big_house_area()
	polish_memory_corner()
	polish_edges_lightly()


# ============================================================
# TOP-LEFT HOUSE / STARTER COTTAGE
# ============================================================

func polish_starter_cottage_top_left() -> void:
	# This is the house in the top-left area.
	# We only add a gentle yard and path, not another building.
	var yard_pos: Vector2 = Vector2(104, 70)
	var yard_size: Vector2 = Vector2(390, 300)

	add_panel(
		"StarterCottageSoftYard",
		yard_pos,
		yard_size,
		Color(0.73, 0.88, 0.58, 0.16),
		Color(0.54, 0.72, 0.43, 0.14),
		0,
		18
	)

	# Path from cottage toward the main path.
	add_panel(
		"StarterCottagePath",
		Vector2(250, 292),
		Vector2(72, 115),
		Color(0.82, 0.67, 0.42, 0.26),
		Color(0.70, 0.52, 0.34, 0.18),
		1,
		8
	)

	add_step_stone("StarterCottageStone1", Vector2(266, 316), Vector2(40, 14), 3)
	add_step_stone("StarterCottageStone2", Vector2(266, 354), Vector2(40, 14), 3)

	add_flower_cluster(Vector2(130, 118), "StarterHouseFlowersA", 6)
	add_flower_cluster(Vector2(420, 125), "StarterHouseFlowersB", 6)
	add_flower_cluster(Vector2(130, 305), "StarterHouseFlowersC", 6)
	add_bush(Vector2(414, 282), Vector2(58, 34), "StarterHouseBushRight", 6)

	add_small_sign("StarterHouseSign", Vector2(125, 235), "Little\nHouse", 8)


# ============================================================
# CROP FIELD
# ============================================================

func polish_crop_field() -> void:
	var field_pos: Vector2 = FARM_ORIGIN + Vector2(-42, -42)
	var field_size: Vector2 = Vector2(410, 410)

	# Very light base; does not hide crop plots.
	add_panel(
		"CropFieldSoftFrame",
		field_pos,
		field_size,
		Color(0.58, 0.78, 0.45, 0.10),
		Color(0.42, 0.62, 0.32, 0.22),
		0,
		10
	)

	# Small corner fence pieces only, not a full cage around the farm.
	add_rect("CropFenceTopLeftA", field_pos + Vector2(8, 8), Vector2(84, 6), Color("#A8784F"), 5)
	add_rect("CropFenceTopLeftB", field_pos + Vector2(8, 18), Vector2(84, 6), Color("#A8784F"), 5)
	add_rect("CropFenceTopRightA", field_pos + Vector2(field_size.x - 92, 8), Vector2(84, 6), Color("#A8784F"), 5)
	add_rect("CropFenceTopRightB", field_pos + Vector2(field_size.x - 92, 18), Vector2(84, 6), Color("#A8784F"), 5)

	add_rect("CropFenceBottomLeftA", field_pos + Vector2(8, field_size.y - 24), Vector2(84, 6), Color("#A8784F"), 5)
	add_rect("CropFenceBottomRightA", field_pos + Vector2(field_size.x - 92, field_size.y - 24), Vector2(84, 6), Color("#A8784F"), 5)

	add_flower_cluster(field_pos + Vector2(-34, 24), "CropFlowersA", 7)
	add_flower_cluster(field_pos + Vector2(field_size.x + 4, 34), "CropFlowersB", 7)
	add_flower_cluster(field_pos + Vector2(-30, field_size.y - 60), "CropFlowersC", 7)
	add_flower_cluster(field_pos + Vector2(field_size.x + 0, field_size.y - 64), "CropFlowersD", 7)

	add_small_sign("CropFieldSign", field_pos + Vector2(-72, 42), "Seeds\nGrow", 8)


# ============================================================
# POND
# ============================================================

func polish_pond() -> void:
	# Do not redraw pond water. Your base map already has it.
	# Add only shoreline details.
	add_flower_cluster(Vector2(205, 525), "PondFlowerA", 7)
	add_flower_cluster(Vector2(410, 520), "PondFlowerB", 7)
	add_flower_cluster(Vector2(208, 650), "PondFlowerC", 7)
	add_bush(Vector2(214, 610), Vector2(54, 30), "PondBushA", 6)
	add_bush(Vector2(408, 564), Vector2(54, 30), "PondBushB", 6)

	add_rect("PondShineExtraA", Vector2(302, 568), Vector2(44, 6), Color(1, 1, 1, 0.16), 3)
	add_rect("PondShineExtraB", Vector2(360, 620), Vector2(34, 5), Color(1, 1, 1, 0.13), 3)


# ============================================================
# PATHS
# ============================================================

func polish_paths_subtle() -> void:
	# Only subtle edges. No giant new roads.
	add_rect("MainPathTopTinyEdge", Vector2(190, 401), Vector2(1320, 4), Color("#B98E5D"), 2)
	add_rect("MainPathBottomTinyEdge", Vector2(190, 488), Vector2(1320, 4), Color("#B98E5D"), 2)
	add_rect("VerticalPathLeftTinyEdge", Vector2(1058, 150), Vector2(4, 720), Color("#B98E5D"), 2)
	add_rect("VerticalPathRightTinyEdge", Vector2(1144, 150), Vector2(4, 720), Color("#B98E5D"), 2)


# ============================================================
# ANIMAL PEN
# ============================================================

func polish_animal_pen() -> void:
	# Do not add a second full fence. Original pen already has one.
	var pen_pos: Vector2 = Vector2(820, 585)

	add_panel("AnimalTrough", pen_pos + Vector2(292, 54), Vector2(68, 22), Color("#70AEE0"), Color("#4D7D9A"), 6, 6)
	add_panel("AnimalHay", pen_pos + Vector2(42, 214), Vector2(64, 34), Color("#D9B15F"), Color("#A7793B"), 6, 10)
	add_rect("AnimalHayLineA", pen_pos + Vector2(52, 226), Vector2(44, 4), Color("#B98742"), 7)
	add_rect("AnimalHayLineB", pen_pos + Vector2(54, 238), Vector2(38, 4), Color("#B98742"), 7)

	add_flower_cluster(pen_pos + Vector2(330, 220), "AnimalPenFlowerA", 7)
	add_bush(pen_pos + Vector2(24, 36), Vector2(46, 28), "AnimalPenBushA", 6)


# ============================================================
# SHOP / STORAGE
# ============================================================

func polish_shop_storage() -> void:
	# Keep this sparse so shop and storage stay readable.
	add_flower_cluster(Vector2(1130, 150), "ShopAreaFlowerA", 7)
	add_flower_cluster(Vector2(1390, 154), "ShopAreaFlowerB", 7)
	add_flower_cluster(Vector2(1130, 515), "StorageAreaFlowerA", 7)
	add_flower_cluster(Vector2(1390, 520), "StorageAreaFlowerB", 7)

	add_small_sign("ShopSignHint", Vector2(1092, 230), "Buy\nSeeds", 8)
	add_small_sign("StorageSignHint", Vector2(1092, 386), "Sell\nCrops", 8)

	add_step_stone("ShopStone1", Vector2(1160, 316), Vector2(34, 13), 4)
	add_step_stone("ShopStone2", Vector2(1202, 316), Vector2(34, 13), 4)
	add_step_stone("ShopStone3", Vector2(1244, 316), Vector2(34, 13), 4)


# ============================================================
# BIG HOUSE AREA
# ============================================================

func polish_big_house_area() -> void:
	# Do not draw over the big house.
	# Add side garden details only.
	add_flower_cluster(Vector2(278, 782), "BigHouseFlowerA", 7)
	add_flower_cluster(Vector2(700, 784), "BigHouseFlowerB", 7)
	add_flower_cluster(Vector2(305, 1080), "BigHouseFlowerC", 7)
	add_flower_cluster(Vector2(685, 1080), "BigHouseFlowerD", 7)

	add_bush(Vector2(284, 908), Vector2(56, 32), "BigHouseBushA", 6)
	add_bush(Vector2(692, 908), Vector2(56, 32), "BigHouseBushB", 6)

	add_small_sign("BigHouseGardenSign", Vector2(270, 1018), "Big\nHouse", 8)


# ============================================================
# ROMANTIC MEMORY CORNER
# ============================================================

func polish_memory_corner() -> void:
	# Smaller and far-right, but not near shop/storage.
	var corner_pos: Vector2 = Vector2(1510, 820)

	add_panel(
		"MemoryCornerTinyBase",
		corner_pos,
		Vector2(240, 145),
		Color(0.81, 0.91, 0.71, 0.16),
		Color(0.56, 0.72, 0.43, 0.18),
		0,
		16
	)
	add_panel("MemoryCornerBlanket", corner_pos + Vector2(40, 56), Vector2(158, 60), Color("#E9B8C8"), Color("#B9788F"), 3, 12)
	add_panel("MemoryCornerBasket", corner_pos + Vector2(72, 80), Vector2(36, 28), Color("#B98755"), Color("#6D4A31"), 5, 8)
	add_panel("MemoryCornerPillow", corner_pos + Vector2(152, 74), Vector2(34, 24), Color("#FFF1A8"), Color("#B9A35D"), 5, 10)
	add_flower_cluster(corner_pos + Vector2(14, 18), "MemoryCornerFlowerA", 6)
	add_flower_cluster(corner_pos + Vector2(192, 18), "MemoryCornerFlowerB", 6)


# ============================================================
# LIGHT EDGE DECOR
# ============================================================

func polish_edges_lightly() -> void:
	# Fewer edge flowers. Previous version was too busy.
	for i in range(6):
		add_flower_cluster(Vector2(42, 200 + i * 110), "LeftEdgeFlowerClean%d" % i, 7)
	for i in range(6):
		add_flower_cluster(Vector2(WORLD_SIZE.x - 92, 200 + i * 110), "RightEdgeFlowerClean%d" % i, 7)
