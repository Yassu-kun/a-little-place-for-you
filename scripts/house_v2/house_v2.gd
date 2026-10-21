extends CanvasLayer

signal sleep_requested

const SAVE_PATH: String = "user://house_v2_save.json"
const CHARACTER_SHEET_PATH: String = "res://assets/love_garden/sprout_lands/Sprout Lands - Sprites - Basic pack/Characters/Basic Charakter Spritesheet.png"
const FONT_REGULAR_PATH: String = "res://assets/fonts/NotoSansSC-Regular.ttf"
const FONT_BOLD_PATH: String = "res://assets/fonts/NotoSansSC-Bold.ttf"
const PLAYER_FRAME_SIZE: Vector2 = Vector2(48, 48)

const BedroomRoomScript = preload("res://scripts/house_v2/bedroom_room.gd")
const LivingRoomScript = preload("res://scripts/house_v2/living_room.gd")
const KitchenRoomScript = preload("res://scripts/house_v2/kitchen_room.gd")
const BathroomRoomScript = preload("res://scripts/house_v2/bathroom_room.gd")


var is_open: bool = false

var root_panel: Panel
var title_label: Label
var stage: Panel
var hint_label: Label
var hover_label: Label
var highlight_panel: Panel

var message_panel: Panel
var message_text: RichTextLabel
var message_close_button: Button

var sleep_button: Button
var diary_panel: Panel
var diary_entries_text: RichTextLabel
var diary_input: TextEdit
var diary_save_button: Button
var diary_close_button: Button

var player_node: ColorRect
var player_sprite: Sprite2D
var player_label: Label

var character_texture: Texture2D
var ui_font_regular: FontFile
var ui_font_bold: FontFile

var asset_registry: RefCounted

var rooms: Dictionary = {}
var current_room: String = "living"
var hotspots: Dictionary = {}
var target_id: String = ""

var player_speed: float = 245.0
var player_facing: String = "down"
var player_moving: bool = false
var player_anim_timer: float = 0.0
var player_anim_frame: int = 0


var house_state: Dictionary = {
	"night": false,
	"theme": 0,
	"diary_entries": 0,
	"plant_level": 0,
	"memory_count": 0,
	"outfit": 0,
	"diary_custom_entries": []
}

var room_blockers: Array[Rect2] = []

var wardrobe_panel: Panel
var wardrobe_title: Label
var wardrobe_description: RichTextLabel
var wardrobe_buttons_box: VBoxContainer
var wardrobe_close_button: Button
var wardrobe_layer: CanvasLayer

var outfit_data: Array = [
	{
		"id": "default",
		"zh": "日常小衣服",
		"en": "Everyday Outfit",
		"color": Color("#FFFFFF"),
		"desc_zh": "最自然、最像她平时的小衣服。简单、干净、舒服，像这个小家最开始的样子。",
		"desc_en": "A simple everyday outfit. Clean, soft, comfortable, like the first gentle version of this little home."
	},
	{
		"id": "pink_pajamas",
		"zh": "粉色睡衣",
		"en": "Pink Pajamas",
		"color": Color("#FFD1E8"),
		"desc_zh": "软软的粉色睡衣，适合晚上在小屋里看窗外、写日记、慢慢休息。",
		"desc_en": "Soft pink pajamas, perfect for quiet nights, looking out the window, writing in the diary, and resting slowly."
	},
	{
		"id": "blue_cardigan",
		"zh": "蓝色小开衫",
		"en": "Blue Cardigan",
		"color": Color("#BFE7FF"),
		"desc_zh": "温柔的蓝色小开衫，像晴天窗边的光。适合读书、看照片、在房间里慢慢走。",
		"desc_en": "A gentle blue cardigan, like daylight by the window. Good for reading, looking at photos, and walking slowly around the room."
	},
	{
		"id": "garden_outfit",
		"zh": "花园小裙子",
		"en": "Garden Outfit",
		"color": Color("#CFF5B8"),
		"desc_zh": "适合照顾小花园的小衣服。以后可以真的配上围裙、草帽、浇水壶和小靴子。",
		"desc_en": "A little outfit for taking care of the garden. Later it can have an apron, straw hat, watering can, and tiny boots."
	},
	{
		"id": "purple_dress",
		"zh": "紫色约会裙",
		"en": "Purple Date Dress",
		"color": Color("#E2D0FF"),
		"desc_zh": "一点点梦幻、一点点害羞的小裙子。适合以后放在特别约会、纪念日或秘密回忆里。",
		"desc_en": "A dreamy and slightly shy little dress. Later it can be used for special dates, anniversaries, or secret memories."
	},
	{
		"id": "warm_apron",
		"zh": "暖色小围裙",
		"en": "Warm Apron",
		"color": Color("#FFE0A8"),
		"desc_zh": "像厨房里的小阳光。以后可以和料理、便当、甜点、一起吃饭的小互动连在一起。",
		"desc_en": "Like a tiny bit of sunshine in the kitchen. Later it can connect to cooking, lunch boxes, desserts, and eating together."
	}
]

func _ready():
	layer = 80
	load_assets()
	setup_asset_registry()
	create_rooms()
	build_ui()
	load_state()
	change_room(current_room)
	ensure_state_defaults()
	root_panel.visible = false


func load_assets():
	character_texture = load(CHARACTER_SHEET_PATH) as Texture2D
	ui_font_regular = load(FONT_REGULAR_PATH) as FontFile
	ui_font_bold = load(FONT_BOLD_PATH) as FontFile
	
func setup_asset_registry():
	var registry_script: Script = load("res://scripts/asset_registry.gd") as Script
	
	if registry_script == null:
		push_warning("House V2 could not load asset_registry.gd")
		return
	
	asset_registry = registry_script.new() as RefCounted
	
	if asset_registry == null:
		push_warning("House V2 could not create asset registry.")
		return
	
	if asset_registry.has_method("load_all"):
		asset_registry.call("load_all")


func create_rooms():
	rooms["bedroom"] = BedroomRoomScript.new()
	rooms["living"] = LivingRoomScript.new()
	rooms["kitchen"] = KitchenRoomScript.new()
	rooms["bathroom"] = BathroomRoomScript.new()


func build_ui():
	root_panel = Panel.new()
	root_panel.name = "HouseV2Root"
	root_panel.position = Vector2(46, 10)
	root_panel.size = Vector2(1060, 620)
	root_panel.z_index = 100
	root_panel.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.14, 0.10, 0.10, 0.98), Color(0.96, 0.82, 0.72), 3, 18)
	)
	add_child(root_panel)

	var title_bg: Panel = Panel.new()
	title_bg.position = Vector2(18, 14)
	title_bg.size = Vector2(1024, 44)
	title_bg.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.10, 0.07, 0.08, 0.92), Color(0.95, 0.82, 0.75), 2, 10)
	)
	root_panel.add_child(title_bg)

	title_label = Label.new()
	title_label.position = Vector2.ZERO
	title_label.size = title_bg.size
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.text = "House V2"
	style_label(title_label, 21, true)
	title_bg.add_child(title_label)

	create_room_tabs()

	stage = Panel.new()
	stage.name = "HouseV2Stage"
	stage.position = Vector2(120, 102)
	stage.size = Vector2(820, 430)
	stage.clip_contents = true
	stage.z_index = 1
	stage.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#2B1F1B"), Color("#533428"), 3, 8)
	)
	root_panel.add_child(stage)

	hint_label = Label.new()
	hint_label.position = Vector2(260, 536)
	hint_label.size = Vector2(540, 34)
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint_label.text = ""
	hint_label.z_index = 400
	style_label(hint_label, 17, true)
	root_panel.add_child(hint_label)

	sleep_button = Button.new()
	sleep_button.position = Vector2(612, 574)
	sleep_button.size = Vector2(180, 36)
	sleep_button.text = "睡觉到明天 / Sleep"
	style_button(sleep_button, 16, true)
	sleep_button.pressed.connect(request_sleep)
	root_panel.add_child(sleep_button)

	var close_button: Button = Button.new()
	close_button.position = Vector2(812, 574)
	close_button.size = Vector2(180, 36)
	close_button.text = "离开房子 / Leave"
	style_button(close_button, 16, true)
	close_button.pressed.connect(close_house)
	root_panel.add_child(close_button)

	create_message_panel()
	create_diary_panel()


func create_room_tabs():
	var defs: Array = [
		{"room": "bedroom", "text": "卧室 / Bedroom"},
		{"room": "living", "text": "客厅 / Living"},
		{"room": "kitchen", "text": "厨房 / Kitchen"},
		{"room": "bathroom", "text": "浴室 / Bathroom"}
	]

	for i in range(defs.size()):
		var info: Dictionary = defs[i]
		var button: Button = Button.new()
		button.position = Vector2(30 + i * 250, 64)
		button.size = Vector2(235, 30)
		button.text = str(info["text"])
		style_button(button, 14, true)
		button.pressed.connect(change_room.bind(str(info["room"])))
		root_panel.add_child(button)


func create_message_panel():
	message_panel = Panel.new()
	message_panel.position = Vector2(210, 128)
	message_panel.size = Vector2(640, 380)
	message_panel.visible = false
	message_panel.z_index = 2000
	message_panel.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.18, 0.15, 0.20, 0.97), Color(0.96, 0.76, 0.87), 3, 16)
	)
	root_panel.add_child(message_panel)

	message_text = RichTextLabel.new()
	message_text.position = Vector2(26, 24)
	message_text.size = Vector2(588, 278)
	message_text.bbcode_enabled = true
	message_text.scroll_active = true
	message_text.fit_content = false
	message_text.clip_contents = true
	style_rich_text(message_text, 18)
	message_panel.add_child(message_text)

	message_close_button = Button.new()
	message_close_button.position = Vector2(220, 316)
	message_close_button.size = Vector2(200, 42)
	message_close_button.text = "知道啦 / Okay"
	style_button(message_close_button, 17, true)
	message_close_button.pressed.connect(close_message)
	message_panel.add_child(message_close_button)


func change_room(room_id: String):
	if not rooms.has(room_id):
		return

	current_room = room_id
	clear_children(stage)
	hotspots.clear()
	target_id = ""

	draw_room_shell()

	var room: Variant = rooms.get(current_room)
	if room != null:
		room.set("assets", asset_registry)
		room.build(stage, Callable(self, "register_hotspot"), house_state)

		room_blockers = build_blockers_from_hotspots()

		title_label.text = "大房子：%s / Big House: %s" % [str(room.title_zh), str(room.title_en)]
		create_player(room.spawn_point)

	create_overlay_nodes()
	refresh_target()
	save_state()


func draw_room_shell():
	var theme: int = int(house_state.get("theme", 0))
	var night: bool = bool(house_state.get("night", false))

	var wall_color: Color = Color("#D7B89E")
	var floor_color: Color = Color("#A76649")
	var trim_color: Color = Color("#6B4634")
	var line_color: Color = Color(0.22, 0.12, 0.08, 0.18)

	match current_room:
		"bedroom":
			wall_color = Color("#E5B8C8")
			floor_color = Color("#8B6F68")
			trim_color = Color("#6B4E49")
			line_color = Color(0.18, 0.10, 0.08, 0.20)
		"living":
			wall_color = Color("#DFC3BA")
			floor_color = Color("#8A6B5C")
			trim_color = Color("#675044")
			line_color = Color(0.18, 0.11, 0.08, 0.20)
		"kitchen":
			wall_color = Color("#E8C8AA")
			floor_color = Color("#9A7853")
			trim_color = Color("#735339")
			line_color = Color(0.20, 0.12, 0.06, 0.20)
		"bathroom":
			wall_color = Color("#D6E8EE")
			floor_color = Color("#7799A4")
			trim_color = Color("#5D7C86")
			line_color = Color(1, 1, 1, 0.14)

	match theme:
		1:
			wall_color = wall_color.lerp(Color("#F1B8D0"), 0.35)
			floor_color = floor_color.lerp(Color("#9B6176"), 0.25)
			trim_color = trim_color.lerp(Color("#7E5063"), 0.25)
		2:
			wall_color = wall_color.lerp(Color("#CFE4B8"), 0.35)
			floor_color = floor_color.lerp(Color("#6F8E52"), 0.25)
			trim_color = trim_color.lerp(Color("#4E6B3B"), 0.25)
		3:
			wall_color = wall_color.lerp(Color("#C9C5EA"), 0.35)
			floor_color = floor_color.lerp(Color("#5D5A80"), 0.25)
			trim_color = trim_color.lerp(Color("#454364"), 0.25)

	if night:
		wall_color = wall_color.darkened(0.22)
		floor_color = floor_color.darkened(0.22)
		trim_color = trim_color.darkened(0.18)

	add_rect(Vector2.ZERO, Vector2(stage.size.x, 118), wall_color, 0)
	add_rect(Vector2(0, 106), Vector2(stage.size.x, stage.size.y - 106), floor_color, 0)
	add_rect(Vector2(0, 104), Vector2(stage.size.x, 6), trim_color, 5)

	for y in range(126, int(stage.size.y), 30):
		add_rect(Vector2(0, y), Vector2(stage.size.x, 3), line_color, 2)

	for x in range(0, int(stage.size.x), 88):
		var offset_y: int = 130
		if int(x / 88) % 2 == 1:
			offset_y = 145

		for y in range(offset_y, int(stage.size.y), 60):
			add_rect(Vector2(x, y), Vector2(3, 22), line_color.darkened(0.12), 2)

	if current_room == "bathroom":
		for x in range(0, int(stage.size.x), 58):
			add_rect(Vector2(x, 112), Vector2(2, stage.size.y - 112), Color(1, 1, 1, 0.08), 3)

		for y in range(135, int(stage.size.y), 58):
			add_rect(Vector2(0, y), Vector2(stage.size.x, 2), Color(1, 1, 1, 0.08), 3)

	if night:
		add_rect(Vector2.ZERO, stage.size, Color(0.02, 0.04, 0.08, 0.20), 350)		
		
func create_player(pos: Vector2):
	player_node = ColorRect.new()
	player_node.name = "HouseV2Player"
	player_node.position = pos
	player_node.size = Vector2(30, 38)
	player_node.color = Color(1, 1, 1, 0.0)
	player_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_node.z_index = 500
	stage.add_child(player_node)

	player_sprite = Sprite2D.new()
	player_sprite.centered = true
	player_sprite.position = Vector2(15, 16)
	player_sprite.scale = Vector2(1.35, 1.35)
	player_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	player_sprite.z_index = 501
	player_node.add_child(player_sprite)

	if character_texture != null:
		player_sprite.texture = character_texture
		player_sprite.region_enabled = true
		set_player_frame("down", 0)

	apply_player_outfit()

	player_label = Label.new()
	player_label.position = Vector2(-35, -34)
	player_label.size = Vector2(100, 24)
	player_label.text = "你 / You"
	player_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	player_label.z_index = 502
	style_label(player_label, 13, true)
	player_node.add_child(player_label)




func create_overlay_nodes():
	highlight_panel = Panel.new()
	highlight_panel.visible = false
	highlight_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	highlight_panel.z_index = 800
	highlight_panel.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(1, 1, 1, 0.012), Color("#FFF1C8"), 2, 8)
	)
	stage.add_child(highlight_panel)

	hover_label = Label.new()
	hover_label.visible = false
	hover_label.size = Vector2(260, 30)
	hover_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hover_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hover_label.z_index = 820
	style_label(hover_label, 16, true)
	stage.add_child(hover_label)
	

func register_hotspot(id: String, rect: Rect2, zh: String, en: String, action: String, data: Dictionary):
	hotspots[id] = {
		"rect": rect,
		"zh": zh,
		"en": en,
		"action": action,
		"data": data
	}


func open_house():
	is_open = true
	root_panel.visible = true
	change_room(current_room)


func close_house():
	is_open = false
	root_panel.visible = false
	save_state()


func is_house_open() -> bool:
	return is_open


func _process(delta: float):
	if not is_open:
		return

	if diary_panel != null and diary_panel.visible:
		player_moving = false
		update_player_animation(delta)
		return

	if message_panel.visible:
		player_moving = false
		update_player_animation(delta)
		return
		
	if is_wardrobe_open():
		return

	handle_player_movement(delta)
	update_player_animation(delta)
	refresh_target()


func handle_player_movement(delta: float):
	if player_node == null:
		return

	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	player_moving = input_vector.length() > 0.01

	if player_moving:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				player_facing = "right"
			else:
				player_facing = "left"
		else:
			if input_vector.y > 0:
				player_facing = "down"
			else:
				player_facing = "up"

		input_vector = input_vector.normalized()

	var new_pos: Vector2 = player_node.position + input_vector * player_speed * delta
	new_pos.x = clampf(new_pos.x, 18.0, stage.size.x - 48.0)
	new_pos.y = clampf(new_pos.y, 112.0, stage.size.y - 44.0)

	if can_room_player_move_to(new_pos):
		player_node.position = new_pos
		return

	var x_only: Vector2 = Vector2(new_pos.x, player_node.position.y)
	var y_only: Vector2 = Vector2(player_node.position.x, new_pos.y)

	if can_room_player_move_to(x_only):
		player_node.position = x_only
	elif can_room_player_move_to(y_only):
		player_node.position = y_only
		



func set_player_frame(direction: String, frame: int):
	if character_texture == null or player_sprite == null:
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
	if player_sprite == null:
		return

	if player_moving:
		player_anim_timer += delta
		if player_anim_timer >= 0.16:
			player_anim_timer = 0.0
			player_anim_frame = (player_anim_frame + 1) % 4
		set_player_frame(player_facing, player_anim_frame)
	else:
		player_anim_timer = 0.0
		player_anim_frame = 0
		set_player_frame(player_facing, 0)


func refresh_target():
	target_id = ""

	if player_node == null:
		return

	var player_center: Vector2 = player_node.position + player_node.size / 2.0
	var mouse_local: Vector2 = stage.get_local_mouse_position()
	var best_distance: float = 999999.0

	for id in hotspots.keys():
		var data: Dictionary = hotspots[id]
		var rect: Rect2 = data["rect"]

		var expanded: Rect2 = rect.grow(54.0)
		var mouse_rect: Rect2 = rect.grow(10.0)

		var is_mouse_hovering: bool = mouse_rect.has_point(mouse_local)
		var is_player_near: bool = expanded.has_point(player_center)

		if not is_mouse_hovering and not is_player_near:
			continue

		var distance: float = player_center.distance_to(rect.position + rect.size / 2.0)
		if is_mouse_hovering:
			distance = -1.0

		if distance < best_distance:
			best_distance = distance
			target_id = str(id)

	if target_id == "":
		hint_label.text = ""
		highlight_panel.visible = false
		hover_label.visible = false
		return

	var target: Dictionary = hotspots[target_id]
	var target_rect: Rect2 = target["rect"]

	hint_label.text = "按 E 互动：%s / %s" % [str(target["zh"]), str(target["en"])]

	highlight_panel.visible = true
	highlight_panel.position = target_rect.position
	highlight_panel.size = target_rect.size

	hover_label.visible = true
	hover_label.text = "%s / %s" % [str(target["zh"]), str(target["en"])]
	hover_label.position = Vector2(
		target_rect.position.x + target_rect.size.x / 2.0 - 130,
		target_rect.position.y - 30
	)


func interact_target():
	if target_id == "":
		return

	var data: Dictionary = hotspots[target_id]
	var action: String = str(data["action"])
	var extra: Dictionary = data.get("data", {})

	match action:
		"switch_room":
			change_room(str(extra.get("room", "living")))

		"close":
			close_house()

		"toggle_night":
			house_state["night"] = !bool(house_state.get("night", false))
			save_state()
			change_room(current_room)

			if bool(house_state.get("night", false)):
				show_house_message(
					"夜晚模式",
					"Night mode",
					"窗外暗下来了，房间变得更安静、更温柔。现在这里像一个可以躲进去休息的小世界。",
					"The outside became dark, and the room feels quieter and softer now."
				)
			else:
				show_house_message(
					"白天模式",
					"Day mode",
					"阳光回来了，小屋又变得明亮起来。",
					"The sunlight is back, and the little house feels bright again."
				)

		"theme":
			house_state["theme"] = (int(house_state.get("theme", 0)) + 1) % 4
			save_state()
			change_room(current_room)
			show_house_message(
				"装饰风格已切换",
				"Decor changed",
				"她打开装饰箱，换了一种小屋氛围。以后这里可以继续扩展成真正的家具皮肤包。",
				"She opened the decor chest and changed the home atmosphere. Later this can become a real furniture skin system."
			)

		"wardrobe":
			open_wardrobe_panel()

		"plant":
			house_state["plant_level"] = int(house_state.get("plant_level", 0)) + 1
			save_state()
			show_house_message(
				"小植物",
				"Little plant",
				"她照顾了一下小植物。它好像又精神了一点。植物等级：%d。" % int(house_state.get("plant_level", 0)),
				"She cared for the little plant. It looks a little happier. Plant level: %d." % int(house_state.get("plant_level", 0))
			)

		"photo_wall":
			house_state["memory_count"] = int(house_state.get("memory_count", 0)) + 1
			save_state()
			show_house_message(
				"照片墙",
				"Photo Wall",
				"这里以后可以放你们的旅行照片、截图、可爱的回忆，甚至每张照片都可以点开一封小信。已查看回忆：%d 次。" % int(house_state.get("memory_count", 0)),
				"This wall can later hold travel photos, screenshots, cute memories, and even a small letter behind each photo. Memories viewed: %d." % int(house_state.get("memory_count", 0))
			)

		"diary":
			open_diary_editor()

		"sleep":
			show_house_message(
				"睡觉准备",
				"Ready to sleep",
				"如果她想结束今天，点击右下角的“睡觉到明天”。明天植物会继续长大，小动物也可能准备礼物。",
				"If she wants to end the day, press the Sleep button in the lower-right corner. Tomorrow the plants keep growing and the animals may prepare gifts."
			)

		"bookshelf":
			show_house_message(
				"书架",
				"Bookshelf",
				"你从书架上抽出一本小书，里面写着：被爱不是任务，是可以慢慢相信的事情。",
				"You pull a small book from the shelf. It says: being loved is not a task; it is something she can slowly learn to trust."
			)

		"message":
			show_house_message(
				str(extra.get("title_zh", data["zh"])),
				str(extra.get("title_en", data["en"])),
				str(extra.get("body_zh", "这里以后会有更多互动。")),
				str(extra.get("body_en", "More interactions will be added here later."))
			)

		_:
			show_house_message(
				str(data["zh"]),
				str(data["en"]),
				"这里以后会有更多互动。",
				"More interactions will be added here later."
			)
	check_hidden_final_secret()
	save_state()

func get_photo_wall_text_zh() -> String:
	var count: int = int(house_state.get("memory_count", 0))
	var index: int = count % 4
	
	match index:
		0:
			return "这面照片墙以后可以放你们的旅行照片、截图、可爱的回忆，甚至每张照片都可以点开一封小信。"
		1:
			return "她靠近照片墙的时候，房间好像安静了一点，因为这里放着那些被认真珍惜过的瞬间。"
		2:
			return "有些照片不是为了证明什么，只是为了提醒她：她一直被温柔地放在心里。"
		_:
			return "以后这里可以慢慢加入波尔多、巴黎、布鲁塞尔、阿姆斯特丹、中国见面的回忆。每一张都可以变成一个小故事。"


func get_photo_wall_text_en() -> String:
	var count: int = int(house_state.get("memory_count", 0))
	var index: int = count % 4
	
	match index:
		0:
			return "This photo wall can later hold travel photos, screenshots, cute memories, and even a small letter behind each photo."
		1:
			return "When she gets close to the photo wall, the room feels quieter, because these are moments that were carefully treasured."
		2:
			return "Some photos are not here to prove anything. They are here to remind her that she is gently kept in someone’s heart."
		_:
			return "Later this can slowly include memories from Bordeaux, Paris, Brussels, Amsterdam, and meeting in China. Every photo can become a tiny story."

func get_diary_text_zh() -> String:
	var index: int = int(house_state.get("diary_entries", 0)) % 5

	match index:
		0:
			return "日记本里写着：今天也想把世界变小一点，小到只够放下你、我、一个小花园和一个温暖的小家。"
		1:
			return "日记本里写着：她认真生活的样子很可爱。她努力、犹豫、害怕、又继续往前走的样子，都值得被抱抱。"
		2:
			return "日记本里写着：以后这里会藏很多封信。不是一次性给完，而是让她每次回来，都能找到一点新的爱。"
		3:
			return "日记本里写着：如果她今天累了，就先休息。小花园不会跑掉，我也不会。"
		_:
			return "日记本里写着：这个小家会慢慢变漂亮，因为它是为她一点一点认真做出来的。"


func get_diary_text_en() -> String:
	var index: int = int(house_state.get("diary_entries", 0)) % 5

	match index:
		0:
			return "The diary says: today I want to make the world a little smaller, small enough to hold only you, me, a little garden, and a warm little home."
		1:
			return "The diary says: the way she tries to live seriously is lovely. Her effort, hesitation, fear, and still moving forward all deserve a hug."
		2:
			return "The diary says: many letters will be hidden here later, little by little, so every time she comes back, she can find new love."
		3:
			return "The diary says: if she is tired today, she can rest first. The little garden will not run away, and neither will I."
		_:
			return "The diary says: this little home will slowly become beautiful because it is being made carefully for her."

func interact_diary():
	var entries: int = int(house_state.get("diary_entries", 0)) + 1
	house_state["diary_entries"] = entries

	var zh_text: String = ""
	var en_text: String = ""

	match entries % 4:
		0:
			zh_text = "日记本里写着：今天也想把世界变小一点，小到只够放下你、我、一个小花园和一个温暖的小家。"
			en_text = "The diary says: today I want to make the world a little smaller, small enough to hold only you, me, a little garden, and a warm little home."
		1:
			zh_text = "日记本里写着：她认真生活的样子很可爱。她努力、犹豫、害怕、又继续往前走的样子，都值得被抱抱。"
			en_text = "The diary says: the way she tries to live seriously is lovely. Her effort, hesitation, fear, and still moving forward all deserve a hug."
		2:
			zh_text = "日记本里写着：以后这里会藏很多封信。不是一次性给完，而是让她每次回来，都能找到一点新的爱。"
			en_text = "The diary says: many letters will be hidden here later, little by little, so every time she comes back, she can find new love."
		_:
			zh_text = "日记本里写着：如果她今天累了，就先休息。小房子不会跑掉，我也不会。"
			en_text = "The diary says: if she is tired today, she can rest first. The little house will not run away, and neither will I."

	show_house_message("日记本", "Diary", zh_text, en_text)


func interact_photo_wall():
	var count: int = int(house_state.get("memory_count", 0)) + 1
	house_state["memory_count"] = count

	var zh_lines: Array = [
		"这面照片墙以后可以放你们的旅行照片、截图、可爱的回忆，甚至每张照片都可以点开一封小信。",
		"她靠近照片墙的时候，房间好像安静了一点，因为这里放着那些被认真珍惜过的瞬间。",
		"有些照片不是为了证明什么，只是为了提醒她：她一直被温柔地放在心里。"
	]

	var en_lines: Array = [
		"This photo wall can later hold travel photos, screenshots, cute memories, and even a small letter behind each photo.",
		"When she gets close to the photo wall, the room feels quieter, because these are little moments someone carefully treasured.",
		"Some photos are not here to prove anything. They are here to remind her that she is gently kept in someone’s heart."
	]

	var index: int = count % zh_lines.size()
	show_house_message("照片墙", "Photo Wall", str(zh_lines[index]), str(en_lines[index]))


func interact_bookshelf():
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
	show_house_message("书架", "Bookshelf", str(zh_books[index]), str(en_books[index]))


func interact_plant():
	var level: int = int(house_state.get("plant_level", 0)) + 1
	house_state["plant_level"] = level

	var zh: String = "你给小植物浇了一点水。"
	var en: String = "You watered the little plant."

	if level >= 3:
		zh += "\n它好像长大了一点点，就像这个小房子也在慢慢变成家。"
		en += "\nIt seems to have grown a tiny bit, just like this little house is slowly becoming a home."

	show_house_message("小植物", "Little plant", zh, en)


func _input(event):
	if not is_open:
		return
	
	if diary_panel != null and diary_panel.visible:
		if event is InputEventKey:
			if event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
				close_diary_editor()
				get_viewport().set_input_as_handled()
		return

	if message_panel.visible:
		if event is InputEventMouseButton:
			if event.pressed:
				var bar: VScrollBar = message_text.get_v_scroll_bar()

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
				if event.keycode == KEY_ESCAPE or event.is_action_pressed("interact"):
					close_message()
					get_viewport().set_input_as_handled()
		return
	
	if is_wardrobe_open():
		if event is InputEventKey:
			if event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
				close_wardrobe_panel()
				get_viewport().set_input_as_handled()
		return
		
	if wardrobe_panel != null and wardrobe_panel.visible:
		if event is InputEventKey:
			if event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
				close_wardrobe_panel()
				get_viewport().set_input_as_handled()
		return
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_ESCAPE:
				close_house()
				get_viewport().set_input_as_handled()
				return

			if event.is_action_pressed("interact"):
				interact_target()
				get_viewport().set_input_as_handled()
				return

	if event is InputEventMouseMotion:
		refresh_target()

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			refresh_target()
			if target_id != "":
				interact_target()
				get_viewport().set_input_as_handled()



func request_sleep():
	close_house()
	emit_signal("sleep_requested")


func create_diary_panel():
	diary_panel = Panel.new()
	diary_panel.name = "DiaryEditorPanel"
	diary_panel.position = Vector2(160, 82)
	diary_panel.size = Vector2(740, 500)
	diary_panel.visible = false
	diary_panel.z_index = 2600
	diary_panel.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.16, 0.12, 0.18, 0.98), Color(0.96, 0.76, 0.87), 3, 16)
	)
	root_panel.add_child(diary_panel)

	var title: Label = Label.new()
	title.position = Vector2(18, 12)
	title.size = Vector2(704, 36)
	title.text = "日记本 / Diary"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	style_label(title, 23, true)
	diary_panel.add_child(title)

	diary_entries_text = RichTextLabel.new()
	diary_entries_text.position = Vector2(24, 56)
	diary_entries_text.size = Vector2(692, 230)
	diary_entries_text.bbcode_enabled = true
	diary_entries_text.scroll_active = true
	diary_entries_text.fit_content = false
	diary_entries_text.clip_contents = true
	style_rich_text(diary_entries_text, 16)
	diary_panel.add_child(diary_entries_text)

	diary_input = TextEdit.new()
	diary_input.position = Vector2(24, 300)
	diary_input.size = Vector2(692, 100)
	diary_input.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	diary_input.text = ""
	diary_panel.add_child(diary_input)

	diary_save_button = Button.new()
	diary_save_button.position = Vector2(150, 420)
	diary_save_button.size = Vector2(210, 42)
	diary_save_button.text = "写进日记 / Save entry"
	style_button(diary_save_button, 16, true)
	diary_save_button.pressed.connect(save_diary_entry)
	diary_panel.add_child(diary_save_button)

	diary_close_button = Button.new()
	diary_close_button.position = Vector2(380, 420)
	diary_close_button.size = Vector2(210, 42)
	diary_close_button.text = "合上日记 / Close"
	style_button(diary_close_button, 16, true)
	diary_close_button.pressed.connect(close_diary_editor)
	diary_panel.add_child(diary_close_button)


func open_diary_editor():
	house_state["diary_entries"] = int(house_state.get("diary_entries", 0)) + 1
	refresh_diary_editor()
	diary_panel.visible = true
	diary_panel.move_to_front()
	diary_input.grab_focus()
	save_state()


func refresh_diary_editor():
	if diary_entries_text == null:
		return

	var entries: Array = []
	var raw_entries: Variant = house_state.get("diary_custom_entries", [])
	if raw_entries is Array:
		entries = raw_entries

	var text: String = "[center][color=#FFE1EF]固定小纸条 / Little saved notes[/color][/center]\n\n"
	text += "[color=#FFFFFF]%s[/color]\n[color=#CCCCCC]%s[/color]\n\n" % [get_diary_text_zh(), get_diary_text_en()]

	text += "[center][color=#FFE1EF]她写下的日记 / Her diary entries[/color][/center]\n"
	if entries.is_empty():
		text += "[color=#BBBBBB]还没有手写日记。可以在下面写第一条。\nNo custom diary entries yet. Write the first one below.[/color]"
	else:
		for i in range(entries.size()):
			var entry_text: String = ""
			var entry: Variant = entries[i]
			if entry is Dictionary:
				entry_text = str(entry.get("text", ""))
			else:
				entry_text = str(entry)
			text += "\n[color=#FFD1E8]#%d[/color] [color=#FFFFFF]%s[/color]\n" % [i + 1, entry_text]

	diary_entries_text.text = text
	diary_entries_text.scroll_to_line(0)


func save_diary_entry():
	if diary_input == null:
		return

	var clean_text: String = diary_input.text.strip_edges()
	if clean_text == "":
		return

	var entries: Array = []
	var raw_entries: Variant = house_state.get("diary_custom_entries", [])
	if raw_entries is Array:
		entries = raw_entries

	entries.append({
		"text": clean_text,
		"room": current_room
	})

	house_state["diary_custom_entries"] = entries
	diary_input.text = ""
	refresh_diary_editor()
	save_state()


func close_diary_editor():
	if diary_panel != null:
		diary_panel.visible = false

func show_house_message(title_zh: String, title_en: String, body_zh: String, body_en: String):
	message_panel.visible = true
	message_panel.move_to_front()

	message_text.text = """
[center]
[font_size=25][color=#C94F8C]%s[/color][/font_size]
[font_size=15][color=#CCCCCC]%s[/color][/font_size]

[font_size=19][color=#FFE1EF]%s[/color][/font_size]

[font_size=15][color=#DDDDDD]%s[/color][/font_size]
[/center]
""" % [title_zh, title_en, body_zh, body_en]

	message_text.scroll_to_line(0)


func close_message():
	message_panel.visible = false


func save_state():
	house_state["current_room"] = current_room

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return

	file.store_string(JSON.stringify(house_state))


func load_state():
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		return

	var loaded: Dictionary = parsed
	for key in loaded.keys():
		house_state[key] = loaded[key]

	current_room = str(house_state.get("current_room", current_room))


func add_rect(pos: Vector2, size: Vector2, color: Color, z: int = 0) -> ColorRect:
	var rect: ColorRect = ColorRect.new()
	rect.position = pos
	rect.size = size
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.z_index = z
	stage.add_child(rect)
	return rect


func add_panel(pos: Vector2, size: Vector2, bg: Color, border: Color, z: int = 0, corner_radius: int = 4) -> Panel:
	var panel: Panel = Panel.new()
	panel.position = pos
	panel.size = size
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.z_index = z
	panel.add_theme_stylebox_override("panel", make_panel_style(bg, border, 2, corner_radius))
	stage.add_child(panel)
	return panel


func make_panel_style(bg: Color, border: Color, border_width: int = 2, corner_radius: int = 4) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(corner_radius)
	return style


func style_label(node: Label, size: int = 18, bold: bool = false):
	if node == null:
		return

	if bold and ui_font_bold != null:
		node.add_theme_font_override("font", ui_font_bold)
	elif ui_font_regular != null:
		node.add_theme_font_override("font", ui_font_regular)

	node.add_theme_font_size_override("font_size", size)
	node.add_theme_color_override("font_color", Color.WHITE)
	node.add_theme_color_override("font_outline_color", Color(0.08, 0.05, 0.04, 0.95))
	node.add_theme_constant_override("outline_size", 3)


func style_button(node: Button, size: int = 16, bold: bool = true):
	if node == null:
		return

	if bold and ui_font_bold != null:
		node.add_theme_font_override("font", ui_font_bold)
	elif ui_font_regular != null:
		node.add_theme_font_override("font", ui_font_regular)

	node.add_theme_font_size_override("font_size", size)
	node.add_theme_color_override("font_color", Color.WHITE)
	node.add_theme_color_override("font_outline_color", Color(0.08, 0.05, 0.04, 0.95))
	node.add_theme_constant_override("outline_size", 3)
	node.add_theme_stylebox_override("normal", make_panel_style(Color(0.23, 0.30, 0.22, 0.92), Color(0.82, 0.94, 0.78), 2, 8))
	node.add_theme_stylebox_override("hover", make_panel_style(Color(0.30, 0.38, 0.28, 0.97), Color(0.95, 0.98, 0.88), 2, 8))
	node.add_theme_stylebox_override("pressed", make_panel_style(Color(0.18, 0.24, 0.18, 0.97), Color(0.95, 0.98, 0.88), 2, 8))


func style_rich_text(node: RichTextLabel, size: int = 18):
	if node == null:
		return

	if ui_font_regular != null:
		node.add_theme_font_override("normal_font", ui_font_regular)
		node.add_theme_font_override("italics_font", ui_font_regular)

		if ui_font_bold != null:
			node.add_theme_font_override("bold_font", ui_font_bold)
			node.add_theme_font_override("bold_italics_font", ui_font_bold)
		else:
			node.add_theme_font_override("bold_font", ui_font_regular)
			node.add_theme_font_override("bold_italics_font", ui_font_regular)

	node.add_theme_font_size_override("normal_font_size", size)
	node.add_theme_color_override("default_color", Color.WHITE)


func clear_children(node: Node):
	if node == null:
		return

	for child in node.get_children():
		child.free()

func build_blockers_from_hotspots() -> Array[Rect2]:
	var result: Array[Rect2] = []

	for id in hotspots.keys():
		var data: Dictionary = hotspots[id]
		var rect: Rect2 = data["rect"]
		var action: String = str(data.get("action", ""))

		if id == "window" or id == "photo_wall" or id == "diary" or id == "plushie":
			continue

		if action == "switch_room" or action == "close":
			result.append(Rect2(rect.position + Vector2(5, 12), rect.size - Vector2(10, 20)))
			continue

		var blocker: Rect2 = Rect2(rect.position + Vector2(6, 10), rect.size - Vector2(12, 16))

		if id == "bed":
			blocker = Rect2(rect.position + Vector2(8, 18), rect.size - Vector2(16, 24))
		elif id == "plant":
			blocker = Rect2(rect.position + Vector2(12, 28), rect.size - Vector2(24, 36))
		elif id == "coffee_table" or id == "dining_table":
			blocker = Rect2(rect.position + Vector2(8, 20), rect.size - Vector2(16, 28))

		if blocker.size.x > 4 and blocker.size.y > 4:
			result.append(blocker)

	return result


func get_room_player_foot_rect(test_pos: Vector2) -> Rect2:
	return Rect2(test_pos + Vector2(8, 25), Vector2(16, 12))


func can_room_player_move_to(test_pos: Vector2) -> bool:
	var foot_rect: Rect2 = get_room_player_foot_rect(test_pos)

	for blocker in room_blockers:
		if foot_rect.intersects(blocker):
			return false

	return true



#----------------------------


func ensure_state_defaults():
	if not house_state.has("diary_entries"):
		house_state["diary_entries"] = 0
	
	if not house_state.has("diary_custom_entries"):
		house_state["diary_custom_entries"] = []
	
	if not house_state.has("memory_count"):
		house_state["memory_count"] = 0
	
	if not house_state.has("plant_level"):
		house_state["plant_level"] = 0
	
	if not house_state.has("outfit"):
		house_state["outfit"] = 0
	
	if not house_state.has("theme"):
		house_state["theme"] = 0
	
	if not house_state.has("night"):
		house_state["night"] = false
	
	if not house_state.has("slept_count"):
		house_state["slept_count"] = 0
	
	if not house_state.has("final_secret_unlocked"):
		house_state["final_secret_unlocked"] = false
	
	if not house_state.has("final_secret_seen"):
		house_state["final_secret_seen"] = false
		
	if not house_state.has("outfit"):
		house_state["outfit"] = 0
	
	if not house_state.has("outfit_history"):
		house_state["outfit_history"] = []


func count_hidden_love_signals() -> int:
	var score: int = 0
	
	if int(house_state.get("diary_entries", 0)) >= 2:
		score += 1
	
	var custom_entries: Array = house_state.get("diary_custom_entries", [])
	if custom_entries.size() >= 1:
		score += 1
	
	if int(house_state.get("memory_count", 0)) >= 2:
		score += 1
	
	if int(house_state.get("plant_level", 0)) >= 2:
		score += 1
	
	if int(house_state.get("outfit", 0)) > 0:
		score += 1
	
	if int(house_state.get("theme", 0)) > 0:
		score += 1
	
	if bool(house_state.get("night", false)):
		score += 1
	
	if int(house_state.get("slept_count", 0)) >= 1:
		score += 1
	
	return score


func check_hidden_final_secret():
	if bool(house_state.get("final_secret_unlocked", false)):
		return
	
	if count_hidden_love_signals() < 5:
		return
	
	house_state["final_secret_unlocked"] = true
	save_state()
	
	show_house_message(
		"有一封小信出现了",
		"A little letter appeared",
		"她慢慢熟悉了这个小家以后，抽屉里悄悄出现了一封新的信。\n\n不是任务，也不是奖励，只是因为她愿意一点点靠近这个被认真做出来的小世界。",
		"After she slowly became familiar with this little home, a small letter quietly appeared in a drawer.\n\nIt is not a task and not a reward. It is simply there because she gently came closer to this little world made carefully for her."
	)

func open_diary_panel():
	house_state["diary_entries"] = int(house_state.get("diary_entries", 0)) + 1
	save_state()
	
	show_house_message(
		"日记本",
		"Diary",
		get_diary_text_zh(),
		get_diary_text_en()
	)
	
# ============================================================
# STAGE 6 — WARDROBE / CLOTHING SYSTEM
# Fixed version: uses CanvasLayer so the panel cannot hide behind rooms.
# ============================================================

func get_current_outfit_index() -> int:
	ensure_state_defaults()
	
	var index: int = int(house_state.get("outfit", 0))
	
	if index < 0:
		index = 0
	
	if index >= outfit_data.size():
		index = 0
	
	return index


func get_current_outfit() -> Dictionary:
	return outfit_data[get_current_outfit_index()]


func get_player_outfit_color() -> Color:
	var outfit: Dictionary = get_current_outfit()
	return outfit.get("color", Color.WHITE)


func get_player_outfit_name() -> String:
	var outfit: Dictionary = get_current_outfit()
	return "%s / %s" % [
		str(outfit.get("zh", "小衣服")),
		str(outfit.get("en", "Outfit"))
	]


func apply_player_outfit():
	var outfit_color: Color = get_player_outfit_color()
	
	if player_sprite != null:
		player_sprite.modulate = outfit_color
	
	if player_label != null:
		player_label.text = "你 / You"


func is_wardrobe_open() -> bool:
	if wardrobe_panel == null:
		return false
	
	return wardrobe_panel.visible


func open_wardrobe_panel():
	ensure_state_defaults()
	create_wardrobe_panel_if_needed()
	refresh_wardrobe_panel()
	
	wardrobe_layer.visible = true
	wardrobe_panel.visible = true
	wardrobe_panel.move_to_front()


func create_wardrobe_panel_if_needed():
	if wardrobe_layer == null:
		wardrobe_layer = CanvasLayer.new()
		wardrobe_layer.name = "WardrobeLayer"
		wardrobe_layer.layer = 250
		wardrobe_layer.visible = false
		add_child(wardrobe_layer)
	
	# If an older broken panel exists under the wrong parent, remove it.
	if wardrobe_panel != null and wardrobe_panel.get_parent() != wardrobe_layer:
		wardrobe_panel.queue_free()
		wardrobe_panel = null
	
	if wardrobe_panel != null:
		return
	
	wardrobe_panel = Panel.new()
	wardrobe_panel.name = "WardrobePanel"
	wardrobe_panel.position = Vector2(156, 64)
	wardrobe_panel.size = Vector2(840, 520)
	wardrobe_panel.visible = false
	wardrobe_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	wardrobe_panel.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.16, 0.11, 0.14, 0.98), Color("#FFD1E8"), 3, 18)
	)
	wardrobe_layer.add_child(wardrobe_panel)
	
	wardrobe_title = Label.new()
	wardrobe_title.name = "WardrobeTitle"
	wardrobe_title.position = Vector2(24, 16)
	wardrobe_title.size = Vector2(792, 46)
	wardrobe_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wardrobe_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	style_label(wardrobe_title, 24, true)
	wardrobe_panel.add_child(wardrobe_title)
	
	var preview_box: Panel = Panel.new()
	preview_box.name = "WardrobePreviewBox"
	preview_box.position = Vector2(36, 84)
	preview_box.size = Vector2(230, 310)
	preview_box.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color(0.24, 0.18, 0.22, 0.94), Color("#F4C8D8"), 2, 14)
	)
	wardrobe_panel.add_child(preview_box)
	
	var preview_label: Label = Label.new()
	preview_label.name = "WardrobePreviewLabel"
	preview_label.position = Vector2(18, 16)
	preview_label.size = Vector2(194, 30)
	preview_label.text = "今日造型 / Today"
	preview_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	preview_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	style_label(preview_label, 16, true)
	preview_box.add_child(preview_label)
	
	var head_preview: Panel = Panel.new()
	head_preview.name = "OutfitHeadPreview"
	head_preview.position = Vector2(86, 58)
	head_preview.size = Vector2(58, 50)
	head_preview.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#FFE4C8"), Color("#8E6141"), 2, 20)
	)
	preview_box.add_child(head_preview)
	
	var body_preview: Panel = Panel.new()
	body_preview.name = "OutfitColorPreview"
	body_preview.position = Vector2(82, 92)
	body_preview.size = Vector2(66, 100)
	body_preview.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color.WHITE, Color("#FFEAF4"), 2, 18)
	)
	preview_box.add_child(body_preview)
	
	var feet_preview: Panel = Panel.new()
	feet_preview.name = "OutfitFeetPreview"
	feet_preview.position = Vector2(76, 190)
	feet_preview.size = Vector2(78, 24)
	feet_preview.add_theme_stylebox_override(
		"panel",
		make_panel_style(Color("#6D4A31"), Color("#3F281D"), 2, 8)
	)
	preview_box.add_child(feet_preview)
	
	var preview_hint: RichTextLabel = RichTextLabel.new()
	preview_hint.name = "WardrobePreviewHint"
	preview_hint.position = Vector2(18, 234)
	preview_hint.size = Vector2(194, 58)
	preview_hint.bbcode_enabled = true
	preview_hint.scroll_active = false
	preview_hint.fit_content = false
	style_rich_text(preview_hint, 13)
	preview_hint.text = "[center]以后这里可以换成真正的衣服贴图\nLater this can use real clothing sprites[/center]"
	preview_box.add_child(preview_hint)
	
	wardrobe_buttons_box = VBoxContainer.new()
	wardrobe_buttons_box.name = "WardrobeButtonsBox"
	wardrobe_buttons_box.position = Vector2(296, 84)
	wardrobe_buttons_box.size = Vector2(240, 330)
	wardrobe_panel.add_child(wardrobe_buttons_box)
	
	for i in range(outfit_data.size()):
		var outfit: Dictionary = outfit_data[i]
		var button: Button = Button.new()
		button.name = "OutfitButton%d" % i
		button.custom_minimum_size = Vector2(240, 44)
		button.text = "%s / %s" % [
			str(outfit.get("zh", "小衣服")),
			str(outfit.get("en", "Outfit"))
		]
		style_button(button, 14, true)
		button.pressed.connect(_on_outfit_button_pressed.bind(i))
		wardrobe_buttons_box.add_child(button)
	
	wardrobe_description = RichTextLabel.new()
	wardrobe_description.name = "WardrobeDescription"
	wardrobe_description.position = Vector2(566, 88)
	wardrobe_description.size = Vector2(238, 292)
	wardrobe_description.bbcode_enabled = true
	wardrobe_description.scroll_active = true
	wardrobe_description.fit_content = false
	wardrobe_description.mouse_filter = Control.MOUSE_FILTER_STOP
	style_rich_text(wardrobe_description, 15)
	wardrobe_panel.add_child(wardrobe_description)
	
	wardrobe_close_button = Button.new()
	wardrobe_close_button.name = "WardrobeCloseButton"
	wardrobe_close_button.position = Vector2(566, 416)
	wardrobe_close_button.size = Vector2(238, 46)
	wardrobe_close_button.text = "关上衣柜 / Close"
	style_button(wardrobe_close_button, 16, true)
	wardrobe_close_button.pressed.connect(close_wardrobe_panel)
	wardrobe_panel.add_child(wardrobe_close_button)


func refresh_wardrobe_panel():
	if wardrobe_panel == null:
		return
	
	var outfit: Dictionary = get_current_outfit()
	
	if wardrobe_title != null:
		wardrobe_title.text = "衣柜：%s / Wardrobe: %s" % [
			str(outfit.get("zh", "小衣服")),
			str(outfit.get("en", "Outfit"))
		]
	
	var preview: Panel = wardrobe_panel.get_node_or_null("WardrobePreviewBox/OutfitColorPreview") as Panel
	if preview != null:
		preview.add_theme_stylebox_override(
			"panel",
			make_panel_style(get_player_outfit_color(), Color("#FFEAF4"), 2, 18)
		)
	
	if wardrobe_description != null:
		wardrobe_description.text = """
[center]
[font_size=22][color=#FFD1E8]%s[/color][/font_size]
[font_size=14][color=#DDDDDD]%s[/color][/font_size]

[color=#FFFFFF]%s[/color]

[color=#CCCCCC]%s[/color]
[/center]
""" % [
			str(outfit.get("zh", "小衣服")),
			str(outfit.get("en", "Outfit")),
			str(outfit.get("desc_zh", "")),
			str(outfit.get("desc_en", ""))
		]


func _on_outfit_button_pressed(index: int):
	if index < 0 or index >= outfit_data.size():
		return
	
	house_state["outfit"] = index
	
	var history: Array = house_state.get("outfit_history", [])
	var outfit: Dictionary = outfit_data[index]
	var outfit_id: String = str(outfit.get("id", "outfit"))
	
	if not history.has(outfit_id):
		history.append(outfit_id)
	
	house_state["outfit_history"] = history
	
	apply_player_outfit()
	save_state()
	refresh_wardrobe_panel()
	close_wardrobe_panel()
	
	show_house_message(
		"换好啦",
		"Outfit changed",
		"她换上了「%s」。\n\n%s" % [
			str(outfit.get("zh", "小衣服")),
			str(outfit.get("desc_zh", ""))
		],
		"She changed into \"%s\".\n\n%s" % [
			str(outfit.get("en", "Outfit")),
			str(outfit.get("desc_en", ""))
		]
	)


func close_wardrobe_panel():
	if wardrobe_panel != null:
		wardrobe_panel.visible = false
	
	if wardrobe_layer != null:
		wardrobe_layer.visible = false
