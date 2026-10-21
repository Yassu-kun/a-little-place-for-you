extends Node2D

# ============================================================
# LOVE GARDEN — COZY FARM V4
# Godot 4.x
#
# Attach this script to a clean Node2D scene named:
# LoveGarden
#
# This script auto-creates the whole farm scene.
# ============================================================


# ============================================================
# SAVE VERSION
# ============================================================

const SAVE_VERSION: int = 4
const SAVE_PATH: String = "user://love_garden_v4_save.json"


# ============================================================
# ASSET PATHS — MATCHING YOUR TREE
# ============================================================

const CHARACTER_SHEET_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Characters/Basic Charakter Spritesheet.png"
const CHICKEN_SHEET_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Characters/Free Chicken Sprites.png"
const COW_SHEET_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Characters/Free Cow Sprites.png"
const PLANTS_SHEET_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Objects/Basic Plants.png"
const TILLED_DIRT_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Tilesets/Tilled Dirt.png"

const FONT_REGULAR_PATH: String = "res://assets/fonts/NotoSansSC-Regular.ttf"
const FONT_BOLD_PATH: String = "res://assets/fonts/NotoSansSC-Bold.ttf"

const BASIC_FURNITURE_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Objects/Basic Furniture.png"
const CHEST_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Objects/Chest.png"
const DOORS_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Tilesets/Doors.png"
const WOODEN_HOUSE_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Tilesets/Wooden House.png"
const FENCES_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Tilesets/Fences.png"

const COZY_INTERIOR_PATH: String = "res://assets/love_garden/cozy_interior/interior free/interior free.png"
const PIXEL_BEDS_PATH: String = "res://assets/love_garden/pixel_interior_bedroom/beds_BR.png"
const PIXEL_BEDROOM_DECOR_PATH: String = "res://assets/love_garden/pixel_interior_bedroom/decorations_BR.png"
const PIXEL_WARDROBES_PATH: String = "res://assets/love_garden/pixel_interior_bedroom/wardrobes_BR.png"

const PIXEL_FLOORS_WALLS_PATH: String = "res://assets/love_garden/pixel_interior_livingroom/floorswalls_LRK.png"
const PIXEL_LIVINGROOM_PATH: String = "res://assets/love_garden/pixel_interior_livingroom/livingroom_LRK.png"
const PIXEL_LIVINGROOM_DECOR_PATH: String = "res://assets/love_garden/pixel_interior_livingroom/decorations_LRK.png"
const PIXEL_DOORS_WINDOWS_PATH: String = "res://assets/love_garden/pixel_interior_livingroom/doorswindowsstairs_LRK.png"
const PIXEL_CABINETS_PATH: String = "res://assets/love_garden/pixel_interior_livingroom/cabinets_LRK.png"

# ============================================================
# WORLD CONSTANTS
# ============================================================

const VIEW_SIZE: Vector2 = Vector2(1152, 648)
const WORLD_SIZE: Vector2 = Vector2(1900, 1200)

const PLAYER_START: Vector2 = Vector2(330, 390)
const PLAYER_SPEED: float = 185.0
const INTERACT_DISTANCE: float = 82.0

const MAX_ENERGY: int = 100
const MAX_WATER: int = 28

const FARM_ROWS: int = 6
const FARM_COLS: int = 6
const PLOT_SIZE: Vector2 = Vector2(46, 46)
const PLOT_SPACING: Vector2 = Vector2(58, 58)
const FARM_ORIGIN: Vector2 = Vector2(540, 255)

const PLAYER_FRAME_SIZE: Vector2 = Vector2(48, 48)
const PLAYER_SPRITE_SCALE: Vector2 = Vector2(2.15, 2.15)

const MESSAGE_WIDTH: int = 640
const MESSAGE_HEIGHT: int = 400


# ============================================================
# NODE REFERENCES
# ============================================================
var world_map_panel: Panel
var world_map_canvas: Control
var world_map_texture_rect: TextureRect
var world_map_subviewport: SubViewport
var world_map_camera: Camera2D
var world_map_player_dot: ColorRect
var world_map_labels: Dictionary = {}

const MAP_DRAW_SIZE := Vector2(300, 180)

var house_v2: CanvasLayer

var world: Node2D
var background: ColorRect
var decoration_layer: Node2D
var farm_layer: Node2D
var building_layer: Node2D
var animal_layer: Node2D

var player: CharacterBody2D
var player_sprite: Sprite2D
var camera: Camera2D

var canvas_layer: CanvasLayer
var hud_panel: Panel
var hud_text: RichTextLabel
var back_button: Button

var interact_hint: Label
var toast_panel: Panel
var toast_text: Label

var message_panel: Panel
var message_text: RichTextLabel
var close_message_button: Button

var action_label: Label

var house_panel: Panel
var house_title: Label
var house_exit_button: Button
var house_sleep_button: Button
var house_info_text: RichTextLabel

var house_stage: Panel
var room_player: ColorRect
var room_player_label: Label
var room_hint: Label
var room_hotspots: Dictionary = {}
var room_target_id: String = ""
var room_speed: float = 245.0

var room_is_night: bool = false

var room_wall_rect: ColorRect
var room_floor_rect: ColorRect
var room_top_trim: ColorRect
var room_bottom_shadow: ColorRect
var room_window_outside: ColorRect
var room_night_overlay: ColorRect
var room_bed_glow: ColorRect
var room_desk_glow: ColorRect
var room_star_dots: Array[ColorRect] = []
var room_rug_panel: Panel

var room_highlight: Panel
var room_hover_label: Label

var house_style_index: int = 0
var house_memory_count: int = 0
var house_plant_level: int = 0
var house_outfit_index: int = 0
var house_diary_entries: int = 0

var room_player_sprite: Sprite2D
var room_facing: String = "down"
var room_player_anim_timer: float = 0.0
var room_player_anim_frame: int = 0
var room_player_moving: bool = false

var current_house_room: String = "bedroom"
var room_tab_buttons: Dictionary = {}

# ============================================================
# TEXTURES / FONTS
# ============================================================

var character_texture: Texture2D
var chicken_texture: Texture2D
var cow_texture: Texture2D
var plants_texture: Texture2D
var dirt_texture: Texture2D

var ui_font_regular: FontFile
var ui_font_bold: FontFile

var basic_furniture_texture: Texture2D
var chest_texture: Texture2D
var doors_texture: Texture2D
var wooden_house_texture: Texture2D
var fences_texture: Texture2D

var cozy_interior_texture: Texture2D
var pixel_beds_texture: Texture2D
var pixel_bedroom_decor_texture: Texture2D
var pixel_wardrobes_texture: Texture2D
var pixel_floors_walls_texture: Texture2D
var pixel_livingroom_texture: Texture2D
var pixel_livingroom_decor_texture: Texture2D
var pixel_doors_windows_texture: Texture2D
var pixel_cabinets_texture: Texture2D

# ============================================================
# GAME STATE
# ============================================================

var day: int = 1
var season_index: int = 0
var weather: String = "sunny"

var coins: int = 80
var energy: int = MAX_ENERGY
var water: int = MAX_WATER
var animal_feed: int = 10

var selected_crop: String = "missing"
var total_harvested: int = 0

var seeds: Dictionary = {
	"missing": 14,
	"hug": 0,
	"courage": 0,
	"kiss": 0,
	"moon": 0,
	"star": 0
}

var storage: Dictionary = {
	"missing": 0,
	"hug": 0,
	"courage": 0,
	"kiss": 0,
	"moon": 0,
	"star": 0,
	"egg": 0,
	"milk": 0
}

var plots: Array = []
var plot_nodes: Array = []

var animals: Array = []
var animal_nodes: Array = []

var building_nodes: Dictionary = {}
var asset_registry: RefCounted

# ============================================================
# COZY WORLD TEXTURE PACK
# ============================================================

var world_texture_pack_name: String = "cozy_default"

var tex_big_house_body: Texture2D
var tex_big_house_roof: Texture2D
var tex_big_house_door: Texture2D
var tex_big_house_window: Texture2D
var tex_big_house_flowerbox: Texture2D
var tex_big_house_bush: Texture2D
var tex_big_house_chimney: Texture2D

var target_type: String = ""
var target_index: int = -1
var target_decor_id: String = ""
var decor_interactions: Dictionary = {}

var outside_points: Array = []


# ============================================================
# ANIMATION STATE
# ============================================================

var facing: String = "down"
var player_anim_timer: float = 0.0
var player_anim_frame: int = 0
var player_moving: bool = false

var animal_anim_timer: float = 0.0
var animal_anim_frame: int = 0

var action_timer: float = 0.0
var action_kind: String = ""

var toast_timer: float = 0.0


# ============================================================
# DATA TABLES
# ============================================================

var seasons: Array = [
	{
		"zh": "春天",
		"en": "Spring",
		"color": Color("#BEEFA8")
	},
	{
		"zh": "夏天",
		"en": "Summer",
		"color": Color("#A8EFA0")
	},
	{
		"zh": "秋天",
		"en": "Autumn",
		"color": Color("#E9C78A")
	},
	{
		"zh": "冬天",
		"en": "Winter",
		"color": Color("#CFE8FF")
	}
]

var crop_order: Array = [
	"missing",
	"hug",
	"courage",
	"kiss",
	"moon",
	"star"
]

var crop_data: Dictionary = {
	"missing": {
		"zh": "思念花",
		"en": "Missing-you Flower",
		"seed_zh": "思念花种子",
		"seed_en": "Missing-you Seed",
		"seed_cost": 2,
		"sell_price": 5,
		"days_to_grow": 2,
		"unlock_at": 0,
		"tint": Color("#FFD1E8")
	},
	"hug": {
		"zh": "抱抱莓",
		"en": "Hug Berry",
		"seed_zh": "抱抱莓种子",
		"seed_en": "Hug Berry Seed",
		"seed_cost": 4,
		"sell_price": 9,
		"days_to_grow": 3,
		"unlock_at": 6,
		"tint": Color("#FFB7B2")
	},
	"courage": {
		"zh": "勇气草",
		"en": "Courage Leaf",
		"seed_zh": "勇气草种子",
		"seed_en": "Courage Leaf Seed",
		"seed_cost": 7,
		"sell_price": 15,
		"days_to_grow": 4,
		"unlock_at": 16,
		"tint": Color("#B5F2A5")
	},
	"kiss": {
		"zh": "亲亲花",
		"en": "Kiss Blossom",
		"seed_zh": "亲亲花种子",
		"seed_en": "Kiss Blossom Seed",
		"seed_cost": 12,
		"sell_price": 28,
		"days_to_grow": 5,
		"unlock_at": 35,
		"tint": Color("#F5A6FF")
	},
	"moon": {
		"zh": "月光铃",
		"en": "Moonbell",
		"seed_zh": "月光铃种子",
		"seed_en": "Moonbell Seed",
		"seed_cost": 18,
		"sell_price": 45,
		"days_to_grow": 6,
		"unlock_at": 60,
		"tint": Color("#CFCBFF")
	},
	"star": {
		"zh": "星星果",
		"en": "Starfruit",
		"seed_zh": "星星果种子",
		"seed_en": "Starfruit Seed",
		"seed_cost": 30,
		"sell_price": 85,
		"days_to_grow": 8,
		"unlock_at": 100,
		"tint": Color("#FFF1A8")
	}
}

var animal_type_data: Dictionary = {
	"chicken": {
		"zh": "小鸡",
		"en": "Chicken",
		"product": "egg",
		"product_zh": "鸡蛋",
		"product_en": "Egg",
		"sell_price": 8
	},
	"cow": {
		"zh": "小牛",
		"en": "Cow",
		"product": "milk",
		"product_zh": "牛奶",
		"product_en": "Milk",
		"sell_price": 18
	}
}


# ============================================================
# READY
# ============================================================

func _ready():
	randomize()
	load_world_texture_pack()
	load_assets()
	setup_asset_registry()
	ensure_scene_structure()
	setup_ui()
	setup_house_v2()
	build_world()
	create_farm_plots()
	create_buildings()
	create_outside_points()
	create_animals()
	setup_player()
	load_game()
	refresh_all()
	show_welcome_message()


# ============================================================
# ASSET LOADING
# ============================================================

func load_assets():
	character_texture = load(CHARACTER_SHEET_PATH) as Texture2D
	chicken_texture = load(CHICKEN_SHEET_PATH) as Texture2D
	cow_texture = load(COW_SHEET_PATH) as Texture2D
	plants_texture = load(PLANTS_SHEET_PATH) as Texture2D
	dirt_texture = load(TILLED_DIRT_PATH) as Texture2D
	
	ui_font_regular = load(FONT_REGULAR_PATH) as FontFile
	ui_font_bold = load(FONT_BOLD_PATH) as FontFile
	
	basic_furniture_texture = load(BASIC_FURNITURE_PATH) as Texture2D
	chest_texture = load(CHEST_PATH) as Texture2D
	doors_texture = load(DOORS_PATH) as Texture2D
	wooden_house_texture = load(WOODEN_HOUSE_PATH) as Texture2D
	fences_texture = load(FENCES_PATH) as Texture2D
	
	cozy_interior_texture = load(COZY_INTERIOR_PATH) as Texture2D
	pixel_beds_texture = load(PIXEL_BEDS_PATH) as Texture2D
	pixel_bedroom_decor_texture = load(PIXEL_BEDROOM_DECOR_PATH) as Texture2D
	pixel_wardrobes_texture = load(PIXEL_WARDROBES_PATH) as Texture2D
	pixel_floors_walls_texture = load(PIXEL_FLOORS_WALLS_PATH) as Texture2D
	pixel_livingroom_texture = load(PIXEL_LIVINGROOM_PATH) as Texture2D
	pixel_livingroom_decor_texture = load(PIXEL_LIVINGROOM_DECOR_PATH) as Texture2D
	pixel_doors_windows_texture = load(PIXEL_DOORS_WINDOWS_PATH) as Texture2D
	pixel_cabinets_texture = load(PIXEL_CABINETS_PATH) as Texture2D
	
	if character_texture == null:
		push_warning("Missing character texture. Check path: " + CHARACTER_SHEET_PATH)
	
	if chicken_texture == null:
		push_warning("Missing chicken texture. Check path: " + CHICKEN_SHEET_PATH)
	
	if cow_texture == null:
		push_warning("Missing cow texture. Check path: " + COW_SHEET_PATH)
	
	if plants_texture == null:
		push_warning("Missing plants texture. Check path: " + PLANTS_SHEET_PATH)
	
	if dirt_texture == null:
		push_warning("Missing tilled dirt texture. Check path: " + TILLED_DIRT_PATH)
	
	if ui_font_regular == null:
		push_warning("Missing font: " + FONT_REGULAR_PATH)
	
	if ui_font_bold == null:
		push_warning("Missing font: " + FONT_BOLD_PATH)

# ============================================================
# MASTER ASSET REGISTRY
# ============================================================

func setup_asset_registry():
	var registry_script: Script = load("res://scripts/asset_registry.gd") as Script
	
	if registry_script == null:
		push_error("Could not load asset registry script.")
		return
	
	asset_registry = registry_script.new() as RefCounted
	
	if asset_registry == null:
		push_error("Could not create asset registry.")
		return
	
	if asset_registry.has_method("load_all"):
		asset_registry.call("load_all")

# ============================================================
# SCENE AUTO-CREATION
# ============================================================

func ensure_scene_structure():
	world = get_node_or_null("World") as Node2D
	if world == null:
		world = Node2D.new()
		world.name = "World"
		add_child(world)
	
	background = world.get_node_or_null("Background") as ColorRect
	if background == null:
		background = ColorRect.new()
		background.name = "Background"
		world.add_child(background)
	
	decoration_layer = world.get_node_or_null("DecorationLayer") as Node2D
	if decoration_layer == null:
		decoration_layer = Node2D.new()
		decoration_layer.name = "DecorationLayer"
		world.add_child(decoration_layer)
	
	farm_layer = world.get_node_or_null("FarmPlots") as Node2D
	if farm_layer == null:
		farm_layer = Node2D.new()
		farm_layer.name = "FarmPlots"
		world.add_child(farm_layer)
	
	building_layer = world.get_node_or_null("Buildings") as Node2D
	if building_layer == null:
		building_layer = Node2D.new()
		building_layer.name = "Buildings"
		world.add_child(building_layer)
	
	animal_layer = world.get_node_or_null("Animals") as Node2D
	if animal_layer == null:
		animal_layer = Node2D.new()
		animal_layer.name = "Animals"
		world.add_child(animal_layer)
	
	player = world.get_node_or_null("Player") as CharacterBody2D
	if player == null:
		player = CharacterBody2D.new()
		player.name = "Player"
		world.add_child(player)
	
	var collision: CollisionShape2D = player.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision == null:
		collision = CollisionShape2D.new()
		collision.name = "CollisionShape2D"
		player.add_child(collision)
	
	if collision.shape == null:
		var player_shape: RectangleShape2D = RectangleShape2D.new()
		player_shape.size = Vector2(24, 28)
		collision.shape = player_shape
	
	player_sprite = player.get_node_or_null("PlayerSprite") as Sprite2D
	if player_sprite == null:
		player_sprite = Sprite2D.new()
		player_sprite.name = "PlayerSprite"
		player.add_child(player_sprite)
	
	var old_visual: Node = player.get_node_or_null("PlayerVisual")
	if old_visual != null:
		old_visual.visible = false
	
	camera = get_node_or_null("Camera2D") as Camera2D
	if camera == null:
		camera = Camera2D.new()
		camera.name = "Camera2D"
		add_child(camera)
	
	canvas_layer = get_node_or_null("CanvasLayer") as CanvasLayer
	if canvas_layer == null:
		canvas_layer = CanvasLayer.new()
		canvas_layer.name = "CanvasLayer"
		add_child(canvas_layer)
	
	hud_panel = canvas_layer.get_node_or_null("HUDPanel") as Panel
	if hud_panel == null:
		hud_panel = Panel.new()
		hud_panel.name = "HUDPanel"
		canvas_layer.add_child(hud_panel)
	
	hud_text = hud_panel.get_node_or_null("HUDText") as RichTextLabel
	if hud_text == null:
		hud_text = RichTextLabel.new()
		hud_text.name = "HUDText"
		hud_panel.add_child(hud_text)
	
	back_button = hud_panel.get_node_or_null("BackButton") as Button
	if back_button == null:
		back_button = Button.new()
		back_button.name = "BackButton"
		hud_panel.add_child(back_button)
	
	interact_hint = canvas_layer.get_node_or_null("InteractHint") as Label
	if interact_hint == null:
		interact_hint = Label.new()
		interact_hint.name = "InteractHint"
		canvas_layer.add_child(interact_hint)
	
	toast_panel = canvas_layer.get_node_or_null("ToastPanel") as Panel
	if toast_panel == null:
		toast_panel = Panel.new()
		toast_panel.name = "ToastPanel"
		canvas_layer.add_child(toast_panel)
	
	toast_text = toast_panel.get_node_or_null("ToastText") as Label
	if toast_text == null:
		toast_text = Label.new()
		toast_text.name = "ToastText"
		toast_panel.add_child(toast_text)
	
	message_panel = canvas_layer.get_node_or_null("MessagePanel") as Panel
	if message_panel == null:
		message_panel = Panel.new()
		message_panel.name = "MessagePanel"
		canvas_layer.add_child(message_panel)
	
	var message_box: VBoxContainer = message_panel.get_node_or_null("MessageBox") as VBoxContainer
	if message_box == null:
		message_box = VBoxContainer.new()
		message_box.name = "MessageBox"
		message_panel.add_child(message_box)
	
	message_text = message_box.get_node_or_null("MessageText") as RichTextLabel
	if message_text == null:
		message_text = RichTextLabel.new()
		message_text.name = "MessageText"
		message_box.add_child(message_text)
	
	close_message_button = message_box.get_node_or_null("CloseMessageButton") as Button
	if close_message_button == null:
		close_message_button = Button.new()
		close_message_button.name = "CloseMessageButton"
		message_box.add_child(close_message_button)
	
	action_label = canvas_layer.get_node_or_null("ActionLabel") as Label
	if action_label == null:
		action_label = Label.new()
		action_label.name = "ActionLabel"
		canvas_layer.add_child(action_label)

func create_world_map_ui():
	world_map_panel = Panel.new()
	world_map_panel.name = "WorldMapPanel"
	world_map_panel.position = Vector2(780, 20)
	world_map_panel.size = Vector2(340, 230)
	world_map_panel.visible = false
	world_map_panel.z_index = 700
	world_map_panel.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.10, 0.14, 0.10, 0.94), Color("#DDECC8"), 2, 12)
	)
	canvas_layer.add_child(world_map_panel)

	var title: Label = Label.new()
	title.position = Vector2(0, 8)
	title.size = Vector2(340, 24)
	title.text = "世界地图 / World Map"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	style_label(title, 18, true, Color.WHITE, Color(0.05, 0.05, 0.05, 0.9))
	world_map_panel.add_child(title)

	var hint: Label = Label.new()
	hint.position = Vector2(0, 30)
	hint.size = Vector2(340, 18)
	hint.text = "按 M 关闭 / Press M to close"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	style_label(hint, 12, false, Color("#E8F5DD"), Color(0, 0, 0, 0.6))
	world_map_panel.add_child(hint)

	world_map_canvas = Control.new()
	world_map_canvas.name = "WorldMapCanvas"
	world_map_canvas.position = Vector2(18, 44)
	world_map_canvas.size = MAP_DRAW_SIZE
	world_map_panel.add_child(world_map_canvas)

	world_map_subviewport = SubViewport.new()
	world_map_subviewport.name = "WorldMapSubViewport"
	world_map_subviewport.size = Vector2i(int(MAP_DRAW_SIZE.x), int(MAP_DRAW_SIZE.y))
	world_map_subviewport.disable_3d = true
	world_map_subviewport.transparent_bg = false
	world_map_subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	world_map_subviewport.world_2d = get_viewport().world_2d
	world_map_canvas.add_child(world_map_subviewport)

	world_map_camera = Camera2D.new()
	world_map_camera.name = "WorldMapCamera"
	world_map_camera.position = WORLD_SIZE / 2.0
	
	var zoom_factor: float = get_world_map_zoom_factor()
	world_map_camera.zoom = Vector2(zoom_factor, zoom_factor)
	world_map_camera.enabled = true
	world_map_subviewport.add_child(world_map_camera)
	world_map_camera.make_current()

	world_map_texture_rect = TextureRect.new()
	world_map_texture_rect.name = "WorldMapTexture"
	world_map_texture_rect.position = Vector2.ZERO
	world_map_texture_rect.size = MAP_DRAW_SIZE
	world_map_texture_rect.texture = world_map_subviewport.get_texture()
	world_map_texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	world_map_canvas.add_child(world_map_texture_rect)

	# Border over the live map
	var border: Panel = Panel.new()
	border.position = Vector2.ZERO
	border.size = MAP_DRAW_SIZE
	border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	border.z_index = 20
	border.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0, 0, 0, 0.0), Color("#F5E8C8"), 2, 4)
	)
	world_map_canvas.add_child(border)

	# Extra pink player dot so she can see herself clearly
	world_map_player_dot = ColorRect.new()
	world_map_player_dot.name = "PlayerDot"
	world_map_player_dot.size = Vector2(8, 8)
	world_map_player_dot.color = Color("#FF5FA2")
	world_map_player_dot.z_index = 50
	world_map_player_dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	world_map_canvas.add_child(world_map_player_dot)
	
# ============================================================
# STYLE HELPERS
# ============================================================
func add_world_map_zone(id: String, world_rect: Rect2, color: Color, label_text: String):
	var zone := ColorRect.new()
	zone.position = world_to_map(world_rect.position)
	zone.size = Vector2(
		world_rect.size.x / WORLD_SIZE.x * MAP_DRAW_SIZE.x,
		world_rect.size.y / WORLD_SIZE.y * MAP_DRAW_SIZE.y
	)
	zone.color = color
	world_map_canvas.add_child(zone)

	var label := Label.new()
	label.position = zone.position + Vector2(2, 2)
	label.size = Vector2(zone.size.x, 18)
	label.text = label_text
	style_label(label, 10, true, Color.WHITE, Color(0, 0, 0, 0.85))
	world_map_canvas.add_child(label)

	world_map_labels[id] = zone
	
func world_to_map(world_pos: Vector2) -> Vector2:
	var zoom_factor: float = get_world_map_zoom_factor()
	var map_center: Vector2 = MAP_DRAW_SIZE / 2.0
	var world_center: Vector2 = WORLD_SIZE / 2.0
	
	return map_center + (world_pos - world_center) * zoom_factor
	
	
func get_world_map_zoom_factor() -> float:
	return min(
		MAP_DRAW_SIZE.x / WORLD_SIZE.x,
		MAP_DRAW_SIZE.y / WORLD_SIZE.y
	)
	
	
func toggle_world_map():
	if world_map_panel == null:
		return
	
	world_map_panel.visible = !world_map_panel.visible
	
	if world_map_panel.visible:
		refresh_world_map()
		
func refresh_world_map():
	update_world_map_player_marker()
	
func update_world_map_player_marker():
	if world_map_player_dot == null:
		return
	
	if world_map_panel == null:
		return
	
	if not world_map_panel.visible:
		return
	
	if player == null:
		return
	
	var map_pos: Vector2 = world_to_map(player.global_position)
	world_map_player_dot.position = map_pos - world_map_player_dot.size / 2.0
	
	
func make_panel_style(bg: Color, border: Color, border_width: int = 3, corner_radius: int = 10) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(corner_radius)
	return style


func style_label(node: Label, size: int = 18, bold: bool = false, color: Color = Color.WHITE, outline: Color = Color(0.08, 0.08, 0.08, 0.95)):
	if node == null:
		return
	
	if bold and ui_font_bold != null:
		node.add_theme_font_override("font", ui_font_bold)
	elif ui_font_regular != null:
		node.add_theme_font_override("font", ui_font_regular)
	
	node.add_theme_font_size_override("font_size", size)
	node.add_theme_color_override("font_color", color)
	node.add_theme_color_override("font_outline_color", outline)
	node.add_theme_constant_override("outline_size", 3)


func style_button(node: Button, size: int = 18, bold: bool = true):
	if node == null:
		return
	
	if bold and ui_font_bold != null:
		node.add_theme_font_override("font", ui_font_bold)
	elif ui_font_regular != null:
		node.add_theme_font_override("font", ui_font_regular)
	
	node.add_theme_font_size_override("font_size", size)
	node.add_theme_color_override("font_color", Color.WHITE)
	node.add_theme_color_override("font_hover_color", Color.WHITE)
	node.add_theme_color_override("font_pressed_color", Color.WHITE)
	node.add_theme_color_override("font_focus_color", Color.WHITE)
	node.add_theme_color_override("font_outline_color", Color(0.1, 0.05, 0.1, 0.95))
	node.add_theme_constant_override("outline_size", 3)
	
	node.add_theme_stylebox_override("normal", make_panel_style(Color(0.23, 0.30, 0.22, 0.92), Color(0.82, 0.94, 0.78), 2, 8))
	node.add_theme_stylebox_override("hover", make_panel_style(Color(0.30, 0.38, 0.28, 0.97), Color(0.95, 0.98, 0.88), 2, 8))
	node.add_theme_stylebox_override("pressed", make_panel_style(Color(0.18, 0.24, 0.18, 0.97), Color(0.95, 0.98, 0.88), 2, 8))


func style_rich_text(node: RichTextLabel, normal_size: int = 16):
	if node == null:
		return
	
	if ui_font_regular != null:
		node.add_theme_font_override("normal_font", ui_font_regular)
		
		if ui_font_bold != null:
			node.add_theme_font_override("bold_font", ui_font_bold)
			node.add_theme_font_override("bold_italics_font", ui_font_bold)
		else:
			node.add_theme_font_override("bold_font", ui_font_regular)
			node.add_theme_font_override("bold_italics_font", ui_font_regular)
		
		node.add_theme_font_override("italics_font", ui_font_regular)
	
	node.add_theme_font_size_override("normal_font_size", normal_size)
	node.add_theme_color_override("default_color", Color.WHITE)

func create_region_sprite(
	texture: Texture2D,
	region: Rect2,
	pos: Vector2,
	scale_value: Vector2 = Vector2(2, 2),
	z: int = 10
) -> Sprite2D:
	var sprite: Sprite2D = Sprite2D.new()
	sprite.position = pos
	sprite.centered = true
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.z_index = z
	sprite.scale = scale_value
	
	if texture != null:
		sprite.texture = texture
		sprite.region_enabled = true
		sprite.region_rect = region
	else:
		sprite.visible = false
	
	return sprite


func add_stage_sprite(
	texture: Texture2D,
	region: Rect2,
	pos: Vector2,
	scale_value: Vector2 = Vector2(2, 2),
	z: int = 20
) -> Sprite2D:
	var sprite: Sprite2D = create_region_sprite(texture, region, pos, scale_value, z)
	house_stage.add_child(sprite)
	return sprite


func add_child_sprite(
	parent: Node,
	texture: Texture2D,
	region: Rect2,
	pos: Vector2,
	scale_value: Vector2 = Vector2(2, 2),
	z: int = 20
) -> Sprite2D:
	var sprite: Sprite2D = create_region_sprite(texture, region, pos, scale_value, z)
	parent.add_child(sprite)
	return sprite
	
# ============================================================
# UI SETUP
# ============================================================

func setup_ui():
	background.position = Vector2.ZERO
	background.size = WORLD_SIZE
	background.color = seasons[season_index]["color"]
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	camera.enabled = true
	camera.make_current()
	
	hud_panel.position = Vector2(18, 18)
	hud_panel.size = Vector2(535, 190)
	hud_panel.z_index = 50
	hud_panel.add_theme_stylebox_override("panel", make_panel_style(Color(0.16, 0.22, 0.16, 0.90), Color(0.80, 0.93, 0.76), 2, 12))
	
	hud_text.position = Vector2(14, 10)
	hud_text.size = Vector2(505, 132)
	hud_text.bbcode_enabled = true
	hud_text.scroll_active = false
	hud_text.fit_content = false
	style_rich_text(hud_text, 16)
	
	back_button.position = Vector2(14, 148)
	back_button.size = Vector2(190, 30)
	back_button.text = "返回主菜单 / Back"
	style_button(back_button, 16, true)
	
	if not back_button.pressed.is_connected(go_back):
		back_button.pressed.connect(go_back)
	
	interact_hint.visible = false
	interact_hint.z_index = 80
	interact_hint.position = Vector2.ZERO
	interact_hint.size = Vector2(330, 30)
	style_label(interact_hint, 19, true, Color.WHITE, Color(0.05, 0.15, 0.05, 0.98))
	
	toast_panel.position = Vector2(290, 575)
	toast_panel.size = Vector2(560, 48)
	toast_panel.visible = false
	toast_panel.z_index = 90
	toast_panel.add_theme_stylebox_override("panel", make_panel_style(Color(0.10, 0.10, 0.10, 0.78), Color(0.95, 0.95, 0.95, 0.20), 1, 8))
	
	toast_text.position = Vector2(12, 8)
	toast_text.size = Vector2(536, 32)
	toast_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	style_label(toast_text, 18, true, Color.WHITE, Color(0.1, 0.05, 0.1, 0.95))
	
	action_label.visible = false
	action_label.z_index = 95
	action_label.size = Vector2(64, 64)
	style_label(action_label, 28, true, Color.WHITE, Color(0.1, 0.05, 0.1, 0.95))
	
	message_panel.position = Vector2((VIEW_SIZE.x - MESSAGE_WIDTH) / 2.0, 118)
	message_panel.size = Vector2(MESSAGE_WIDTH, MESSAGE_HEIGHT)
	message_panel.visible = false
	message_panel.z_index = 2000
	message_panel.z_as_relative = false
	message_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	message_panel.add_theme_stylebox_override("panel", make_panel_style(Color(0.18, 0.15, 0.20, 0.96), Color(0.96, 0.76, 0.87), 3, 16))
	
	var message_box: VBoxContainer = message_panel.get_node("MessageBox") as VBoxContainer
	message_box.position = Vector2(24, 24)
	message_box.size = Vector2(MESSAGE_WIDTH - 48, MESSAGE_HEIGHT - 48)
	
	message_text.custom_minimum_size = Vector2(MESSAGE_WIDTH - 56, MESSAGE_HEIGHT - 112)
	message_text.bbcode_enabled = true
	message_text.scroll_active = true
	message_text.fit_content = false
	style_rich_text(message_text, 18)
	
	close_message_button.text = "知道啦 / Okay"
	close_message_button.custom_minimum_size = Vector2(200, 42)
	style_button(close_message_button, 17, true)
	
	if not close_message_button.pressed.is_connected(close_message):
		close_message_button.pressed.connect(close_message)
	
	create_house_interior_ui()
	create_world_map_ui()

func create_outside_points():
	outside_points.clear()
	
	outside_points.append({
		"id": "little_house_garden",
		"pos": Vector2(260, 240),
		"radius": 90.0,
		"hint": "按 E 看小屋花园 / Little house garden",
		"title_zh": "小屋花园",
		"title_en": "Little House Garden",
		"body_zh": "这里是最开始的小屋旁边的小花园。以后可以放一些早期回忆，像是她第一次进入这个游戏时看到的小欢迎信。",
		"body_en": "This is the small garden beside the first little house. Later it can hold early memories, like the first welcome letter she sees in the game."
	})
	
	outside_points.append({
		"id": "pond",
		"pos": Vector2(338, 610),
		"radius": 105.0,
		"hint": "按 E 看池塘 / Pond",
		"title_zh": "安静的小池塘",
		"title_en": "Quiet Pond",
		"body_zh": "水面轻轻晃着。以后这里可以加入钓鱼、许愿、夜晚倒影，或者一封藏在水边的小纸条。",
		"body_en": "The water moves softly. Later this can become a fishing spot, a wish spot, a night reflection, or a little hidden note by the water."
	})
	
	outside_points.append({
		"id": "farm_sign",
		"pos": FARM_ORIGIN + Vector2(-95, 20),
		"radius": 70.0,
		"hint": "按 E 看农场牌子 / Farm sign",
		"title_zh": "农场牌子",
		"title_en": "Farm Sign",
		"body_zh": "牌子上写着：慢慢种，慢慢长大，慢慢把这里变成一个家。",
		"body_en": "The sign says: plant slowly, grow slowly, and slowly turn this place into a home."
	})
	
	outside_points.append({
		"id": "animal_yard",
		"pos": Vector2(1040, 760),
		"radius": 160.0,
		"hint": "按 E 看动物小院 / Animal yard",
		"title_zh": "动物小院",
		"title_en": "Animal Yard",
		"body_zh": "小动物们在这里等她照顾。以后可以加入更多动物、名字、爱心等级和小礼物。",
		"body_en": "The little animals wait here for care. Later this can include more animals, names, affection levels, and little gifts."
	})
	
	outside_points.append({
		"id": "memory_corner",
		"pos": Vector2(1625, 895),
		"radius": 120.0,
		"hint": "按 E 看回忆角 / Memory corner",
		"title_zh": "回忆角",
		"title_en": "Memory Corner",
		"body_zh": "这里以后可以放一块野餐布、几张照片、几封小信。它不需要一开始就很满，因为回忆本来就是慢慢收集的。",
		"body_en": "Later this can hold a picnic blanket, photos, and little letters. It does not need to be full at first, because memories are collected slowly."
	})
	
# ============================================================
# HOUSE INTERIOR UI — WALKABLE ROOM
# ============================================================

func create_house_interior_ui():
	house_panel = canvas_layer.get_node_or_null("HouseInteriorPanel") as Panel
	if house_panel == null:
		house_panel = Panel.new()
		house_panel.name = "HouseInteriorPanel"
		canvas_layer.add_child(house_panel)
	
	house_panel.position = Vector2(70, 28)
	house_panel.size = Vector2(1012, 592)
	house_panel.visible = false
	house_panel.z_index = 180
	house_panel.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.18, 0.13, 0.13, 0.98), Color(0.96, 0.82, 0.72), 3, 18)
	)
	
	clear_children(house_panel)
	room_hotspots.clear()
	room_target_id = ""
	
	create_house_header()
	create_house_room_stage()
	create_house_room_objects()
	create_room_static_decor()
	add_manual_diary_visual(Vector2(407, 207))
	add_manual_plushie_visual(Vector2(192, 244))
	create_house_room_player()
	create_house_room_buttons()
	create_house_room_hint()
	refresh_house_room_visuals()


func create_house_header():
	var title_bg: Panel = Panel.new()
	title_bg.name = "TitleBG"
	title_bg.position = Vector2(18, 14)
	title_bg.size = Vector2(976, 44)
	title_bg.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.14, 0.09, 0.10, 0.88), Color(0.95, 0.82, 0.75), 2, 10)
	)
	house_panel.add_child(title_bg)
	
	house_title = Label.new()
	house_title.position = Vector2.ZERO
	house_title.size = Vector2(976, 44)
	house_title.text = "我们的温馨小屋 / Our Cozy Little House"
	house_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	house_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	style_label(house_title, 21, true, Color.WHITE, Color(0.15, 0.05, 0.05, 0.95))
	title_bg.add_child(house_title)


func create_house_room_stage():
	house_stage = Panel.new()
	house_stage.name = "RoomStage"
	house_stage.position = Vector2(76, 82)
	house_stage.size = Vector2(860, 340)
	house_stage.clip_contents = true
	house_stage.z_index = 1
	house_stage.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#C09068"), Color("#533428"), 3, 8)
	)
	house_panel.add_child(house_stage)

	room_wall_rect = ColorRect.new()
	room_wall_rect.name = "RoomWall"
	room_wall_rect.position = Vector2.ZERO
	room_wall_rect.size = Vector2(860, 106)
	room_wall_rect.color = Color("#D7B89E")
	room_wall_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_wall_rect.z_index = 0
	house_stage.add_child(room_wall_rect)

	room_top_trim = ColorRect.new()
	room_top_trim.name = "RoomTopTrim"
	room_top_trim.position = Vector2(0, 102)
	room_top_trim.size = Vector2(860, 4)
	room_top_trim.color = Color("#8B5C44")
	room_top_trim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_top_trim.z_index = 2
	house_stage.add_child(room_top_trim)

	room_floor_rect = ColorRect.new()
	room_floor_rect.name = "RoomFloor"
	room_floor_rect.position = Vector2(0, 106)
	room_floor_rect.size = Vector2(860, 234)
	room_floor_rect.color = Color("#B9895F")
	room_floor_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_floor_rect.z_index = 0
	house_stage.add_child(room_floor_rect)

	room_bottom_shadow = ColorRect.new()
	room_bottom_shadow.name = "RoomBottomShadow"
	room_bottom_shadow.position = Vector2(0, 282)
	room_bottom_shadow.size = Vector2(860, 58)
	room_bottom_shadow.color = Color(0, 0, 0, 0.05)
	room_bottom_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_bottom_shadow.z_index = 1
	house_stage.add_child(room_bottom_shadow)

	# Window outside background
	room_window_outside = ColorRect.new()
	room_window_outside.name = "WindowOutside"
	room_window_outside.position = Vector2(520, 38)
	room_window_outside.size = Vector2(84, 52)
	room_window_outside.color = Color(0.75, 0.90, 1.0, 0.95)
	room_window_outside.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_window_outside.z_index = 3
	house_stage.add_child(room_window_outside)

	# Curtains
	var curtain_left: ColorRect = ColorRect.new()
	curtain_left.position = Vector2(500, 30)
	curtain_left.size = Vector2(18, 76)
	curtain_left.color = Color("#C7A1A5")
	curtain_left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	curtain_left.z_index = 4
	house_stage.add_child(curtain_left)

	var curtain_right: ColorRect = ColorRect.new()
	curtain_right.position = Vector2(608, 30)
	curtain_right.size = Vector2(18, 76)
	curtain_right.color = Color("#C7A1A5")
	curtain_right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	curtain_right.z_index = 4
	house_stage.add_child(curtain_right)

	room_rug_panel = Panel.new()
	room_rug_panel.name = "RoomRug"
	room_rug_panel.position = Vector2(300, 184)
	room_rug_panel.size = Vector2(220, 94)
	room_rug_panel.z_index = 2
	room_rug_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_rug_panel.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#D7BBB6"), Color("#956A6C"), 2, 16)
	)
	house_stage.add_child(room_rug_panel)

	room_night_overlay = ColorRect.new()
	room_night_overlay.name = "RoomNightOverlay"
	room_night_overlay.position = Vector2.ZERO
	room_night_overlay.size = house_stage.size
	room_night_overlay.color = Color(0.02, 0.04, 0.08, 0.0)
	room_night_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_night_overlay.z_index = 12
	house_stage.add_child(room_night_overlay)

	room_bed_glow = ColorRect.new()
	room_bed_glow.name = "BedGlow"
	room_bed_glow.position = Vector2(44, 128)
	room_bed_glow.size = Vector2(170, 110)
	room_bed_glow.color = Color(1.0, 0.76, 0.45, 0.0)
	room_bed_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_bed_glow.z_index = 13
	house_stage.add_child(room_bed_glow)

	room_desk_glow = ColorRect.new()
	room_desk_glow.name = "DeskGlow"
	room_desk_glow.position = Vector2(330, 134)
	room_desk_glow.size = Vector2(230, 138)
	room_desk_glow.color = Color(1.0, 0.84, 0.58, 0.0)
	room_desk_glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_desk_glow.z_index = 13
	house_stage.add_child(room_desk_glow)

	room_star_dots.clear()
	var star_positions: Array[Vector2] = [
		Vector2(532, 48),
		Vector2(555, 58),
		Vector2(586, 50),
		Vector2(542, 76),
		Vector2(578, 78)
	]
	
	for p in star_positions:
		var star: ColorRect = ColorRect.new()
		star.position = p
		star.size = Vector2(3, 3)
		star.color = Color(1, 0.98, 0.85, 0.0)
		star.visible = false
		star.mouse_filter = Control.MOUSE_FILTER_IGNORE
		star.z_index = 14
		house_stage.add_child(star)
		room_star_dots.append(star)

	refresh_room_mood()
	
func refresh_room_mood():
	if house_stage == null:
		return
	
	if room_wall_rect == null or room_floor_rect == null:
		return
	
	var day_wall: Color = Color("#D7B89E")
	var day_floor: Color = Color("#B9895F")
	var day_trim: Color = Color("#8B5C44")
	var day_rug: Color = Color("#D7BBB6")
	var day_rug_border: Color = Color("#956A6C")
	
	match house_style_index:
		0:
			day_wall = Color("#D7B89E")
			day_floor = Color("#B9895F")
			day_trim = Color("#8B5C44")
			day_rug = Color("#D7BBB6")
			day_rug_border = Color("#956A6C")
		1:
			day_wall = Color("#E8B9C7")
			day_floor = Color("#B98291")
			day_trim = Color("#8C5968")
			day_rug = Color("#FFD1E8")
			day_rug_border = Color("#B86F8B")
		2:
			day_wall = Color("#CFE4B8")
			day_floor = Color("#87A866")
			day_trim = Color("#5C7948")
			day_rug = Color("#B9E5A4")
			day_rug_border = Color("#6F9C5D")
		3:
			day_wall = Color("#C9C5EA")
			day_floor = Color("#77739A")
			day_trim = Color("#565177")
			day_rug = Color("#FFF1A8")
			day_rug_border = Color("#B7A55A")
	
	if room_is_night:
		room_wall_rect.color = day_wall.darkened(0.18)
		room_floor_rect.color = day_floor.darkened(0.20)
		room_top_trim.color = day_trim.darkened(0.16)
		room_bottom_shadow.color = Color(0, 0, 0, 0.16)
		
		room_window_outside.color = Color(0.12, 0.18, 0.34, 0.98)
		room_night_overlay.color = Color(0.02, 0.04, 0.08, 0.18)
		room_bed_glow.color = Color(1.0, 0.76, 0.45, 0.08)
		room_desk_glow.color = Color(1.0, 0.84, 0.58, 0.07)
		
		if room_rug_panel != null:
			room_rug_panel.add_theme_stylebox_override(
				"panel",
				make_panel_style(day_rug.darkened(0.12), day_rug_border.lightened(0.10), 2, 16)
			)
		
		for star in room_star_dots:
			if star != null:
				star.visible = true
				star.color = Color(1, 0.98, 0.85, 0.95)
		
		if house_info_text != null:
			house_info_text.text = "[center][color=#FFF4D6]夜晚模式已开启，靠近家具按 E 互动 / Cozy night mode is on, press E near furniture[/color][/center]"
	else:
		room_wall_rect.color = day_wall
		room_floor_rect.color = day_floor
		room_top_trim.color = day_trim
		room_bottom_shadow.color = Color(0, 0, 0, 0.05)
		
		room_window_outside.color = Color(0.75, 0.90, 1.0, 0.95)
		room_night_overlay.color = Color(0.02, 0.04, 0.08, 0.0)
		room_bed_glow.color = Color(1.0, 0.76, 0.45, 0.0)
		room_desk_glow.color = Color(1.0, 0.84, 0.58, 0.0)
		
		if room_rug_panel != null:
			room_rug_panel.add_theme_stylebox_override(
				"panel",
				make_panel_style(day_rug, day_rug_border, 2, 16)
			)
		
		for star in room_star_dots:
			if star != null:
				star.visible = false
				star.color = Color(1, 0.98, 0.85, 0.0)
		
		if house_info_text != null:
			house_info_text.text = "[center][color=#FFFFFF]在小屋里移动，靠近家具按 E 互动 / Move inside and press E near furniture[/color][/center]"
			

func create_house_room_objects():
	create_room_object(
		"bed",
		Vector2(68, 132),
		Vector2(120, 108),
		Color("#EAD6CF"),
		"床",
		"Bed",
		"睡一觉，进入新的一天。"
	)

	create_room_object(
		"photo_wall",
		Vector2(294, 24),
		Vector2(116, 58),
		Color("#F1D7CB"),
		"照片墙",
		"Photo Wall",
		"这里以后会放上你们的照片和回忆。"
	)

	create_room_object(
		"window",
		Vector2(500, 22),
		Vector2(126, 78),
		Color("#BFEAFF"),
		"窗户",
		"Window",
		"看看窗外，切换白天和夜晚。"
	)

	create_room_object(
		"bookshelf",
		Vector2(706, 58),
		Vector2(106, 112),
		Color("#8B5E3E"),
		"书架",
		"Bookshelf",
		"一本一本，都是温柔的小世界。"
	)

	create_room_object(
		"desk",
		Vector2(348, 158),
		Vector2(154, 64),
		Color("#9A6C49"),
		"学习桌",
		"Desk",
		"以后这里可以做语言学习、任务和鼓励。"
	)

	create_room_object(
		"diary",
		Vector2(398, 204),
		Vector2(44, 32),
		Color("#FFF2B6"),
		"日记本",
		"Diary",
		"里面藏着我留给你的小话。"
	)

	create_room_object(
		"plushie",
		Vector2(186, 236),
		Vector2(58, 58),
		Color("#E1AAB6"),
		"小玩偶",
		"Plushie",
		"抱一下它，就像我在陪你。"
	)

	create_room_object(
		"decor_chest",
		Vector2(578, 250),
		Vector2(50, 42),
		Color("#B88A58"),
		"装饰箱",
		"Decor Chest",
		"以后这里可以切换房间风格和皮肤。"
	)

	create_room_object(
		"plant",
		Vector2(648, 226),
		Vector2(42, 68),
		Color("#4F9E5A"),
		"小植物",
		"Plant",
		"一点点照顾，它就会慢慢长大。"
	)

	create_room_object(
		"wardrobe",
		Vector2(718, 202),
		Vector2(84, 112),
		Color("#6E4A38"),
		"衣柜",
		"Wardrobe",
		"以后这里可以换衣服和皮肤。"
	)

	create_room_object(
		"door",
		Vector2(814, 182),
		Vector2(38, 130),
		Color("#5A3324"),
		"门",
		"Door",
		"离开小屋，回到花园。"
	)

func create_decor_chest_details():
	add_stage_sprite(
		chest_texture,
		Rect2(0, 0, 32, 32),
		Vector2(634, 344),
		Vector2(2.4, 2.4),
		35
	)
	
	var sparkle: ColorRect = ColorRect.new()
	sparkle.position = Vector2(660, 304)
	sparkle.size = Vector2(12, 12)
	sparkle.color = Color("#FFF1A8")
	sparkle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(sparkle)

func create_room_object(
	id: String,
	pos: Vector2,
	size: Vector2,
	color: Color,
	zh_name: String,
	en_name: String,
	description: String
):
	var sprite_info: Dictionary = get_room_sprite_info(id)
	var has_sprite: bool = false
	
	if sprite_info.size() > 0:
		var texture_test: Texture2D = sprite_info["texture"]
		has_sprite = texture_test != null
	
	var panel: Panel = Panel.new()
	panel.name = "Obj_" + id
	panel.position = pos
	panel.size = size
	panel.visible = false
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = 10
	house_stage.add_child(panel)
	
	if has_sprite:
		var texture: Texture2D = sprite_info["texture"]
		var region: Rect2 = sprite_info["region"]
		var scale_value: Vector2 = sprite_info["scale"]
		var offset: Vector2 = sprite_info["offset"]
		
		var sprite: Sprite2D = create_region_sprite(
			texture,
			region,
			pos + size / 2.0 + offset,
			scale_value,
			20
		)
		
		sprite.name = "Sprite_" + id
		sprite.z_as_relative = true
		sprite.z_index = 30 + int(pos.y)
		house_stage.add_child(sprite)
	
	room_hotspots[id] = {
		"rect": Rect2(pos, size),
		"zh": zh_name,
		"en": en_name,
		"description": description,
		"node": panel
	}
	
	
func get_room_sprite_info(id: String) -> Dictionary:
	match id:
		"bed":
			return {
				"texture": pixel_beds_texture,
				"region": Rect2(0, 0, 64, 80),
				"scale": Vector2(1.55, 1.55),
				"offset": Vector2(0, -5)
			}
		"photo_wall":
			return {
				"texture": pixel_bedroom_decor_texture,
				"region": Rect2(128, 0, 64, 48),
				"scale": Vector2(1.35, 1.35),
				"offset": Vector2(0, 0)
			}
		"window":
			return {
				"texture": pixel_doors_windows_texture,
				"region": Rect2(192, 0, 64, 64),
				"scale": Vector2(1.45, 1.45),
				"offset": Vector2(0, 0)
			}
		"bookshelf":
			return {
				"texture": pixel_cabinets_texture,
				"region": Rect2(0, 0, 64, 64),
				"scale": Vector2(1.55, 1.55),
				"offset": Vector2(0, -3)
			}
		"desk":
			return {
				"texture": pixel_livingroom_texture,
				"region": Rect2(0, 128, 64, 48),
				"scale": Vector2(1.65, 1.65),
				"offset": Vector2(0, 0)
			}
		"wardrobe":
			return {
				"texture": pixel_wardrobes_texture,
				"region": Rect2(0, 0, 64, 96),
				"scale": Vector2(1.35, 1.35),
				"offset": Vector2(0, -4)
			}
		"plant":
			return {
				"texture": pixel_livingroom_decor_texture,
				"region": Rect2(0, 64, 32, 48),
				"scale": Vector2(1.45, 1.45),
				"offset": Vector2(0, -2)
			}
		"decor_chest":
			return {
				"texture": chest_texture,
				"region": Rect2(0, 0, 32, 32),
				"scale": Vector2(1.8, 1.8),
				"offset": Vector2(0, 0)
			}
		"door":
			return {
				"texture": pixel_doors_windows_texture,
				"region": Rect2(128, 0, 32, 64),
				"scale": Vector2(1.75, 1.75),
				"offset": Vector2(0, -4)
			}
		_:
			return {}
			
			
func create_bed_details():
	var blanket: ColorRect = ColorRect.new()
	blanket.position = Vector2(70, 155)
	blanket.size = Vector2(155, 60)
	blanket.color = Color("#A8D58A")
	blanket.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(blanket)
	
	var pillow: ColorRect = ColorRect.new()
	pillow.position = Vector2(230, 140)
	pillow.size = Vector2(38, 48)
	pillow.color = Color("#FFF4EA")
	pillow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(pillow)


func create_photo_wall_details():
	for i in range(3):
		var photo: ColorRect = ColorRect.new()
		photo.position = Vector2(345 + i * 42, 42)
		photo.size = Vector2(32, 42)
		photo.color = Color.from_hsv(0.55 + float(i) * 0.06, 0.18, 1.0)
		photo.mouse_filter = Control.MOUSE_FILTER_IGNORE
		house_stage.add_child(photo)


func create_desk_details():
	var paper: ColorRect = ColorRect.new()
	paper.position = Vector2(438, 150)
	paper.size = Vector2(54, 36)
	paper.color = Color("#FFF2B6")
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(paper)
	
	var lamp: ColorRect = ColorRect.new()
	lamp.position = Vector2(530, 142)
	lamp.size = Vector2(28, 54)
	lamp.color = Color("#F7D98A")
	lamp.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(lamp)


func create_bookshelf_details():
	for shelf in range(3):
		var line: ColorRect = ColorRect.new()
		line.position = Vector2(730, 82 + shelf * 48)
		line.size = Vector2(140, 7)
		line.color = Color("#5A3728")
		line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		house_stage.add_child(line)
	
	for i in range(12):
		var book: ColorRect = ColorRect.new()
		var shelf_index: int = i / 4
		var book_index: int = i % 4
		book.position = Vector2(738 + book_index * 28, 48 + shelf_index * 48)
		book.size = Vector2(18, 34)
		book.color = Color.from_hsv(float(i) / 12.0, 0.45, 0.90)
		book.mouse_filter = Control.MOUSE_FILTER_IGNORE
		house_stage.add_child(book)


func create_wardrobe_details():
	var split: ColorRect = ColorRect.new()
	split.position = Vector2(818, 285)
	split.size = Vector2(4, 120)
	split.color = Color("#4A2A20")
	split.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(split)
	
	var knob_left: ColorRect = ColorRect.new()
	knob_left.position = Vector2(805, 340)
	knob_left.size = Vector2(8, 8)
	knob_left.color = Color("#E6C37A")
	knob_left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(knob_left)
	
	var knob_right: ColorRect = ColorRect.new()
	knob_right.position = Vector2(830, 340)
	knob_right.size = Vector2(8, 8)
	knob_right.color = Color("#E6C37A")
	knob_right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(knob_right)


func create_window_details():
	var sky: ColorRect = ColorRect.new()
	sky.position = Vector2(565, 36)
	sky.size = Vector2(100, 58)
	sky.color = Color("#7ECDF2")
	sky.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(sky)
	
	var frame_v: ColorRect = ColorRect.new()
	frame_v.position = Vector2(612, 28)
	frame_v.size = Vector2(5, 76)
	frame_v.color = Color("#FFFFFF")
	frame_v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(frame_v)
	
	var frame_h: ColorRect = ColorRect.new()
	frame_h.position = Vector2(555, 62)
	frame_h.size = Vector2(120, 5)
	frame_h.color = Color("#FFFFFF")
	frame_h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(frame_h)


func create_plant_details():
	var pot: ColorRect = ColorRect.new()
	pot.position = Vector2(634, 375)
	pot.size = Vector2(72, 38)
	pot.color = Color("#9C6C46")
	pot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(pot)
	
	var leaf2: ColorRect = ColorRect.new()
	leaf2.position = Vector2(656, 295)
	leaf2.size = Vector2(24, 32)
	leaf2.color = Color("#70C96A")
	leaf2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(leaf2)


func create_plushie_details():
	var ear1: ColorRect = ColorRect.new()
	ear1.position = Vector2(150, 270)
	ear1.size = Vector2(22, 22)
	ear1.color = Color("#F4B6C2")
	ear1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(ear1)
	
	var ear2: ColorRect = ColorRect.new()
	ear2.position = Vector2(195, 270)
	ear2.size = Vector2(22, 22)
	ear2.color = Color("#F4B6C2")
	ear2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	house_stage.add_child(ear2)

func create_room_static_decor():
	var bedside: Panel = Panel.new()
	bedside.position = Vector2(190, 164)
	bedside.size = Vector2(28, 32)
	bedside.z_index = 42
	bedside.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bedside.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#936447"), Color("#5E3C29"), 2, 4)
	)
	house_stage.add_child(bedside)

	var lamp_base: ColorRect = ColorRect.new()
	lamp_base.position = Vector2(201, 153)
	lamp_base.size = Vector2(6, 10)
	lamp_base.color = Color("#6D4A31")
	lamp_base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lamp_base.z_index = 43
	house_stage.add_child(lamp_base)

	var lamp_head: Panel = Panel.new()
	lamp_head.position = Vector2(194, 140)
	lamp_head.size = Vector2(20, 14)
	lamp_head.z_index = 44
	lamp_head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lamp_head.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#F5D8A5"), Color("#A57F54"), 1, 4)
	)
	house_stage.add_child(lamp_head)

	var book1: ColorRect = ColorRect.new()
	book1.position = Vector2(466, 181)
	book1.size = Vector2(20, 6)
	book1.color = Color("#C9857C")
	book1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	book1.z_index = 76
	house_stage.add_child(book1)

	var book2: ColorRect = ColorRect.new()
	book2.position = Vector2(462, 175)
	book2.size = Vector2(24, 6)
	book2.color = Color("#7FA5C8")
	book2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	book2.z_index = 76
	house_stage.add_child(book2)

	var stool: Panel = Panel.new()
	stool.position = Vector2(410, 232)
	stool.size = Vector2(34, 24)
	stool.z_index = 70
	stool.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stool.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#A36E49"), Color("#67442D"), 2, 4)
	)
	house_stage.add_child(stool)

	var tiny_note: Panel = Panel.new()
	tiny_note.position = Vector2(330, 66)
	tiny_note.size = Vector2(22, 16)
	tiny_note.z_index = 34
	tiny_note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tiny_note.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#FFF1B8"), Color("#B78A55"), 1, 2)
	)
	house_stage.add_child(tiny_note)

	var heart: Label = Label.new()
	heart.position = Vector2(612, 262)
	heart.size = Vector2(30, 24)
	heart.text = "♡"
	heart.z_index = 92
	style_label(heart, 17, true, Color("#FFD1E8"), Color(0.1, 0.05, 0.05, 0.95))
	house_stage.add_child(heart)


func add_manual_diary_visual(pos: Vector2):
	var cover: Panel = Panel.new()
	cover.position = pos
	cover.size = Vector2(30, 22)
	cover.z_index = 120
	cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cover.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#B6875B"), Color("#6D4A31"), 2, 3)
	)
	house_stage.add_child(cover)

	var page: ColorRect = ColorRect.new()
	page.position = pos + Vector2(19, 3)
	page.size = Vector2(7, 16)
	page.color = Color("#F5EFD7")
	page.mouse_filter = Control.MOUSE_FILTER_IGNORE
	page.z_index = 121
	house_stage.add_child(page)

	var line1: ColorRect = ColorRect.new()
	line1.position = pos + Vector2(5, 7)
	line1.size = Vector2(11, 2)
	line1.color = Color("#D8C2A0")
	line1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line1.z_index = 122
	house_stage.add_child(line1)

	var line2: ColorRect = ColorRect.new()
	line2.position = pos + Vector2(5, 13)
	line2.size = Vector2(11, 2)
	line2.color = Color("#D8C2A0")
	line2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line2.z_index = 122
	house_stage.add_child(line2)


func add_manual_plushie_visual(pos: Vector2):
	var body: Panel = Panel.new()
	body.position = pos + Vector2(6, 14)
	body.size = Vector2(36, 34)
	body.z_index = 118
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	body.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#E9A9BA"), Color("#8E5966"), 2, 12)
	)
	house_stage.add_child(body)

	var ear_left: Panel = Panel.new()
	ear_left.position = pos + Vector2(5, 5)
	ear_left.size = Vector2(14, 18)
	ear_left.z_index = 117
	ear_left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ear_left.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#E9A9BA"), Color("#8E5966"), 2, 8)
	)
	house_stage.add_child(ear_left)

	var ear_right: Panel = Panel.new()
	ear_right.position = pos + Vector2(28, 5)
	ear_right.size = Vector2(14, 18)
	ear_right.z_index = 117
	ear_right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ear_right.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#E9A9BA"), Color("#8E5966"), 2, 8)
	)
	house_stage.add_child(ear_right)

	var face: Label = Label.new()
	face.position = pos + Vector2(6, 18)
	face.size = Vector2(36, 24)
	face.text = "• ᴗ •"
	face.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	face.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	face.z_index = 119
	style_label(face, 12, true, Color("#5C3540"), Color(1, 1, 1, 0.0))
	house_stage.add_child(face)

func create_house_room_player():
	room_player = ColorRect.new()
	room_player.name = "RoomPlayer"
	room_player.position = Vector2(520, 258)
	room_player.size = Vector2(30, 38)
	room_player.color = Color(1, 1, 1, 0.0)
	room_player.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_player.z_as_relative = true
	room_player.z_index = 800
	house_stage.add_child(room_player)
	
	room_player_sprite = Sprite2D.new()
	room_player_sprite.name = "RoomPlayerSprite"
	room_player_sprite.centered = true
	room_player_sprite.position = Vector2(15, 16)
	room_player_sprite.scale = Vector2(1.45, 1.45)
	room_player_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	room_player_sprite.z_as_relative = true
	room_player_sprite.z_index = 801
	room_player.add_child(room_player_sprite)
	
	if character_texture != null:
		room_player_sprite.texture = character_texture
		room_player_sprite.region_enabled = true
		set_room_player_frame("down", 0)
	else:
		room_player.color = get_room_outfit_color()
	
	room_player_label = Label.new()
	room_player_label.name = "RoomPlayerLabel"
	room_player_label.position = Vector2(-34, -34)
	room_player_label.size = Vector2(100, 24)
	room_player_label.text = "你 / You"
	room_player_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	room_player_label.z_index = 802
	style_label(room_player_label, 13, true)
	room_player.add_child(room_player_label)
	
	
func set_room_player_frame(direction: String, frame: int):
	if character_texture == null or room_player_sprite == null:
		return
	
	var row: int = 0
	
	match direction:
		"down":
			row = 0
		"up":
			row = 1
		"left":
			row = 2
		"right":
			row = 3
		_:
			row = 0
	
	var col: int = clampi(frame, 0, 3)
	room_player_sprite.region_rect = Rect2(
		float(col) * PLAYER_FRAME_SIZE.x,
		float(row) * PLAYER_FRAME_SIZE.y,
		PLAYER_FRAME_SIZE.x,
		PLAYER_FRAME_SIZE.y
	)


func update_room_player_animation(delta: float):
	if room_player_sprite == null:
		return
	
	if room_player_moving:
		room_player_anim_timer += delta
		
		if room_player_anim_timer >= 0.16:
			room_player_anim_timer = 0.0
			room_player_anim_frame = (room_player_anim_frame + 1) % 4
		
		set_room_player_frame(room_facing, room_player_anim_frame)
	else:
		room_player_anim_timer = 0.0
		room_player_anim_frame = 0
		set_room_player_frame(room_facing, 0)
		
		
func create_house_room_buttons():
	house_sleep_button = Button.new()
	house_sleep_button.position = Vector2(592, 522)
	house_sleep_button.size = Vector2(178, 36)
	house_sleep_button.text = "睡觉到明天 / Sleep"
	style_button(house_sleep_button, 16, true)
	house_panel.add_child(house_sleep_button)
	
	if not house_sleep_button.pressed.is_connected(_on_house_sleep_pressed):
		house_sleep_button.pressed.connect(_on_house_sleep_pressed)
	
	house_exit_button = Button.new()
	house_exit_button.position = Vector2(790, 522)
	house_exit_button.size = Vector2(178, 36)
	house_exit_button.text = "离开小屋 / Leave"
	style_button(house_exit_button, 16, true)
	house_panel.add_child(house_exit_button)
	
	if not house_exit_button.pressed.is_connected(close_house_interior):
		house_exit_button.pressed.connect(close_house_interior)


func create_house_room_hint():
	var info_bg: Panel = Panel.new()
	info_bg.position = Vector2(30, 522)
	info_bg.size = Vector2(540, 36)
	info_bg.z_index = 300
	info_bg.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.12, 0.10, 0.10, 0.72), Color(0.95, 0.82, 0.75, 0.30), 1, 8)
	)
	house_panel.add_child(info_bg)
	
	house_info_text = RichTextLabel.new()
	house_info_text.position = Vector2(8, 4)
	house_info_text.size = Vector2(524, 28)
	house_info_text.bbcode_enabled = true
	house_info_text.scroll_active = false
	house_info_text.fit_content = false
	style_rich_text(house_info_text, 16)
	house_info_text.text = "[center][color=#FFFFFF]在小屋里移动，靠近家具按 E 互动 / Move inside and press E near furniture[/color][/center]"
	info_bg.add_child(house_info_text)
	
	room_hint = Label.new()
	room_hint.position = Vector2(300, 468)
	room_hint.size = Vector2(420, 34)
	room_hint.text = ""
	room_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	room_hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	room_hint.z_index = 500
	style_label(room_hint, 17, true, Color.WHITE, Color(0.1, 0.05, 0.02, 0.95))
	house_panel.add_child(room_hint)
	
	room_highlight = Panel.new()
	room_highlight.name = "RoomHighlight"
	room_highlight.visible = false
	room_highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
	room_highlight.z_index = 480
	room_highlight.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(1, 1, 1, 0.08), Color("#FFD1E8"), 2, 8)
	)
	house_stage.add_child(room_highlight)
	
	room_hover_label = Label.new()
	room_hover_label.name = "RoomHoverLabel"
	room_hover_label.visible = false
	room_hover_label.size = Vector2(240, 30)
	room_hover_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	room_hover_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	room_hover_label.z_index = 520
	style_label(room_hover_label, 16, true, Color.WHITE, Color(0.1, 0.05, 0.02, 0.98))
	house_stage.add_child(room_hover_label)
	

func open_house_interior():
	if house_panel != null:
		house_panel.visible = true
		room_target_id = ""
		
		if room_player != null:
			room_player.position = Vector2(520, 258)
		
		refresh_house_room_visuals()
		refresh_room_mood()


func close_house_interior():
	if house_panel != null:
		house_panel.visible = false


func _on_house_sleep_pressed():
	close_house_interior()
	sleep_next_day()
	
# ============================================================
# HOUSE ROOM MOVEMENT + INTERACTIONS
# ============================================================

func update_house_room(delta: float):
	if house_panel == null:
		return
	
	if not house_panel.visible:
		return
	
	if message_panel != null and message_panel.visible:
		room_player_moving = false
		update_room_player_animation(delta)
		return
	
	if room_player == null:
		return
	
	var input_vector: Vector2 = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	room_player_moving = input_vector.length() > 0.01
	
	if room_player_moving:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				room_facing = "right"
			else:
				room_facing = "left"
		else:
			if input_vector.y > 0:
				room_facing = "down"
			else:
				room_facing = "up"
		
		input_vector = input_vector.normalized()
	
	var new_pos: Vector2 = room_player.position + input_vector * room_speed * delta
	
	new_pos.x = clampf(new_pos.x, 28.0, 812.0)
	new_pos.y = clampf(new_pos.y, 114.0, 292.0)

	room_player.position = new_pos
	
	update_room_player_animation(delta)
	update_room_target()
	
	
func update_room_target():
	room_target_id = ""
	
	if room_hint == null or room_player == null:
		return
	
	var player_center: Vector2 = room_player.position + room_player.size / 2.0
	var mouse_local: Vector2 = house_stage.get_local_mouse_position()
	var best_distance: float = 999999.0
	
	for id in room_hotspots.keys():
		var data: Dictionary = room_hotspots[id]
		var rect: Rect2 = data["rect"]
		
		var expanded_amount: float = 50.0
		
		if id == "photo_wall" or id == "window":
			expanded_amount = 125.0
		
		var expanded: Rect2 = rect.grow(expanded_amount)
		var mouse_rect: Rect2 = rect.grow(10.0)
		
		var is_mouse_hovering: bool = mouse_rect.has_point(mouse_local)
		var is_player_near: bool = expanded.has_point(player_center)
		
		if not is_mouse_hovering and not is_player_near:
			continue
		
		var center: Vector2 = rect.position + rect.size / 2.0
		var distance: float = player_center.distance_to(center)
		
		if is_mouse_hovering:
			distance = -1.0
		
		if distance < best_distance:
			best_distance = distance
			room_target_id = str(id)
	
	if room_target_id == "":
		room_hint.text = ""
		
		if room_highlight != null:
			room_highlight.visible = false
		
		if room_hover_label != null:
			room_hover_label.visible = false
		
		return
	
	var target: Dictionary = room_hotspots[room_target_id]
	var target_rect: Rect2 = target["rect"]
	
	room_hint.text = "按 E 互动：%s / %s" % [
		str(target["zh"]),
		str(target["en"])
	]
	
	if room_highlight != null:
		room_highlight.visible = true
		room_highlight.position = target_rect.position
		room_highlight.size = target_rect.size
	
	if room_hover_label != null:
		room_hover_label.visible = true
		room_hover_label.text = "%s / %s" % [
			str(target["zh"]),
			str(target["en"])
		]
		room_hover_label.position = Vector2(
			target_rect.position.x + target_rect.size.x / 2.0 - 120,
			target_rect.position.y - 32
		)
	

func interact_room_target():
	update_room_target()
	
	if room_target_id == "":
		show_toast("靠近家具再按 E / Move closer to furniture")
		return
	
	match room_target_id:
		"bed":
			interact_room_bed()
		"photo_wall":
			interact_room_photo_wall()
		"desk":
			interact_room_desk()
		"bookshelf":
			interact_room_bookshelf()
		"wardrobe":
			interact_room_wardrobe()
		"window":
			interact_room_window()
		"plant":
			interact_room_plant()
		"plushie":
			interact_room_plushie()
		"diary":
			interact_room_diary()
		"door":
			close_house_interior()
		"decor_chest":
			interact_room_decor_chest()
		_:
			show_toast("这里以后会有更多互动 / More interaction later")

func interact_room_decor_chest():
	house_style_index = (house_style_index + 1) % 4
	refresh_house_room_visuals()
	
	show_message(
		"小屋皮肤已切换",
		"House skin changed",
		"你打开装饰箱，换了一种小屋风格。\n\n以后这里可以做成真正的家具皮肤包：粉色房间、森林房间、星空房间、冬日房间，还有你们照片主题的小屋。",
		"You opened the decor chest and changed the room style.\n\nLater this can become real house skin packs: pink room, forest room, starry room, winter room, and a photo-themed room for both of you."
	)
	
	save_game()

func interact_room_bed():
	show_message(
		"柔软的小床",
		"Soft little bed",
		"这里是休息的地方。睡一觉以后，花园会进入新的一天，植物会长大，小动物也可能准备好小礼物。\n\n点击小屋右下角的“睡觉到明天”，就可以正式睡觉。",
		"This is the resting place. After sleeping, the garden moves to a new day, plants grow, and animals may prepare little gifts.\n\nPress the Sleep button in the lower-right corner of the house to sleep."
	)


func interact_room_photo_wall():
	house_memory_count += 1
	
	var zh_lines: Array = [
		"这面照片墙以后可以放你们的旅行照片、截图、可爱的回忆，甚至每张照片都可以点开一封小信。",
		"她靠近照片墙的时候，房间好像安静了一点，因为这里放着那些被认真珍惜过的瞬间。",
		"有些照片不是为了证明什么，只是为了提醒她：她一直被温柔地放在心里。"
	]
	
	var en_lines: Array = [
		"This photo wall can later hold travel photos, screenshots, cute memories, and even a small letter behind each photo.",
		"When she gets close to the photo wall, the room feels quieter, because these are the little moments someone carefully treasured.",
		"Some photos are not here to prove anything. They are here to remind her that she is gently kept in someone’s heart."
	]
	
	var index: int = house_memory_count % zh_lines.size()
	
	show_message(
		"照片墙",
		"Photo Wall",
		str(zh_lines[index]),
		str(en_lines[index])
	)
	
	save_game()


func interact_room_desk():
	show_message(
		"学习桌",
		"Study Desk",
		"这里以后可以做成一个小小的语言学习角：法语、英语、鼓励语、每日一句，还有你想对她说的“今天也很棒”。\n\n今天的小提示：慢慢来就很好，不需要一下子做到完美。",
		"This can become a tiny language-learning corner: French, English, encouragement, daily phrases, and a little ‘you did well today’ from you.\n\nToday’s tiny reminder: going slowly is already good. She does not have to be perfect all at once."
	)


func interact_room_bookshelf():
	var zh_books: Array = [
		"你从书架上抽出一本小书，里面写着：被爱不是任务，是可以慢慢相信的事情。",
		"书页里夹着一张纸条：今天也要好好吃饭，好好休息，好好被我喜欢。",
		"这本书的标题是《如何把一个小花园变成一个家》。第一页只有一句话：和你在一起就可以。"
	]
	
	var en_books: Array = [
		"You pull a small book from the shelf. It says: being loved is not a task; it is something she can slowly learn to trust.",
		"A tiny note is hidden between the pages: eat well today, rest well today, and let yourself be loved by me today.",
		"The book is titled How to Turn a Little Garden Into a Home. The first page says only one thing: being with you is enough."
	]
	
	var index: int = randi() % zh_books.size()
	
	show_message(
		"书架",
		"Bookshelf",
		str(zh_books[index]),
		str(en_books[index])
	)


func interact_room_wardrobe():
	house_outfit_index = (house_outfit_index + 1) % 5
	refresh_house_room_visuals()
	
	var outfit_name_zh: String = get_outfit_name_zh()
	var outfit_name_en: String = get_outfit_name_en()
	
	show_toast("换成了 %s / Changed to %s" % [outfit_name_zh, outfit_name_en])
	save_game()


func interact_room_window():
	room_is_night = !room_is_night
	refresh_room_mood()

	if room_is_night:
		show_message(
			"夜晚降临了",
			"Night has come",
			"窗外慢慢暗了下来，小屋里也变得更安静、更温暖了。现在这里像一个可以安心躲进去的小世界。",
			"The outside slowly turned dark, and the room became quieter and warmer. Now it feels like a tiny little world where she can rest."
		)
	else:
		show_message(
			"天亮啦",
			"Daylight is back",
			"阳光又回来了，窗边亮了起来，小屋也恢复成轻柔明亮的样子。",
			"The daylight came back, the window brightened up, and the room returned to its soft and gentle daytime mood."
		)

	save_game()


func interact_room_plant():
	house_plant_level += 1
	
	var zh: String = "你给小植物浇了一点水。"
	var en: String = "You watered the little plant."
	
	if house_plant_level >= 3:
		zh += "\n它好像长大了一点点，就像这个小房间也在慢慢变成家。"
		en += "\nIt seems to have grown a tiny bit, just like this little room is slowly becoming a home."
	
	show_message(
		"小植物",
		"Little plant",
		zh,
		en
	)
	
	save_game()


func interact_room_plushie():
	show_message(
		"小玩偶",
		"Little plushie",
		"你抱了抱小玩偶。它软软的，安安静静的，好像在替我陪着她。\n\n它的任务很简单：在我不在身边的时候，也要提醒她，她不是一个人。",
		"You hugged the little plushie. It is soft and quiet, almost like it is keeping her company for me.\n\nIts job is simple: when I am not beside her, it reminds her she is not alone."
	)


func interact_room_diary():
	house_diary_entries += 1
	
	var zh_text: String = ""
	var en_text: String = ""
	
	match house_diary_entries % 4:
		0:
			zh_text = "日记本里写着：今天也想把世界变小一点，小到只够放下你、我、一个小花园和一个温暖的小家。"
			en_text = "The diary says: today I want to make the world a little smaller, small enough to hold only you, me, a little garden, and a warm little home."
		1:
			zh_text = "日记本里写着：她认真生活的样子很可爱。她努力、犹豫、害怕、又继续往前走的样子，都值得被抱抱。"
			en_text = "The diary says: the way she tries to live seriously is lovely. Her effort, hesitation, fear, and still moving forward all deserve a hug."
		2:
			zh_text = "日记本里写着：以后这里会藏很多封信。不是一次性给完，而是让她每次回来，都能找到一点新的爱。"
			en_text = "The diary says: many letters will be hidden here later. Not all at once, but little by little, so every time she comes back, she can find new love."
		_:
			zh_text = "日记本里写着：如果她今天累了，就先休息。小花园不会跑掉，我也不会。"
			en_text = "The diary says: if she is tired today, she can rest first. The little garden will not run away, and neither will I."
	
	show_message(
		"日记本",
		"Diary",
		zh_text,
		en_text
	)
	
	save_game()


func refresh_house_room_visuals():
	apply_house_theme()
	
	if room_player != null:
		room_player.color = Color(1, 1, 1, 0.0)
	
	if room_player_sprite != null:
		room_player_sprite.modulate = get_room_outfit_color()
	
	if house_title != null:
		house_title.text = "我们的温馨小屋 / Our Cozy Little House"
	
	if house_info_text != null:
		house_info_text.text = "[center][color=#FFFFFF]在小屋里移动，靠近家具按 E 互动 / Move inside and press E near furniture[/color][/center]"
	
	refresh_room_mood()

func apply_house_theme():
	refresh_room_mood()
	if house_stage == null:
		return
	
	var floor: ColorRect = house_stage.get_node_or_null("RoomFloor") as ColorRect
	var wall: ColorRect = house_stage.get_node_or_null("BackWall") as ColorRect
	var rug: Panel = house_stage.get_node_or_null("Rug") as Panel
	
	var floor_color: Color = Color("#B7865E")
	var wall_color: Color = Color("#D7B69B")
	var rug_color: Color = Color("#D8B7A8")
	
	match house_style_index:
		0:
			floor_color = Color("#B7865E")
			wall_color = Color("#D7B69B")
			rug_color = Color("#D8B7A8")
		1:
			floor_color = Color("#A46B78")
			wall_color = Color("#F0C6D2")
			rug_color = Color("#FFD1E8")
		2:
			floor_color = Color("#6F8F68")
			wall_color = Color("#CFE8B6")
			rug_color = Color("#A8D58A")
		3:
			floor_color = Color("#5A587A")
			wall_color = Color("#CFCBFF")
			rug_color = Color("#FFF1A8")
	
	if floor != null:
		floor.color = floor_color
	
	if wall != null:
		wall.color = wall_color
	
	if rug != null:
		rug.add_theme_stylebox_override(
			"panel",
			make_panel_style(rug_color, Color(0.40, 0.24, 0.24, 0.70), 2, 18)
		)
		
		
		
func get_room_outfit_color() -> Color:
	match house_outfit_index:
		0:
			return Color("#FFB6D9")
		1:
			return Color("#A8D8FF")
		2:
			return Color("#B9F7B5")
		3:
			return Color("#F7D58A")
		4:
			return Color("#D8B6FF")
		_:
			return Color("#FFB6D9")


func get_outfit_name_zh() -> String:
	match house_outfit_index:
		0:
			return "粉色小衣服"
		1:
			return "蓝色小衣服"
		2:
			return "绿色小衣服"
		3:
			return "暖黄色小衣服"
		4:
			return "紫色小衣服"
		_:
			return "粉色小衣服"


func get_outfit_name_en() -> String:
	match house_outfit_index:
		0:
			return "pink outfit"
		1:
			return "blue outfit"
		2:
			return "green outfit"
		3:
			return "warm yellow outfit"
		4:
			return "purple outfit"
		_:
			return "pink outfit"
			
			
# ============================================================
# WORLD BUILDING
# ============================================================
func setup_house_v2():
	var house_v2_script: Script = load("res://scripts/house_v2/house_v2.gd") as Script
	
	if house_v2_script == null:
		push_error("Could not load House V2 script.")
		return
	
	house_v2 = house_v2_script.new() as CanvasLayer
	
	if house_v2 == null:
		push_error("Could not create House V2.")
		return
	
	house_v2.name = "HouseV2"
	add_child(house_v2)
	if house_v2.has_signal("sleep_requested"):
		house_v2.connect("sleep_requested", Callable(self, "_on_house_v2_sleep_requested"))


# ============================================================
# WORLD TEXTURE PACK LOADING
# ============================================================

func safe_load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path)
	return null


func load_world_texture_pack():
	var base_path: String = "res://assets/world/%s/" % world_texture_pack_name
	
	tex_big_house_body = safe_load_texture(base_path + "big_house_body.png")
	tex_big_house_roof = safe_load_texture(base_path + "big_house_roof.png")
	tex_big_house_door = safe_load_texture(base_path + "big_house_door.png")
	tex_big_house_window = safe_load_texture(base_path + "big_house_window.png")
	tex_big_house_flowerbox = safe_load_texture(base_path + "big_house_flowerbox.png")
	tex_big_house_bush = safe_load_texture(base_path + "big_house_bush.png")
	tex_big_house_chimney = safe_load_texture(base_path + "big_house_chimney.png")


func build_world():
	clear_children(decoration_layer)
	background.color = seasons[season_index]["color"]
	
	add_rect(decoration_layer, "MainPath", Vector2(190, 405), Vector2(1320, 86), Color("#D4B07A"), 0)
	add_rect(decoration_layer, "VerticalPath", Vector2(1060, 150), Vector2(86, 720), Color("#D4B07A"), 0)
	add_rect(decoration_layer, "FieldBase", FARM_ORIGIN + Vector2(-36, -36), Vector2(404, 404), Color("#8EBB6E"), 0)
	
	add_rect(decoration_layer, "HouseGround", Vector2(120, 92), Vector2(330, 235), Color("#C7E59F"), 0)

	# Big house moved to the lower-left open area
	var season_ground_color: Color = seasons[season_index]["color"]
	add_rect(decoration_layer, "BigHouseGround", Vector2(260, 770), Vector2(500, 395), season_ground_color, 0)
	add_rect(decoration_layer, "BigHousePath", Vector2(455, 490), Vector2(70, 345), Color("#D4B07A"), 0)
	add_rect(decoration_layer, "BigHousePathLeftEdge", Vector2(448, 490), Vector2(7, 345), Color("#C19A64"), 0)
	add_rect(decoration_layer, "BigHousePathRightEdge", Vector2(525, 490), Vector2(7, 345), Color("#C19A64"), 0)
	add_rect(decoration_layer, "ShopGround", Vector2(1150, 155), Vector2(260, 345), Color("#C7E59F"), 0)

	add_animal_pen_decoration()
	add_water_area()
	add_map_flowers()
	add_tree_blocks()
	add_soft_edges()
	
	add_stage3_farm_map_polish()
	setup_decor_interactions()

func add_stage3_farm_map_polish():
	var script_path: String = "res://scripts/stage3_farm_map_polish.gd"
	
	if not ResourceLoader.exists(script_path):
		push_warning("Stage 3 farm polish script not found: " + script_path)
		return
	
	var polish_script: Script = load(script_path) as Script
	
	if polish_script == null:
		push_warning("Could not load Stage 3 farm polish script.")
		return
	
	var polish_node: Node2D = Node2D.new()
	polish_node.name = "Stage3FarmMapPolish"
	polish_node.set_script(polish_script)
	
	# Important:
	# Add it to decoration_layer, NOT World.
	# decoration_layer is already behind farm plots, buildings, animals, and player.
	decoration_layer.add_child(polish_node)

func add_animal_pen_decoration():
	var pen_pos: Vector2 = Vector2(820, 585)
	var pen_size: Vector2 = Vector2(400, 285)
	
	add_rect(decoration_layer, "AnimalPenGround", pen_pos, pen_size, Color("#DDEEBB"), 0)
	add_rect(decoration_layer, "FenceTop", pen_pos + Vector2(-8, -8), Vector2(pen_size.x + 16, 8), Color("#9A6B43"), 2)
	add_rect(decoration_layer, "FenceBottom", pen_pos + Vector2(-8, pen_size.y), Vector2(pen_size.x + 16, 8), Color("#9A6B43"), 2)
	add_rect(decoration_layer, "FenceLeft", pen_pos + Vector2(-8, -8), Vector2(8, pen_size.y + 16), Color("#9A6B43"), 2)
	add_rect(decoration_layer, "FenceRight", pen_pos + Vector2(pen_size.x, -8), Vector2(8, pen_size.y + 16), Color("#9A6B43"), 2)


func add_water_area():
	add_rect(decoration_layer, "SmallPond", Vector2(260, 555), Vector2(155, 100), Color("#79BDE8"), 1)
	add_rect(decoration_layer, "PondShine", Vector2(282, 578), Vector2(58, 10), Color("#BFEAFF"), 2)


func add_map_flowers():
	var flower_positions: Array = [
		Vector2(160, 730), Vector2(280, 860), Vector2(420, 745),
		Vector2(590, 900), Vector2(760, 770), Vector2(930, 885),
		Vector2(1260, 735), Vector2(1370, 860), Vector2(1530, 700),
		Vector2(1570, 940), Vector2(90, 950), Vector2(690, 700),
		Vector2(1430, 500), Vector2(1450, 580), Vector2(1550, 420),
		Vector2(460, 180), Vector2(520, 150), Vector2(615, 180)
	]
	
	for i in range(flower_positions.size()):
		add_rect(decoration_layer, "Flower%d" % i, flower_positions[i], Vector2(18, 18), Color("#F5A6C8"), 2)


func add_tree_blocks():
	add_rect(decoration_layer, "TreeBlock1", Vector2(70, 780), Vector2(70, 90), Color("#5FA65B"), 2)
	add_rect(decoration_layer, "TreeBlock2", Vector2(1470, 125), Vector2(90, 110), Color("#5FA65B"), 2)
	add_rect(decoration_layer, "TreeBlock3", Vector2(1520, 280), Vector2(70, 90), Color("#5FA65B"), 2)
	add_rect(decoration_layer, "TreeBlock4", Vector2(90, 150), Vector2(85, 95), Color("#5FA65B"), 2)


func add_soft_edges():
	add_rect(decoration_layer, "MapLeftEdge", Vector2.ZERO, Vector2(26, WORLD_SIZE.y), Color("#7BB569"), 3)
	add_rect(decoration_layer, "MapRightEdge", Vector2(WORLD_SIZE.x - 26, 0), Vector2(26, WORLD_SIZE.y), Color("#7BB569"), 3)
	add_rect(decoration_layer, "MapTopEdge", Vector2.ZERO, Vector2(WORLD_SIZE.x, 26), Color("#7BB569"), 3)
	add_rect(decoration_layer, "MapBottomEdge", Vector2(0, WORLD_SIZE.y - 26), Vector2(WORLD_SIZE.x, 26), Color("#7BB569"), 3)


func add_rect(parent: Node, node_name: String, pos: Vector2, size: Vector2, color: Color, z: int) -> ColorRect:
	var rect: ColorRect = ColorRect.new()
	rect.name = node_name
	rect.position = pos
	rect.size = size
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.z_index = z
	parent.add_child(rect)
	return rect


func clear_children(node: Node):
	if node == null:
		return
	
	for child in node.get_children():
		child.queue_free()


# ============================================================
# PLAYER
# ============================================================

func setup_player():
	player.global_position = PLAYER_START
	player.z_as_relative = false
	player.z_index = int(player.global_position.y)
	
	player_sprite.visible = true
	player_sprite.centered = true
	player_sprite.scale = PLAYER_SPRITE_SCALE
	player_sprite.position = Vector2(0, -24)
	player_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	if character_texture != null:
		player_sprite.texture = character_texture
		player_sprite.region_enabled = true
		set_player_frame("down", 0)
	else:
		player_sprite.texture = null
		create_player_fallback()


func create_player_fallback():
	var existing: Node = player.get_node_or_null("PlayerFallback")
	if existing != null:
		return
	
	var fallback: Polygon2D = Polygon2D.new()
	fallback.name = "PlayerFallback"
	fallback.polygon = PackedVector2Array([
		Vector2(-12, -18),
		Vector2(12, -18),
		Vector2(12, 18),
		Vector2(-12, 18)
	])
	fallback.color = Color("#FFB6D9")
	player.add_child(fallback)


func set_player_frame(direction: String, frame: int):
	if character_texture == null:
		return
	
	var row: int = 0
	
	match direction:
		"down":
			row = 0
		"up":
			row = 1
		"left":
			row = 2
		"right":
			row = 3
		_:
			row = 0
	
	var col: int = clampi(frame, 0, 3)
	player_sprite.region_rect = Rect2(
		float(col) * PLAYER_FRAME_SIZE.x,
		float(row) * PLAYER_FRAME_SIZE.y,
		PLAYER_FRAME_SIZE.x,
		PLAYER_FRAME_SIZE.y
	)


func update_player_animation(delta: float):
	if action_timer > 0.0:
		return
	
	if player_moving:
		player_anim_timer += delta
		
		if player_anim_timer >= 0.16:
			player_anim_timer = 0.0
			player_anim_frame = (player_anim_frame + 1) % 4
		
		set_player_frame(facing, player_anim_frame)
	else:
		player_anim_timer = 0.0
		player_anim_frame = 0
		set_player_frame(facing, 0)


func start_action(kind: String):
	action_kind = kind
	action_timer = 0.34
	
	match kind:
		"plant":
			action_label.text = "🌱"
		"water":
			action_label.text = "💧"
		"harvest":
			action_label.text = "✨"
		"feed":
			action_label.text = "🥣"
		"pet":
			action_label.text = "♡"
		"collect":
			action_label.text = "🎁"
		"sleep":
			action_label.text = "💤"
		"buy":
			action_label.text = "🪙"
		"sell":
			action_label.text = "💰"
		_:
			action_label.text = "!"
	
	action_label.visible = true
	player_sprite.modulate = Color(1.25, 1.25, 1.25, 1.0)


func update_action_animation(delta: float):
	if action_timer <= 0.0:
		action_label.visible = false
		player_sprite.modulate = Color.WHITE
		return
	
	action_timer -= delta
	
	var screen_pos: Vector2 = world_to_screen(player.global_position + Vector2(-8, -74))
	action_label.position = screen_pos
	
	if action_timer <= 0.0:
		action_label.visible = false
		player_sprite.modulate = Color.WHITE


# ============================================================
# FARM PLOTS
# ============================================================

func create_farm_plots():
	clear_children(farm_layer)
	plot_nodes.clear()
	plots.clear()
	
	for row in range(FARM_ROWS):
		for col in range(FARM_COLS):
			var index: int = row * FARM_COLS + col
			var pos: Vector2 = FARM_ORIGIN + Vector2(float(col) * PLOT_SPACING.x, float(row) * PLOT_SPACING.y)
			
			var plot_node: Area2D = create_plot_node(index, pos)
			plot_nodes.append(plot_node)
			plots.append(new_plot_state())


func new_plot_state() -> Dictionary:
	return {
		"crop": "",
		"growth": 0,
		"watered": false,
		"ready": false
	}


func create_plot_node(index: int, pos: Vector2) -> Area2D:
	var area: Area2D = Area2D.new()
	area.name = "Plot%d" % (index + 1)
	area.position = pos
	farm_layer.add_child(area)
	
	var shape: CollisionShape2D = CollisionShape2D.new()
	shape.name = "CollisionShape2D"
	var rect_shape: RectangleShape2D = RectangleShape2D.new()
	rect_shape.size = PLOT_SIZE
	shape.shape = rect_shape
	area.add_child(shape)
	
	var soil: Sprite2D = Sprite2D.new()
	soil.name = "SoilSprite"
	soil.centered = true
	soil.scale = Vector2(3.25, 3.25)
	soil.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	if dirt_texture != null:
		soil.texture = dirt_texture
		soil.region_enabled = true
		soil.region_rect = Rect2(0, 0, 16, 16)
	
	area.add_child(soil)
	
	var fallback: ColorRect = ColorRect.new()
	fallback.name = "FallbackSoil"
	fallback.position = -PLOT_SIZE / 2.0
	fallback.size = PLOT_SIZE
	fallback.color = Color("#9A6B43")
	fallback.visible = dirt_texture == null
	fallback.mouse_filter = Control.MOUSE_FILTER_IGNORE
	area.add_child(fallback)
	
	var plant: Sprite2D = Sprite2D.new()
	plant.name = "PlantSprite"
	plant.centered = true
	plant.scale = Vector2(3, 3)
	plant.position = Vector2(0, -10)
	plant.visible = false
	plant.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	area.add_child(plant)
	
	var label: Label = Label.new()
	label.name = "PlotLabel"
	label.position = Vector2(-44, 22)
	label.size = Vector2(88, 34)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	style_label(label, 14, true, Color.WHITE, Color(0.1, 0.05, 0.02, 0.95))
	area.add_child(label)
	
	return area



# ============================================================
# WORLD DECOR INTERACTIONS — extra cozy map hotspots
# ============================================================

func setup_decor_interactions():
	decor_interactions.clear()
	add_decor_interaction("starter_house_garden", Rect2(110, 90, 360, 250), "小屋花园", "Little House Garden", "这里是最早的小家。花、草和路都还很简单，但它像一个温柔的开始。", "This is the first little home. The flowers, grass, and path are simple, but it feels like a gentle beginning.")
	add_decor_interaction("pond", Rect2(235, 530, 210, 145), "池塘", "Pond", "池塘水很安静。以后这里可以做钓鱼、许愿、或者坐在水边休息的小互动。", "The pond is quiet. Later this can become a fishing, wishing, or resting-by-the-water interaction.")
	add_decor_interaction("farm_sign", Rect2(FARM_ORIGIN + Vector2(-120, -70), Vector2(110, 100)), "农场牌子", "Farm Sign", "牌子上写着：慢慢种，慢慢长大，慢慢把这里变成家。", "The sign says: plant slowly, grow slowly, and slowly turn this place into a home.")
	add_decor_interaction("animal_yard", Rect2(820, 585, 400, 285), "动物围栏", "Animal Yard", "这里的小动物喜欢被喂、被摸摸。照顾它们以后，它们会用鸡蛋和牛奶回报她。", "The animals like being fed and petted. If she cares for them, they answer with eggs and milk.")
	add_decor_interaction("shop_hint", Rect2(1120, 140, 330, 210), "商店区域", "Shop Area", "这里可以买种子和饲料。按数字 1-6 选择种子，再靠近商店按 E 购买。", "Here she can buy seeds and feed. Press 1-6 to select a seed, then press E near the shop to buy it.")
	add_decor_interaction("storage_hint", Rect2(1120, 340, 330, 210), "仓库区域", "Storage Area", "这里可以卖掉收获。靠近仓库按 E，或者按 V 快速卖出仓库里的东西。", "Here she can sell harvests. Press E near storage, or press V to quickly sell what is stored.")
	add_decor_interaction("big_house_garden", Rect2(250, 760, 560, 410), "大房子花园", "Big House Garden", "这里会慢慢变成最温馨的地方：大房子、卧室、客厅、厨房、浴室，还有她的日记和回忆。", "This will slowly become the warmest place: the big house, bedroom, living room, kitchen, bathroom, diary, and memories.")
	add_decor_interaction("memory_corner", Rect2(1480, 790, 300, 220), "回忆角", "Memory Corner", "这里以后可以放照片、信件、小彩蛋，像一个只属于你们的小秘密角落。", "Later this corner can hold photos, letters, and secrets, like a tiny place only for both of you.")


func add_decor_interaction(id: String, rect: Rect2, zh: String, en: String, body_zh: String, body_en: String):
	decor_interactions[id] = {
		"rect": rect,
		"zh": zh,
		"en": en,
		"body_zh": body_zh,
		"body_en": body_en
	}


func interact_decor(id: String):
	if not decor_interactions.has(id):
		return
	var data: Dictionary = decor_interactions[id]
	show_message(str(data["zh"]), str(data["en"]), str(data["body_zh"]), str(data["body_en"]))

# ============================================================
# BUILDINGS
# ============================================================

func create_buildings():
	clear_children(building_layer)
	building_nodes.clear()
	
	building_nodes["house"] = create_building("house", Vector2(285, 190), Vector2(205, 150), Color("#C9824A"), "小屋\nHouse")
	building_nodes["shop"] = create_building("shop", Vector2(1260, 255), Vector2(145, 112), Color("#D98A4A"), "商店\nShop")
	building_nodes["storage"] = create_building("storage", Vector2(1260, 395), Vector2(145, 112), Color("#8B5A3C"), "仓库\nStorage")
	building_nodes["well"] = create_building("well", Vector2(335, 585), Vector2(100, 100), Color("#6EA7C8"), "水井\nWell")
	building_nodes["big_house"] = create_big_house_v2(Vector2(290, 835))

func create_building(id: String, pos: Vector2, size: Vector2, color: Color, text: String) -> Area2D:
	var area: Area2D = Area2D.new()
	area.name = id
	area.position = pos
	building_layer.add_child(area)
	
	var shape: CollisionShape2D = CollisionShape2D.new()
	var rect_shape: RectangleShape2D = RectangleShape2D.new()
	rect_shape.size = size
	shape.shape = rect_shape
	area.add_child(shape)
	
	var shadow: ColorRect = ColorRect.new()
	shadow.name = "Shadow"
	shadow.position = -size / 2.0 + Vector2(8, 10)
	shadow.size = size
	shadow.color = Color(0, 0, 0, 0.18)
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	area.add_child(shadow)
	
	var body: ColorRect = ColorRect.new()
	body.name = "Body"
	body.position = -size / 2.0
	body.size = size
	body.color = color
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	area.add_child(body)
	
	var border: ColorRect = ColorRect.new()
	border.name = "Border"
	border.position = -size / 2.0
	border.size = Vector2(size.x, 6)
	border.color = Color(1, 1, 1, 0.18)
	border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	area.add_child(border)
	
	if id == "house" or id == "shop" or id == "storage" or id == "big_house":
		var roof: ColorRect = ColorRect.new()
		roof.name = "Roof"
		roof.position = Vector2(-size.x / 2.0 - 14, -size.y / 2.0 - 34)
		roof.size = Vector2(size.x + 28, 42)
		
		if id == "house":
			roof.color = Color("#A85A4D")
		elif id == "big_house":
			roof.color = Color("#8F4A42")	
		elif id == "shop":
			roof.color = Color("#CC7C46")
		else:
			roof.color = Color("#6E4A38")
		
		roof.mouse_filter = Control.MOUSE_FILTER_IGNORE
		area.add_child(roof)
		
		var door: ColorRect = ColorRect.new()
		door.name = "Door"
		door.size = Vector2(34, 52)
		door.position = Vector2(-17, size.y / 2.0 - 52)
		door.color = Color("#6A4231")
		door.mouse_filter = Control.MOUSE_FILTER_IGNORE
		area.add_child(door)
		
		var window_left: ColorRect = ColorRect.new()
		window_left.name = "WindowLeft"
		window_left.size = Vector2(28, 28)
		window_left.position = Vector2(-size.x / 2.0 + 20, -10)
		window_left.color = Color("#D8F1FF")
		window_left.mouse_filter = Control.MOUSE_FILTER_IGNORE
		area.add_child(window_left)
		
		var window_right: ColorRect = ColorRect.new()
		window_right.name = "WindowRight"
		window_right.size = Vector2(28, 28)
		window_right.position = Vector2(size.x / 2.0 - 48, -10)
		window_right.color = Color("#D8F1FF")
		window_right.mouse_filter = Control.MOUSE_FILTER_IGNORE
		area.add_child(window_right)
		
		var sign_bg: Panel = Panel.new()
		sign_bg.name = "SignBG"
		sign_bg.position = Vector2(-64, -size.y / 2.0 - 70)
		sign_bg.size = Vector2(128, 30)
		sign_bg.add_theme_stylebox_override("panel", make_panel_style(Color(0.18, 0.14, 0.10, 0.95), Color(0.92, 0.87, 0.70), 2, 8))
		area.add_child(sign_bg)
		
		var sign_text: Label = Label.new()
		sign_text.name = "SignText"
		sign_text.position = Vector2.ZERO
		sign_text.size = Vector2(128, 30)
		
		if id == "house":
			sign_text.text = "小屋 / House"
		elif id == "big_house":
			sign_text.text = "大房子 / Big House"
		elif id == "shop":
			sign_text.text = "商店 / Shop"
		else:
			sign_text.text = "仓库 / Storage"
		
		sign_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		sign_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		style_label(sign_text, 14, true, Color.WHITE, Color(0.08, 0.05, 0.02, 0.95))
		sign_bg.add_child(sign_text)
	
	elif id == "well":
		var ring: ColorRect = ColorRect.new()
		ring.name = "Ring"
		ring.position = Vector2(-34, -34)
		ring.size = Vector2(68, 68)
		ring.color = Color("#8B9EB3")
		ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
		area.add_child(ring)
		
		var water_rect: ColorRect = ColorRect.new()
		water_rect.name = "WaterRect"
		water_rect.position = Vector2(-24, -18)
		water_rect.size = Vector2(48, 28)
		water_rect.color = Color("#7BD1F1")
		water_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		area.add_child(water_rect)
		
		var post_left: ColorRect = ColorRect.new()
		post_left.position = Vector2(-26, -54)
		post_left.size = Vector2(8, 22)
		post_left.color = Color("#6E4A38")
		post_left.mouse_filter = Control.MOUSE_FILTER_IGNORE
		area.add_child(post_left)
		
		var post_right: ColorRect = ColorRect.new()
		post_right.position = Vector2(18, -54)
		post_right.size = Vector2(8, 22)
		post_right.color = Color("#6E4A38")
		post_right.mouse_filter = Control.MOUSE_FILTER_IGNORE
		area.add_child(post_right)
		
		var beam: ColorRect = ColorRect.new()
		beam.position = Vector2(-26, -58)
		beam.size = Vector2(52, 6)
		beam.color = Color("#6E4A38")
		beam.mouse_filter = Control.MOUSE_FILTER_IGNORE
		area.add_child(beam)
		
		var well_label: Label = Label.new()
		well_label.position = Vector2(-64, 42)
		well_label.size = Vector2(128, 26)
		well_label.text = "水井 / Well"
		well_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		well_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		style_label(well_label, 15, true, Color.WHITE, Color(0.1, 0.05, 0.02, 0.95))
		area.add_child(well_label)
	
	return area


# ============================================================
# BIG HOUSE V2 — COZY EXTERIOR
# ============================================================

func add_cozy_panel(
	parent: Node,
	node_name: String,
	pos: Vector2,
	size: Vector2,
	fill_color: Color,
	border_color: Color,
	border_width: int = 2,
	radius: int = 6,
	z: int = 0
) -> Panel:
	var panel: Panel = Panel.new()
	panel.name = node_name
	panel.position = pos
	panel.size = size
	panel.z_index = z
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override(
		"panel",
		make_panel_style(fill_color, border_color, border_width, radius)
	)
	parent.add_child(panel)
	return panel


func add_optional_texture(
	parent: Node,
	node_name: String,
	texture: Texture2D,
	pos: Vector2,
	size: Vector2,
	z: int = 0
) -> TextureRect:
	var tr: TextureRect = TextureRect.new()
	tr.name = node_name
	tr.position = pos
	tr.size = size
	tr.z_index = z
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tr.stretch_mode = TextureRect.STRETCH_SCALE
	tr.texture = texture
	parent.add_child(tr)
	return tr

func registry_texture(texture_name: String) -> Texture2D:
	if asset_registry == null:
		return null
	
	var value: Variant = asset_registry.get(texture_name)
	
	if value is Texture2D:
		return value as Texture2D
	
	return null


func make_atlas_texture(texture: Texture2D, region: Rect2) -> AtlasTexture:
	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = region
	return atlas


func add_region_texture(
	parent: Node,
	node_name: String,
	texture: Texture2D,
	region: Rect2,
	pos: Vector2,
	size: Vector2,
	z: int = 0,
	modulate_color: Color = Color.WHITE
) -> TextureRect:
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
	
	parent.add_child(tr)
	return tr


func add_repeated_region_grid(
	parent: Node,
	node_name: String,
	texture: Texture2D,
	region: Rect2,
	start_pos: Vector2,
	cols: int,
	rows: int,
	tile_size: Vector2,
	z: int,
	modulate_color: Color = Color.WHITE
) -> void:
	if texture == null:
		return
	
	for row in range(rows):
		for col in range(cols):
			add_region_texture(
				parent,
				"%s_%d_%d" % [node_name, row, col],
				texture,
				region,
				start_pos + Vector2(float(col) * tile_size.x, float(row) * tile_size.y),
				tile_size,
				z,
				modulate_color
			)


func add_tiny_pixel_flower(parent: Node, pos: Vector2, color: Color, z: int = 20) -> void:
	var stem: ColorRect = ColorRect.new()
	stem.position = pos + Vector2(3, 5)
	stem.size = Vector2(2, 7)
	stem.color = Color("#4F8F46")
	stem.z_index = z
	stem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(stem)
	
	var petal: ColorRect = ColorRect.new()
	petal.position = pos
	petal.size = Vector2(8, 8)
	petal.color = color
	petal.z_index = z + 1
	petal.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(petal)


func add_tiny_bush(parent: Node, pos: Vector2, size: Vector2, z: int = 12) -> void:
	add_cozy_panel(
		parent,
		"Bush",
		pos,
		size,
		Color("#62A85A"),
		Color("#427A3C"),
		2,
		10,
		z
	)
	
	add_cozy_panel(
		parent,
		"BushHighlight",
		pos + Vector2(6, 4),
		Vector2(size.x * 0.45, size.y * 0.35),
		Color(0.75, 1.0, 0.65, 0.22),
		Color(1, 1, 1, 0.0),
		0,
		8,
		z + 1
	)


func add_fence_piece(parent: Node, pos: Vector2, z: int = 8) -> void:
	var post_left: ColorRect = ColorRect.new()
	post_left.position = pos
	post_left.size = Vector2(5, 24)
	post_left.color = Color("#8E6141")
	post_left.z_index = z
	post_left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(post_left)
	
	var post_right: ColorRect = ColorRect.new()
	post_right.position = pos + Vector2(28, 0)
	post_right.size = Vector2(5, 24)
	post_right.color = Color("#8E6141")
	post_right.z_index = z
	post_right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(post_right)
	
	var rail_top: ColorRect = ColorRect.new()
	rail_top.position = pos + Vector2(0, 7)
	rail_top.size = Vector2(34, 5)
	rail_top.color = Color("#A8784F")
	rail_top.z_index = z + 1
	rail_top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(rail_top)
	
	var rail_bottom: ColorRect = ColorRect.new()
	rail_bottom.position = pos + Vector2(0, 16)
	rail_bottom.size = Vector2(34, 5)
	rail_bottom.color = Color("#A8784F")
	rail_bottom.z_index = z + 1
	rail_bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(rail_bottom)

func add_big_house_blocker(parent: Node, visual_rect: Rect2, visual_origin_offset: Vector2, node_name: String) -> StaticBody2D:
	var body: StaticBody2D = StaticBody2D.new()
	body.name = node_name
	body.position = visual_rect.position + visual_rect.size / 2.0 - visual_origin_offset
	
	var shape_node: CollisionShape2D = CollisionShape2D.new()
	var rect_shape: RectangleShape2D = RectangleShape2D.new()
	rect_shape.size = visual_rect.size
	shape_node.shape = rect_shape
	body.add_child(shape_node)
	
	parent.add_child(body)
	return body

func create_big_house_v2(pos: Vector2) -> Area2D:
	# pos = top-left of the big house visual.
	var visual_size: Vector2 = Vector2(390, 325)
	var root_offset: Vector2 = Vector2(195, 250)

	var root: Area2D = Area2D.new()
	root.name = "big_house"
	root.position = pos + root_offset
	root.z_as_relative = false
	root.z_index = int(root.position.y) - 110
	building_layer.add_child(root)

	# Area used for interaction detection.
	var shape_node: CollisionShape2D = CollisionShape2D.new()
	shape_node.name = "InteractionArea"
	var rect_shape: RectangleShape2D = RectangleShape2D.new()
	rect_shape.size = Vector2(300, 210)
	shape_node.shape = rect_shape
	shape_node.position = Vector2(0, -72)
	root.add_child(shape_node)

	# Real physics blockers. These stop the player.
	add_big_house_blocker(
		root,
		Rect2(Vector2(50, 95), Vector2(290, 158)),
		root_offset,
		"HouseBodyBlocker"
	)

	add_big_house_blocker(
		root,
		Rect2(Vector2(20, 58), Vector2(350, 54)),
		root_offset,
		"HouseRoofBlocker"
	)

	var visual_root: Control = Control.new()
	visual_root.name = "BigHouseV2Visual"
	visual_root.position = -root_offset
	visual_root.size = visual_size
	visual_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(visual_root)

	var wall_texture: Texture2D = registry_texture("smallburg_house_walls_pink")
	var roof_texture: Texture2D = registry_texture("smallburg_house_roofs")
	var door_texture: Texture2D = registry_texture("smallburg_house_doors")
	var tiny_objects_texture: Texture2D = registry_texture("tiny_farm_objects")

	# --------------------------------------------------------
	# Soft shadow under house
	# --------------------------------------------------------
	var shadow: ColorRect = ColorRect.new()
	shadow.name = "HouseShadow"
	shadow.position = Vector2(42, 86)
	shadow.size = Vector2(310, 186)
	shadow.color = Color(0, 0, 0, 0.13)
	shadow.z_index = 1
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visual_root.add_child(shadow)

	# --------------------------------------------------------
	# Main path extension into the porch
	# --------------------------------------------------------
	add_cozy_panel(
		visual_root,
		"FrontPathLocal",
		Vector2(164, 246),
		Vector2(62, 79),
		Color("#D4B07A"),
		Color("#B98E5D"),
		1,
		5,
		2
	)

	for i in range(4):
		add_cozy_panel(
			visual_root,
			"StepStone%d" % i,
			Vector2(174, 259 + i * 16),
			Vector2(42, 9),
			Color("#C7A878"),
			Color("#9E7F55"),
			1,
			4,
			3
		)

	# --------------------------------------------------------
	# Fence pieces, now low z so player can appear above them
	# --------------------------------------------------------
	add_fence_piece(visual_root, Vector2(16, 236), 5)
	add_fence_piece(visual_root, Vector2(52, 236), 5)
	add_fence_piece(visual_root, Vector2(292, 236), 5)
	add_fence_piece(visual_root, Vector2(328, 236), 5)

	# --------------------------------------------------------
	# House body
	# --------------------------------------------------------
	add_cozy_panel(
		visual_root,
		"HouseBodyBase",
		Vector2(50, 100),
		Vector2(290, 150),
		Color("#BC7658"),
		Color("#8A553F"),
		2,
		2,
		12
	)

	if wall_texture != null:
		add_repeated_region_grid(
			visual_root,
			"WallTextureGrid",
			wall_texture,
			Rect2(0, 0, 16, 16),
			Vector2(54, 104),
			9,
			5,
			Vector2(31, 28),
			13,
			Color(1, 1, 1, 0.45)
		)

	var side_shadow: ColorRect = ColorRect.new()
	side_shadow.name = "HouseSideShadow"
	side_shadow.position = Vector2(314, 104)
	side_shadow.size = Vector2(22, 142)
	side_shadow.color = Color(0, 0, 0, 0.08)
	side_shadow.z_index = 14
	side_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visual_root.add_child(side_shadow)

	# --------------------------------------------------------
	# Bigger roof
	# --------------------------------------------------------
	add_cozy_panel(
		visual_root,
		"RoofMain",
		Vector2(18, 56),
		Vector2(354, 50),
		Color("#934F46"),
		Color("#62322E"),
		2,
		0,
		28
	)

	add_cozy_panel(
		visual_root,
		"RoofLip",
		Vector2(32, 98),
		Vector2(326, 14),
		Color("#A85D53"),
		Color("#7A433D"),
		1,
		0,
		30
	)

	if roof_texture != null:
		add_repeated_region_grid(
			visual_root,
			"RoofTextureGrid",
			roof_texture,
			Rect2(0, 0, 16, 16),
			Vector2(26, 61),
			10,
			2,
			Vector2(34, 19),
			29,
			Color(1, 1, 1, 0.38)
		)

	add_cozy_panel(
		visual_root,
		"RoofHighlight",
		Vector2(34, 63),
		Vector2(304, 5),
		Color(1.0, 0.76, 0.68, 0.16),
		Color(1, 1, 1, 0.0),
		0,
		0,
		31
	)

	# --------------------------------------------------------
	# Chimney
	# --------------------------------------------------------
	add_cozy_panel(
		visual_root,
		"Chimney",
		Vector2(290, 28),
		Vector2(28, 42),
		Color("#8C5E4A"),
		Color("#5F3C30"),
		2,
		2,
		34
	)

	add_cozy_panel(
		visual_root,
		"ChimneyTop",
		Vector2(285, 24),
		Vector2(38, 9),
		Color("#6D493A"),
		Color("#4B3026"),
		1,
		2,
		35
	)

	# --------------------------------------------------------
	# Porch
	# --------------------------------------------------------
	add_cozy_panel(
		visual_root,
		"Porch",
		Vector2(112, 224),
		Vector2(166, 28),
		Color("#D9C4A4"),
		Color("#A98A61"),
		1,
		3,
		36
	)

	add_cozy_panel(
		visual_root,
		"PorchShadow",
		Vector2(114, 248),
		Vector2(162, 6),
		Color(0, 0, 0, 0.13),
		Color(1, 1, 1, 0.0),
		0,
		0,
		37
	)

	# --------------------------------------------------------
	# Door
	# --------------------------------------------------------
	if door_texture != null:
		add_region_texture(
			visual_root,
			"DoorTexture",
			door_texture,
			Rect2(0, 0, 16, 32),
			Vector2(171, 184),
			Vector2(48, 70),
			42,
			Color(1, 1, 1, 0.92)
		)

	add_cozy_panel(
		visual_root,
		"DoorOverlay",
		Vector2(174, 188),
		Vector2(42, 64),
		Color(0.23, 0.12, 0.07, 0.52),
		Color("#4D2E22"),
		2,
		2,
		43
	)

	var door_knob: ColorRect = ColorRect.new()
	door_knob.name = "DoorKnob"
	door_knob.position = Vector2(207, 216)
	door_knob.size = Vector2(6, 6)
	door_knob.color = Color("#F4D17E")
	door_knob.z_index = 44
	door_knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visual_root.add_child(door_knob)

	# --------------------------------------------------------
	# Windows
	# --------------------------------------------------------
	add_cozy_panel(
		visual_root,
		"WindowLeft",
		Vector2(82, 164),
		Vector2(42, 42),
		Color("#D7EDF8"),
		Color("#7AA9C0"),
		2,
		2,
		38
	)

	add_cozy_panel(
		visual_root,
		"WindowRight",
		Vector2(266, 164),
		Vector2(42, 42),
		Color("#D7EDF8"),
		Color("#7AA9C0"),
		2,
		2,
		38
	)

	var window_bars: Array[Dictionary] = [
		{"pos": Vector2(102, 164), "size": Vector2(2, 42)},
		{"pos": Vector2(82, 184), "size": Vector2(42, 2)},
		{"pos": Vector2(286, 164), "size": Vector2(2, 42)},
		{"pos": Vector2(266, 184), "size": Vector2(42, 2)}
	]

	for info in window_bars:
		var bar: ColorRect = ColorRect.new()
		bar.position = info["pos"]
		bar.size = info["size"]
		bar.color = Color("#BFD3DE")
		bar.z_index = 39
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		visual_root.add_child(bar)

	add_cozy_panel(
		visual_root,
		"WindowLeftShine",
		Vector2(90, 170),
		Vector2(9, 22),
		Color(1, 1, 1, 0.42),
		Color(1, 1, 1, 0.0),
		0,
		2,
		40
	)

	add_cozy_panel(
		visual_root,
		"WindowRightShine",
		Vector2(274, 170),
		Vector2(9, 22),
		Color(1, 1, 1, 0.42),
		Color(1, 1, 1, 0.0),
		0,
		2,
		40
	)

	# Flower boxes
	add_cozy_panel(
		visual_root,
		"FlowerBoxLeft",
		Vector2(76, 206),
		Vector2(54, 13),
		Color("#8D5A40"),
		Color("#5E3A28"),
		1,
		2,
		45
	)

	add_cozy_panel(
		visual_root,
		"FlowerBoxRight",
		Vector2(260, 206),
		Vector2(54, 13),
		Color("#8D5A40"),
		Color("#5E3A28"),
		1,
		2,
		45
	)

	for i in range(5):
		add_tiny_pixel_flower(visual_root, Vector2(82 + i * 9, 199), Color("#F3A6C8"), 46)
		add_tiny_pixel_flower(visual_root, Vector2(266 + i * 9, 199), Color("#FFD17C"), 46)

	# --------------------------------------------------------
	# Bushes / garden details
	# --------------------------------------------------------
	add_tiny_bush(visual_root, Vector2(18, 214), Vector2(54, 38), 18)
	add_tiny_bush(visual_root, Vector2(318, 214), Vector2(54, 38), 18)

	add_tiny_pixel_flower(visual_root, Vector2(44, 268), Color("#F6A5C8"), 22)
	add_tiny_pixel_flower(visual_root, Vector2(68, 280), Color("#FFF1A8"), 22)
	add_tiny_pixel_flower(visual_root, Vector2(304, 278), Color("#D8B6FF"), 22)
	add_tiny_pixel_flower(visual_root, Vector2(330, 268), Color("#F6A5C8"), 22)

	if tiny_objects_texture != null:
		add_region_texture(
			visual_root,
			"TinyWonderDecorLeft",
			tiny_objects_texture,
			Rect2(0, 0, 16, 16),
			Vector2(36, 260),
			Vector2(30, 30),
			21,
			Color(1, 1, 1, 0.85)
		)
		
		add_region_texture(
			visual_root,
			"TinyWonderDecorRight",
			tiny_objects_texture,
			Rect2(16, 0, 16, 16),
			Vector2(320, 260),
			Vector2(30, 30),
			21,
			Color(1, 1, 1, 0.85)
		)

	# --------------------------------------------------------
	# Sign
	# --------------------------------------------------------
	var label_bg: Panel = Panel.new()
	label_bg.name = "BigHouseLabelBG"
	label_bg.position = Vector2(118, 36)
	label_bg.size = Vector2(154, 30)
	label_bg.z_index = 55
	label_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label_bg.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.18, 0.13, 0.11, 0.92), Color("#F0DEC2"), 1, 8)
	)
	visual_root.add_child(label_bg)

	var label: Label = Label.new()
	label.name = "BigHouseLabel"
	label.position = Vector2.ZERO
	label.size = Vector2(154, 30)
	label.text = "大房子 / Big House"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	style_label(label, 15, true, Color.WHITE, Color(0.05, 0.05, 0.05, 0.9))
	label_bg.add_child(label)

	return root
# ============================================================
# ANIMALS
# ============================================================

func create_animals():
	clear_children(animal_layer)
	animal_nodes.clear()
	animals.clear()
	
	add_animal("chicken", "小啾", Vector2(925, 670))
	add_animal("chicken", "小米", Vector2(1010, 675))
	add_animal("chicken", "软软", Vector2(1095, 670))
	add_animal("cow", "奶糖", Vector2(930, 770))
	add_animal("cow", "云朵", Vector2(1060, 770))


func new_animal_state(type_id: String, pet_name: String) -> Dictionary:
	return {
		"type": type_id,
		"name": pet_name,
		"fed": false,
		"petted": false,
		"product_ready": false,
		"hearts": 0
	}


func add_animal(type_id: String, pet_name: String, pos: Vector2):
	var area: Area2D = Area2D.new()
	area.name = pet_name
	area.position = pos
	animal_layer.add_child(area)
	
	var shape: CollisionShape2D = CollisionShape2D.new()
	var rect_shape: RectangleShape2D = RectangleShape2D.new()
	
	if type_id == "cow":
		rect_shape.size = Vector2(76, 58)
	else:
		rect_shape.size = Vector2(52, 42)
	
	shape.shape = rect_shape
	area.add_child(shape)
	
	var sprite: Sprite2D = Sprite2D.new()
	sprite.name = "AnimalSprite"
	sprite.centered = true
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	area.add_child(sprite)
	
	if type_id == "chicken" and chicken_texture != null:
		sprite.texture = chicken_texture
		sprite.region_enabled = true
		sprite.region_rect = Rect2(0, 0, 16, 16)
		sprite.scale = Vector2(3.0, 3.0)
	elif type_id == "cow" and cow_texture != null:
		sprite.texture = cow_texture
		sprite.region_enabled = true
		sprite.region_rect = Rect2(0, 0, 32, 32)
		sprite.scale = Vector2(2.6, 2.6)
	else:
		var fallback: ColorRect = ColorRect.new()
		fallback.name = "FallbackAnimal"
		fallback.position = Vector2(-28, -22)
		fallback.size = Vector2(56, 44)
		
		if type_id == "cow":
			fallback.color = Color("#F7F2E8")
		else:
			fallback.color = Color("#FFE6A0")
		
		fallback.mouse_filter = Control.MOUSE_FILTER_IGNORE
		area.add_child(fallback)
	
	var label: Label = Label.new()
	label.name = "Label"
	label.position = Vector2(-60, -54)
	label.size = Vector2(120, 30)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	style_label(label, 14, true, Color.WHITE, Color(0.1, 0.05, 0.02, 0.95))
	area.add_child(label)
	
	animal_nodes.append(area)
	animals.append(new_animal_state(type_id, pet_name))


func update_animal_animation(delta: float):
	animal_anim_timer += delta
	
	if animal_anim_timer < 0.35:
		return
	
	animal_anim_timer = 0.0
	animal_anim_frame = (animal_anim_frame + 1) % 4
	
	for i in range(animal_nodes.size()):
		var node: Area2D = animal_nodes[i]
		var animal: Dictionary = animals[i]
		var type_id: String = str(animal["type"])
		var sprite: Sprite2D = node.get_node_or_null("AnimalSprite") as Sprite2D
		
		if sprite == null:
			continue
		
		if type_id == "chicken" and chicken_texture != null:
			var frame_x: int = animal_anim_frame % 4
			sprite.region_rect = Rect2(frame_x * 16, 0, 16, 16)
		elif type_id == "cow" and cow_texture != null:
			var frame_x_cow: int = animal_anim_frame % 3
			sprite.region_rect = Rect2(frame_x_cow * 32, 0, 32, 32)


# ============================================================
# PROCESS / INPUT
# ============================================================

func _process(delta: float):
	update_toast(delta)
	update_world_map_player_marker()
	
	if message_panel != null and message_panel.visible:
		player_moving = false
		room_player_moving = false
		update_action_animation(delta)
		
		if house_panel != null and house_panel.visible:
			update_room_player_animation(delta)
		
		return
	
	update_player_animation(delta)
	update_animal_animation(delta)
	update_action_animation(delta)
	update_house_room(delta)

func _physics_process(delta: float):
	if house_v2 != null and house_v2.has_method("is_house_open") and bool(house_v2.call("is_house_open")):
		player.velocity = Vector2.ZERO
		player_moving = false
		player.move_and_slide()
		return
	if message_panel != null and message_panel.visible:
		player.velocity = Vector2.ZERO
		player_moving = false
		player.move_and_slide()
		return
	
	if house_panel != null and house_panel.visible:
		player.velocity = Vector2.ZERO
		player_moving = false
		player.move_and_slide()
		return
	
	handle_player_movement()
	update_camera()
	detect_current_target()
	update_interact_hint()
	
	
func handle_player_movement():
	var input_vector: Vector2 = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	player_moving = input_vector.length() > 0.01
	
	if player_moving:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				facing = "right"
			else:
				facing = "left"
		else:
			if input_vector.y > 0:
				facing = "down"
			else:
				facing = "up"
		
		input_vector = input_vector.normalized()
	
	player.velocity = input_vector * PLAYER_SPEED
	player.move_and_slide()
	
	player.global_position.x = clampf(player.global_position.x, 20.0, WORLD_SIZE.x - 20.0)
	player.global_position.y = clampf(player.global_position.y, 20.0, WORLD_SIZE.y - 20.0)
	player.z_index = int(player.global_position.y)
		

func update_camera():
	var half_view: Vector2 = VIEW_SIZE / 2.0
	var target: Vector2 = player.global_position
	
	target.x = clampf(target.x, half_view.x, WORLD_SIZE.x - half_view.x)
	target.y = clampf(target.y, half_view.y, WORLD_SIZE.y - half_view.y)
	
	camera.global_position = target


func _unhandled_input(event):
	if house_v2 != null and house_v2.has_method("is_house_open") and bool(house_v2.call("is_house_open")):
		return
		
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_M:
				toggle_world_map()
				return
				
	if message_panel.visible:
		if event.is_action_pressed("interact"):
			close_message()
		return
	
	if house_panel != null and house_panel.visible:
		if event is InputEventKey:
			if event.pressed and not event.echo:
				if event.keycode == KEY_ESCAPE:
					close_house_interior()
					return
				
				if event.is_action_pressed("interact"):
					interact_room_target()
					return
		return
	
	if event.is_action_pressed("interact"):
		interact_with_target()
		return
	
	if event is InputEventKey:
		if event.pressed and not event.echo:
			match event.keycode:
				KEY_1:
					select_crop("missing")
				KEY_2:
					select_crop("hug")
				KEY_3:
					select_crop("courage")
				KEY_4:
					select_crop("kiss")
				KEY_5:
					select_crop("moon")
				KEY_6:
					select_crop("star")
				KEY_B:
					buy_selected_seed()
				KEY_F:
					buy_animal_feed()
				KEY_V:
					sell_all_storage()
				KEY_ESCAPE:
					go_back()

func _input(event):
	if message_panel != null and message_panel.visible:
		var bar: VScrollBar = message_text.get_v_scroll_bar()
		
		if event is InputEventMouseButton:
			if event.pressed:
				if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					if bar != null:
						bar.value = clampf(float(bar.value) + 32.0, float(bar.min_value), float(bar.max_value))
					get_viewport().set_input_as_handled()
				
				elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
					if bar != null:
						bar.value = clampf(float(bar.value) - 32.0, float(bar.min_value), float(bar.max_value))
					get_viewport().set_input_as_handled()
		
		if event is InputEventKey:
			if event.pressed and not event.echo:
				if event.keycode == KEY_PAGEDOWN:
					if bar != null:
						bar.value = clampf(float(bar.value) + 90.0, float(bar.min_value), float(bar.max_value))
					get_viewport().set_input_as_handled()
				
				elif event.keycode == KEY_PAGEUP:
					if bar != null:
						bar.value = clampf(float(bar.value) - 90.0, float(bar.min_value), float(bar.max_value))
					get_viewport().set_input_as_handled()
		
		return
	
	if house_panel != null and house_panel.visible:
		if event is InputEventMouseMotion:
			update_room_target()
		
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				update_room_target()
				if room_target_id != "":
					interact_room_target()
					get_viewport().set_input_as_handled()
					
# ============================================================
# TARGETING
# ============================================================

func detect_current_target():
	target_type = ""
	target_index = -1
	target_decor_id = ""
	
	var best_distance: float = 999999.0
	
	for i in range(plot_nodes.size()):
		var dist: float = player.global_position.distance_to(plot_nodes[i].global_position)
		
		if dist < INTERACT_DISTANCE and dist < best_distance:
			best_distance = dist
			target_type = "plot"
			target_index = i
	
	for key in building_nodes.keys():
		var node: Area2D = building_nodes[key]
		var dist_b: float = player.global_position.distance_to(node.global_position)
		
		if dist_b < INTERACT_DISTANCE and dist_b < best_distance:
			best_distance = dist_b
			target_type = str(key)
			target_index = -1
	
	for id in decor_interactions.keys():
		var decor_data: Dictionary = decor_interactions[id]
		var decor_rect: Rect2 = decor_data["rect"]
		var decor_center: Vector2 = decor_rect.position + decor_rect.size / 2.0
		var decor_dist: float = player.global_position.distance_to(decor_center)
		if decor_rect.grow(40.0).has_point(player.global_position) and decor_dist < best_distance:
			best_distance = decor_dist
			target_type = "decor"
			target_index = -1
			target_decor_id = str(id)

	for i in range(animal_nodes.size()):
		var dist_a: float = player.global_position.distance_to(animal_nodes[i].global_position)
		
		if dist_a < INTERACT_DISTANCE and dist_a < best_distance:
			best_distance = dist_a
			target_type = "animal"
			target_index = i
			
	for i in range(outside_points.size()):
		var point: Dictionary = outside_points[i]
		var dist_o: float = player.global_position.distance_to(point["pos"])
		var radius: float = float(point["radius"])
		
		if dist_o < radius and dist_o < best_distance:
			best_distance = dist_o
			target_type = "outside_point"
			target_index = i


func update_interact_hint():
	if target_type == "":
		interact_hint.visible = false
		return
	
	interact_hint.visible = true
	interact_hint.position = world_to_screen(player.global_position + Vector2(-110, -72))
	
	match target_type:
		"plot":
			interact_hint.text = "按 E 照顾植物 / Press E"
		"house":
			interact_hint.text = "按 E 进入小屋 / Enter house"
		"shop":
			interact_hint.text = "按 E 买种子 / Buy seed"
		"storage":
			interact_hint.text = "按 E 卖收获 / Sell"
		"well":
			interact_hint.text = "按 E 装满水壶 / Refill"
		"big_house":
			interact_hint.text = "按 E 进入大房子 / Enter big house"
		"animal":
			interact_hint.text = "按 E 照顾小动物 / Care"
		"outside_point":
			if target_index >= 0 and target_index < outside_points.size():
				interact_hint.text = str(outside_points[target_index]["hint"])
			else:
				interact_hint.text = "按 E 查看 / Look"
		"decor":
			if decor_interactions.has(target_decor_id):
				var data: Dictionary = decor_interactions[target_decor_id]
				interact_hint.text = "按 E 查看：%s / %s" % [str(data["zh"]), str(data["en"])]
			else:
				interact_hint.text = "按 E 查看 / Look"
		_:
			interact_hint.text = "按 E 互动 / Interact"


func world_to_screen(world_pos: Vector2) -> Vector2:
	return world_pos - camera.global_position + VIEW_SIZE / 2.0


func interact_with_target():
	match target_type:
		"plot":
			interact_plot(target_index)
		"house":
			open_house_interior()
		"shop":
			buy_selected_seed()
		"storage":
			sell_all_storage()
		"well":
			refill_water()
		"big_house":
			open_house_v2()
		"animal":
			interact_animal(target_index)
		"outside_point":
			if target_index >= 0 and target_index < outside_points.size():
				interact_hint.text = str(outside_points[target_index]["hint"])
			else:
				interact_hint.text = "按 E 查看 / Look"
		"decor":
			interact_decor(target_decor_id)
		_:
			show_toast("靠近可互动的东西再按 E / Move closer and press E")

func open_house_v2():
	if house_v2 != null and house_v2.has_method("open_house"):
		house_v2.call("open_house")


func _on_house_v2_sleep_requested():
	sleep_next_day()

func interact_outside_point(index: int):
	if index < 0 or index >= outside_points.size():
		return
	
	var point: Dictionary = outside_points[index]
	
	show_message(
		str(point["title_zh"]),
		str(point["title_en"]),
		str(point["body_zh"]),
		str(point["body_en"])
	)

# ============================================================
# FARMING LOGIC
# ============================================================

func interact_plot(index: int):
	if index < 0 or index >= plots.size():
		return
	
	var plot: Dictionary = plots[index]
	var crop_id: String = str(plot["crop"])
	
	if crop_id == "":
		plant_selected_seed(index)
		return
	
	if bool(plot["ready"]):
		harvest_plot(index)
		return
	
	water_plot(index)


func plant_selected_seed(index: int):
	if energy <= 0:
		show_tired_message()
		return
	
	if not is_crop_unlocked(selected_crop):
		var data: Dictionary = crop_data[selected_crop]
		show_message(
			"还没有解锁",
			"Not unlocked yet",
			"%s 需要总收获达到 %d 次后解锁。" % [str(data["seed_zh"]), int(data["unlock_at"])],
			"%s unlocks after %d total harvests." % [str(data["seed_en"]), int(data["unlock_at"])]
		)
		return
	
	if int(seeds[selected_crop]) <= 0:
		var data2: Dictionary = crop_data[selected_crop]
		show_message(
			"没有这种种子啦",
			"No seeds left",
			"你现在没有 %s。可以去商店买一点，或者按 B 快速购买。" % str(data2["seed_zh"]),
			"You do not have any %s. You can buy some at the shop, or press B." % str(data2["seed_en"])
		)
		return
	
	seeds[selected_crop] = int(seeds[selected_crop]) - 1
	energy -= 3
	
	plots[index] = {
		"crop": selected_crop,
		"growth": 0,
		"watered": weather == "rainy",
		"ready": false
	}
	
	var data3: Dictionary = crop_data[selected_crop]
	start_action("plant")
	show_toast("种下 %s / Planted %s" % [str(data3["zh"]), str(data3["en"])])
	refresh_all()
	save_game()


func water_plot(index: int):
	if energy <= 0:
		show_tired_message()
		return
	
	if water <= 0:
		show_message(
			"水壶空啦",
			"Watering can is empty",
			"去水井旁边按 E，把水壶装满再回来吧。",
			"Go to the well and press E to refill your watering can."
		)
		return
	
	var plot: Dictionary = plots[index]
	
	if bool(plot["watered"]):
		show_toast("今天已经浇过啦 / Already watered today")
		return
	
	plot["watered"] = true
	water -= 1
	energy -= 2
	plots[index] = plot
	
	start_action("water")
	show_toast("浇水啦 / Watered")
	refresh_all()
	save_game()


func harvest_plot(index: int):
	if energy <= 0:
		show_tired_message()
		return
	
	var plot: Dictionary = plots[index]
	var crop_id: String = str(plot["crop"])
	
	if crop_id == "":
		return
	
	var data: Dictionary = crop_data[crop_id]
	
	storage[crop_id] = int(storage[crop_id]) + 1
	total_harvested += 1
	energy -= 1
	
	plots[index] = new_plot_state()
	
	start_action("harvest")
	show_toast("收获 %s / Harvested %s" % [str(data["zh"]), str(data["en"])])
	
	var unlock_zh: String = get_unlock_message_zh()
	var unlock_en: String = get_unlock_message_en()
	
	if unlock_zh != "":
		show_message(
			"新的种子解锁啦",
			"New seed unlocked",
			unlock_zh,
			unlock_en
		)
	
	refresh_all()
	save_game()


func get_unlock_message_zh() -> String:
	var lines: Array = []
	
	for id in crop_order:
		if int(crop_data[id]["unlock_at"]) == total_harvested:
			lines.append("新的种子解锁啦：%s。" % str(crop_data[id]["seed_zh"]))
	
	return "\n".join(lines)


func get_unlock_message_en() -> String:
	var lines: Array = []
	
	for id in crop_order:
		if int(crop_data[id]["unlock_at"]) == total_harvested:
			lines.append("New seed unlocked: %s." % str(crop_data[id]["seed_en"]))
	
	return "\n".join(lines)


# ============================================================
# DAY / SEASON / WEATHER
# ============================================================

func sleep_next_day():
	day += 1
	
	if day > 1 and (day - 1) % 10 == 0:
		season_index = (season_index + 1) % seasons.size()
	
	energy = MAX_ENERGY
	water = MAX_WATER
	weather = roll_weather()
	
	var grown_count: int = 0
	var ready_count: int = 0
	var animal_products: int = 0
	
	for i in range(plots.size()):
		var plot: Dictionary = plots[i]
		var crop_id: String = str(plot["crop"])
		
		if crop_id == "":
			continue
		
		if bool(plot["ready"]):
			plot["watered"] = weather == "rainy"
			plots[i] = plot
			continue
		
		if bool(plot["watered"]):
			plot["growth"] = int(plot["growth"]) + 1
			grown_count += 1
		
		var days_needed: int = int(crop_data[crop_id]["days_to_grow"])
		
		if int(plot["growth"]) >= days_needed:
			plot["ready"] = true
			ready_count += 1
		
		plot["watered"] = weather == "rainy"
		plots[i] = plot
	
	for i in range(animals.size()):
		var animal: Dictionary = animals[i]
		
		if bool(animal["fed"]):
			animal["product_ready"] = true
			animal["hearts"] = int(animal["hearts"]) + 1
			animal_products += 1
		
		animal["fed"] = false
		animal["petted"] = false
		animals[i] = animal
	
	build_world()
	start_action("sleep")
	
	var season: Dictionary = seasons[season_index]
	
	show_message(
		"新的一天",
		"A new day",
		"第 %d 天开始啦。\n季节：%s。天气：%s。\n有 %d 株植物长大了一点，其中 %d 株已经可以收获。\n有 %d 只小动物准备好了新的产物。" % [
			day,
			str(season["zh"]),
			get_weather_zh(),
			grown_count,
			ready_count,
			animal_products
		],
		"Day %d has started.\nSeason: %s. Weather: %s.\n%d plants grew a little, and %d are ready to harvest.\n%d animals prepared new products." % [
			day,
			str(season["en"]),
			get_weather_en(),
			grown_count,
			ready_count,
			animal_products
		]
	)
	
	refresh_all()
	save_game()


func roll_weather() -> String:
	var r: float = randf()
	
	if season_index == 3:
		if r < 0.25:
			return "snowy"
		return "sunny"
	
	if r < 0.25:
		return "rainy"
	
	return "sunny"


func get_weather_zh() -> String:
	match weather:
		"rainy":
			return "下雨"
		"snowy":
			return "下雪"
		_:
			return "晴天"


func get_weather_en() -> String:
	match weather:
		"rainy":
			return "Rainy"
		"snowy":
			return "Snowy"
		_:
			return "Sunny"


func refill_water():
	water = MAX_WATER
	start_action("water")
	show_toast("水壶装满啦 / Water refilled")
	refresh_all()
	save_game()


func show_tired_message():
	show_message(
		"有点累啦",
		"Too tired",
		"今天的体力不够啦。回小屋睡一觉，明天再继续照顾花园吧。",
		"You do not have enough energy today. Go back to the house and sleep, then continue caring for the garden tomorrow."
	)


# ============================================================
# ANIMAL LOGIC
# ============================================================

func interact_animal(index: int):
	if index < 0 or index >= animals.size():
		return
	
	var animal: Dictionary = animals[index]
	var type_id: String = str(animal["type"])
	var type_data: Dictionary = animal_type_data[type_id]
	var pet_name: String = str(animal["name"])
	
	if bool(animal["product_ready"]):
		var product_id: String = str(type_data["product"])
		storage[product_id] = int(storage[product_id]) + 1
		animal["product_ready"] = false
		animals[index] = animal
		
		start_action("collect")
		show_toast("收到 %s / Collected %s" % [
			str(type_data["product_zh"]),
			str(type_data["product_en"])
		])
		
		refresh_all()
		save_game()
		return
	
	if not bool(animal["fed"]):
		if animal_feed <= 0:
			show_message(
				"没有饲料啦",
				"No animal feed",
				"你现在没有饲料。可以去商店，或者按 F 买一些。",
				"You do not have animal feed right now. Go to the shop or press F to buy some."
			)
			return
		
		animal_feed -= 1
		animal["fed"] = true
		animals[index] = animal
		
		start_action("feed")
		show_toast("喂了 %s / Fed %s" % [pet_name, pet_name])
		refresh_all()
		save_game()
		return
	
	if not bool(animal["petted"]):
		animal["petted"] = true
		animal["hearts"] = int(animal["hearts"]) + 1
		animals[index] = animal
		
		start_action("pet")
		show_toast("摸摸 %s / Petted %s" % [pet_name, pet_name])
		refresh_all()
		save_game()
		return
	
	show_toast("%s 今天已经很开心啦 / Already happy today" % pet_name)


# ============================================================
# SHOP / STORAGE
# ============================================================

func select_crop(crop_id: String):
	if not crop_data.has(crop_id):
		return
	
	selected_crop = crop_id
	var data: Dictionary = crop_data[crop_id]
	
	if is_crop_unlocked(crop_id):
		show_toast("选择 %s / Selected %s" % [
			str(data["seed_zh"]),
			str(data["seed_en"])
		])
	else:
		show_message(
			"还没有解锁",
			"Not unlocked yet",
			"%s 需要总收获达到 %d 次后解锁。" % [
				str(data["seed_zh"]),
				int(data["unlock_at"])
			],
			"%s unlocks after %d total harvests." % [
				str(data["seed_en"]),
				int(data["unlock_at"])
			]
		)
	
	refresh_all()
	save_game()


func buy_selected_seed():
	if not is_crop_unlocked(selected_crop):
		var data: Dictionary = crop_data[selected_crop]
		show_message(
			"还不能购买",
			"Cannot buy yet",
			"%s 需要总收获达到 %d 次后解锁。" % [
				str(data["seed_zh"]),
				int(data["unlock_at"])
			],
			"%s unlocks after %d total harvests." % [
				str(data["seed_en"]),
				int(data["unlock_at"])
			]
		)
		return
	
	var data2: Dictionary = crop_data[selected_crop]
	var cost: int = int(data2["seed_cost"])
	
	if coins < cost:
		show_message(
			"金币不够",
			"Not enough coins",
			"购买 %s 需要 %d 金币。可以先卖掉仓库里的收获。" % [
				str(data2["seed_zh"]),
				cost
			],
			"Buying %s costs %d coins. You can sell harvests from storage first." % [
				str(data2["seed_en"]),
				cost
			]
		)
		return
	
	coins -= cost
	seeds[selected_crop] = int(seeds[selected_crop]) + 1
	
	start_action("buy")
	show_toast("购买 %s / Bought %s" % [
		str(data2["seed_zh"]),
		str(data2["seed_en"])
	])
	
	refresh_all()
	save_game()


func buy_animal_feed():
	var cost: int = 10
	var amount: int = 5
	
	if coins < cost:
		show_message(
			"金币不够",
			"Not enough coins",
			"购买 %d 份饲料需要 %d 金币。" % [amount, cost],
			"Buying %d animal feed costs %d coins." % [amount, cost]
		)
		return
	
	coins -= cost
	animal_feed += amount
	
	start_action("buy")
	show_toast("购买 %d 份饲料 / Bought %d feed" % [amount, amount])
	refresh_all()
	save_game()


func sell_all_storage():
	var total_sale: int = 0
	var lines_zh: Array = []
	var lines_en: Array = []
	
	for id in crop_order:
		var amount: int = int(storage[id])
		
		if amount <= 0:
			continue
		
		var data: Dictionary = crop_data[id]
		var subtotal: int = amount * int(data["sell_price"])
		total_sale += subtotal
		
		lines_zh.append("%s × %d = %d 金币" % [
			str(data["zh"]),
			amount,
			subtotal
		])
		
		lines_en.append("%s × %d = %d coins" % [
			str(data["en"]),
			amount,
			subtotal
		])
		
		storage[id] = 0
	
	var egg_amount: int = int(storage["egg"])
	if egg_amount > 0:
		var egg_subtotal: int = egg_amount * int(animal_type_data["chicken"]["sell_price"])
		total_sale += egg_subtotal
		lines_zh.append("鸡蛋 × %d = %d 金币" % [egg_amount, egg_subtotal])
		lines_en.append("Egg × %d = %d coins" % [egg_amount, egg_subtotal])
		storage["egg"] = 0
	
	var milk_amount: int = int(storage["milk"])
	if milk_amount > 0:
		var milk_subtotal: int = milk_amount * int(animal_type_data["cow"]["sell_price"])
		total_sale += milk_subtotal
		lines_zh.append("牛奶 × %d = %d 金币" % [milk_amount, milk_subtotal])
		lines_en.append("Milk × %d = %d coins" % [milk_amount, milk_subtotal])
		storage["milk"] = 0
	
	if total_sale <= 0:
		show_message(
			"仓库是空的",
			"Storage is empty",
			"现在没有可以卖出的收获。先种一点、浇一点、照顾一下小动物吧。",
			"There is nothing to sell right now. Plant a little, water a little, and care for the animals first."
		)
		return
	
	coins += total_sale
	
	start_action("sell")
	show_message(
		"卖出成功",
		"Sold harvests",
		"你卖出了仓库里的东西：\n%s\n\n一共获得 %d 金币。" % [
			"\n".join(lines_zh),
			total_sale
		],
		"You sold the things in storage:\n%s\n\nYou earned %d coins in total." % [
			"\n".join(lines_en),
			total_sale
		]
	)
	
	refresh_all()
	save_game()


# ============================================================
# DISPLAY
# ============================================================

func refresh_all():
	refresh_hud()
	refresh_plots()
	refresh_animals()


func refresh_hud():
	var season: Dictionary = seasons[season_index]
	var selected: Dictionary = crop_data[selected_crop]
	
	hud_text.text = """
[font_size=15][color=#FFFFFF]第 %d 天 | %s | %s | 金币: %d | 体力: %d/%d | 水: %d/%d[/color][/font_size]
[font_size=12][color=#DDDDDD]Day %d | %s | %s | Coins: %d | Energy: %d/%d | Water: %d/%d[/color][/font_size]

[font_size=13][color=#FFFFFF]当前种子: %s | 饲料: %d | 总收获: %d[/color][/font_size]
[font_size=12][color=#DDDDDD]Selected: %s | Feed: %d | Harvests: %d[/color][/font_size]

[font_size=12][color=#FFFFFF]1思念:%d  2抱抱:%d  3勇气:%d  4亲亲:%d  5月光:%d  6星星:%d[/color][/font_size]
[font_size=11][color=#DDDDDD]E interact | B seed | F feed | V sell | House sleep[/color][/font_size]
""" % [
		day, str(season["zh"]), get_weather_zh(), coins, energy, MAX_ENERGY, water, MAX_WATER,
		day, str(season["en"]), get_weather_en(), coins, energy, MAX_ENERGY, water, MAX_WATER,
		str(selected["seed_zh"]), animal_feed, total_harvested,
		str(selected["seed_en"]), animal_feed, total_harvested,
		int(seeds["missing"]), int(seeds["hug"]), int(seeds["courage"]),
		int(seeds["kiss"]), int(seeds["moon"]), int(seeds["star"])
	]


func refresh_plots():
	for i in range(plot_nodes.size()):
		refresh_plot_visual(i)


func refresh_plot_visual(index: int):
	if index < 0 or index >= plot_nodes.size():
		return
	
	var plot_node: Area2D = plot_nodes[index]
	var plot: Dictionary = plots[index]
	var crop_id: String = str(plot["crop"])
	
	var plant_sprite: Sprite2D = plot_node.get_node_or_null("PlantSprite") as Sprite2D
	var label: Label = plot_node.get_node_or_null("PlotLabel") as Label
	
	if crop_id == "":
		if plant_sprite != null:
			plant_sprite.visible = false
		
		if label != null:
			label.text = ""
		
		return
	
	var data: Dictionary = crop_data[crop_id]
	var growth: int = int(plot["growth"])
	var needed: int = int(data["days_to_grow"])
	var ready: bool = bool(plot["ready"])
	
	if plant_sprite != null:
		plant_sprite.visible = true
		
		if plants_texture != null:
			plant_sprite.texture = plants_texture
			plant_sprite.region_enabled = true
			plant_sprite.region_rect = get_plant_region(growth, needed, ready)
			plant_sprite.modulate = data["tint"]
		else:
			plant_sprite.visible = false
	
	if label != null:
		if ready:
			label.text = "可收\nReady"
		else:
			var mark: String = ""
			
			if bool(plot["watered"]):
				mark = "✓"
			
			label.text = "%d/%d%s" % [growth, needed, mark]


func get_plant_region(growth: int, needed: int, ready: bool) -> Rect2:
	if ready:
		return Rect2(64, 0, 16, 16)
	
	if growth <= 0:
		return Rect2(16, 0, 16, 16)
	
	if growth < needed - 1:
		return Rect2(32, 0, 16, 16)
	
	return Rect2(48, 0, 16, 16)


func refresh_animals():
	for i in range(animal_nodes.size()):
		var node: Area2D = animal_nodes[i]
		var animal: Dictionary = animals[i]
		var label: Label = node.get_node_or_null("Label") as Label
		
		if label == null:
			continue
		
		var status: String = ""
		
		if bool(animal["product_ready"]):
			status = "礼物"
		elif not bool(animal["fed"]):
			status = "饿"
		elif not bool(animal["petted"]):
			status = "摸"
		else:
			status = "♥"
		
		label.text = "%s %s" % [str(animal["name"]), status]


func is_crop_unlocked(crop_id: String) -> bool:
	return total_harvested >= int(crop_data[crop_id]["unlock_at"])


# ============================================================
# TOAST / MESSAGE
# ============================================================

func show_toast(text: String):
	toast_panel.visible = true
	toast_text.text = text
	toast_timer = 2.2


func update_toast(delta: float):
	if toast_timer <= 0.0:
		toast_panel.visible = false
		return
	
	toast_timer -= delta
	
	if toast_timer <= 0.0:
		toast_panel.visible = false


func show_welcome_message():
	show_message(
		"欢迎来到爱的小花园",
		"Welcome to Love Garden",
		"这里现在是一个真正的小农场啦。你可以种花、浇水、睡觉让它们长大、收获、卖掉、买更多种子，也可以照顾小鸡和小牛。\n\n这版已经加入了角色走路动画、小鸡小牛贴图、天气、季节、体力、水壶、仓库、小屋内饰和保存系统。",
		"This is now a real little farm. You can plant flowers, water them, sleep so they grow, harvest them, sell them, buy more seeds, and take care of chickens and cows.\n\nThis version includes walking animation, chicken/cow sprites, weather, seasons, energy, watering can, storage, house interior, and saving."
	)


func show_message(title_zh: String, title_en: String, body_zh: String, body_en: String):
	message_panel.visible = true
	message_panel.z_index = 10000
	message_panel.z_as_relative = false
	message_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	message_panel.move_to_front()
	
	message_text.scroll_active = true
	message_text.scroll_following = false
	message_text.fit_content = false
	message_text.mouse_filter = Control.MOUSE_FILTER_STOP
	message_text.clip_contents = true
	message_text.custom_minimum_size = Vector2(MESSAGE_WIDTH - 56, MESSAGE_HEIGHT - 112)
	message_text.size = Vector2(MESSAGE_WIDTH - 56, MESSAGE_HEIGHT - 112)
	
	var extra_hint: String = ""
	if body_zh.length() + body_en.length() > 220:
		extra_hint = "\n\n[color=#BBBBBB]鼠标滚轮 / PageUp / PageDown 可以上下阅读[/color]\n[color=#999999]Use mouse wheel / PageUp / PageDown to scroll[/color]"
	
	message_text.text = """
[center]
[font_size=26][color=#C94F8C]%s[/color][/font_size]
[font_size=15][color=#CCCCCC]%s[/color][/font_size]

[font_size=20][color=#FFE1EF]%s[/color][/font_size]

[font_size=15][color=#DDDDDD]%s[/color][/font_size]
%s
[/center]
""" % [title_zh, title_en, body_zh, body_en, extra_hint]
	
	message_text.scroll_to_line(0)
	close_message_button.move_to_front()
	
	
func close_message():
	message_panel.visible = false


# ============================================================
# SAVE / LOAD
# ============================================================

func save_game():
	var data: Dictionary = {
		"version": SAVE_VERSION,
		"day": day,
		"season_index": season_index,
		"weather": weather,
		"coins": coins,
		"energy": energy,
		"water": water,
		"animal_feed": animal_feed,
		"selected_crop": selected_crop,
		"total_harvested": total_harvested,
		"seeds": seeds,
		"storage": storage,
		"plots": plots,
		"animals": animals,
		"house_style_index": house_style_index,
		"house_memory_count": house_memory_count,
		"house_plant_level": house_plant_level,
		"house_outfit_index": house_outfit_index,
		"house_diary_entries": house_diary_entries,
		"room_is_night": room_is_night,
		"current_house_room": current_house_room,
		"player_position": {
			"x": player.global_position.x,
			"y": player.global_position.y
		}
	}
	
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file == null:
		push_error("Could not save Love Garden.")
		return
	
	file.store_string(JSON.stringify(data))


func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	if file == null:
		return
	
	var parsed = JSON.parse_string(file.get_as_text())
	
	if not (parsed is Dictionary):
		return
	
	if int(parsed.get("version", -1)) != SAVE_VERSION:
		return
	
	day = int(parsed.get("day", day))
	season_index = int(parsed.get("season_index", season_index))
	weather = str(parsed.get("weather", weather))
	coins = int(parsed.get("coins", coins))
	energy = int(parsed.get("energy", energy))
	water = int(parsed.get("water", water))
	animal_feed = int(parsed.get("animal_feed", animal_feed))
	selected_crop = str(parsed.get("selected_crop", selected_crop))
	total_harvested = int(parsed.get("total_harvested", total_harvested))
	house_style_index = int(parsed.get("house_style_index", house_style_index))
	house_memory_count = int(parsed.get("house_memory_count", house_memory_count))
	house_plant_level = int(parsed.get("house_plant_level", house_plant_level))
	house_outfit_index = int(parsed.get("house_outfit_index", house_outfit_index))
	house_diary_entries = int(parsed.get("house_diary_entries", house_diary_entries))
	room_is_night = bool(parsed.get("room_is_night", room_is_night))
	current_house_room = str(parsed.get("current_house_room", current_house_room))
	
	var loaded_seeds = parsed.get("seeds", seeds)
	if loaded_seeds is Dictionary:
		for id in seeds.keys():
			seeds[id] = int(loaded_seeds.get(id, seeds[id]))
	
	var loaded_storage = parsed.get("storage", storage)
	if loaded_storage is Dictionary:
		for id in storage.keys():
			storage[id] = int(loaded_storage.get(id, storage[id]))
	
	var loaded_plots = parsed.get("plots", plots)
	if loaded_plots is Array and loaded_plots.size() == plots.size():
		plots = loaded_plots
	
	var loaded_animals = parsed.get("animals", animals)
	if loaded_animals is Array and loaded_animals.size() == animals.size():
		animals = loaded_animals
	
	var loaded_pos = parsed.get("player_position", {})
	if loaded_pos is Dictionary:
		player.global_position = Vector2(
			float(loaded_pos.get("x", PLAYER_START.x)),
			float(loaded_pos.get("y", PLAYER_START.y))
		)
	
	build_world()
	refresh_house_room_visuals()


# ============================================================
# NAVIGATION
# ============================================================

func go_back():
	save_game()
	
	if ResourceLoader.exists("res://scenes/main_menu.tscn"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
