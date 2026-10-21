extends Control

# ============================================================
# ROOM GAME / POINT-AND-CLICK HUB
# Clean UI version:
# - No giant title rectangle
# - No scrollbars on title/progress
# - Progress panel properly contains text
# - Final button placed cleanly
# - Room starts normal, hotspot glows only on hover
# ============================================================

const DEBUG_SHOW_ALL_HOTSPOTS := false

const NORMAL_COLOR := Color(1.0, 0.35, 0.68, 0.22)
const HOVER_COLOR := Color(1.0, 0.18, 0.55, 0.55)
const CLICK_COLOR := Color(1.0, 0.75, 0.90, 0.65)
const HIDDEN_COLOR := Color(1, 1, 1, 0.0)

@onready var background_color = get_node_or_null("BackgroundColor")
@onready var room_image = get_node_or_null("RoomImage")
@onready var overlay = get_node_or_null("Overlay")

@onready var photo_wall_area = get_node_or_null("Hotspots/PhotoWallHotspot")
@onready var bookshelf_area = get_node_or_null("Hotspots/BookshelfHotspot")
@onready var bed_area = get_node_or_null("Hotspots/BedHotspot")
@onready var window_area = get_node_or_null("Hotspots/WindowHotspot")
@onready var desk_area = get_node_or_null("Hotspots/DeskHotspot")
@onready var monitor_area = get_node_or_null("Hotspots/MonitorHotspot")
@onready var lamp_area = get_node_or_null("Hotspots/LampHotspot")
@onready var suitcase_area = get_node_or_null("Hotspots/SuitcaseHotspot")

@onready var title_panel = get_node_or_null("Overlay/TitlePanel")
@onready var title_text = get_node_or_null("Overlay/TitleText")

@onready var hover_panel = get_node_or_null("Overlay/HoverPanel")
@onready var hover_label = get_node_or_null("Overlay/HoverLabel")

@onready var progress_panel = get_node_or_null("Overlay/ProgressPanel")
@onready var progress_text = get_node_or_null("Overlay/ProgressText")

@onready var final_secret_button = get_node_or_null("Overlay/FinalSecretButton")
@onready var back_button = get_node_or_null("Overlay/BackButton")

@onready var popup_panel = get_node_or_null("PopupPanel")
@onready var popup_message = get_node_or_null("PopupPanel/PopupBox/PopupMessage")
@onready var close_popup_button = get_node_or_null("PopupPanel/PopupBox/ClosePopupButton")

var discovered_count := 0
var discovered := {}
var areas := {}
var current_hover_id := ""

var hotspot_order := [
	"monitor",
	"lamp",
	"desk",
	"photo_wall",
	"bookshelf",
	"bed",
	"window",
	"suitcase"
]

var hotspot_data := {
	"photo_wall": {
		"label": "照片墙 / Photo Wall",
		"scene_path": "res://scenes/PhotoWallScene.tscn",
		"title_zh": "照片墙",
		"title_en": "Photo Wall",
		"zh": "这里以后会放我们的照片，还有每一张照片旁边的一点点小话。不是很正式的介绍，而是一些只有我们自己懂的小备注、小回忆、小温柔。以后你点开这里，就可以像翻一面属于我们的墙一样，慢慢看见我们走过的地方。",
		"en": "Later, this wall can hold our pictures, with a few little words beside each one. Not formal descriptions, but tiny notes, memories, and bits of tenderness that only really belong to us. When you open it later, it can feel like looking through a wall made of our own little moments."
	},
	"bookshelf": {
		"label": "书架 / Bookshelf",
		"scene_path": "res://scenes/BookshelfScene.tscn",
		"title_zh": "书架",
		"title_en": "Bookshelf",
		"zh": "这里以后会放书、漫画、游戏，还有一些你点开之后会跳出来的小惊喜。它会像一个安安静静的小角落，慢慢装满我们喜欢的东西，也装满一点点我想和你分享的世界。",
		"en": "Later, this shelf can hold books, manga, games, and little surprises hidden behind them. It can become a quiet corner slowly filled with things we like, and with little pieces of the world I want to share with you."
	},
	"bed": {
		"label": "床 / Bed",
		"scene_path": "res://scenes/BedScene.tscn",
		"title_zh": "床",
		"title_en": "Bed",
		"zh": "这里以后会进入夜晚模式。房间会暗下来，床边会有小玩偶、小信、也许还有一盏很轻的小灯。它会像一个可以安心缩进被子里的地方，好像你不用说很多话，也能被温柔地抱着。",
		"en": "Later, this will enter a night mode. The room will become darker, with little plushies, letters, and maybe a soft tiny light near the bed. It can feel like a place where you can safely hide under the blanket and be gently held without needing to say much."
	},
	"window": {
		"label": "窗户 / Window",
		"scene_path": "res://scenes/WindowScene.tscn",
		"title_zh": "窗户",
		"title_en": "Window",
		"zh": "这里以后会让你看到窗外的风景：湖、水边的小城、带一点中国乡间感觉的安静景色。也许会有风、云、灯光、或者一点点小事件。像是我陪你一起坐在窗边，看外面的世界慢慢变亮。",
		"en": "Later, this can let you look outside at a lake view, a quiet town, and scenery with a soft countryside feeling from China. Maybe there can be wind, clouds, lights, or tiny events. Like I am sitting beside you near the window, watching the outside world slowly brighten with you."
	},
	"desk": {
		"label": "书桌 / Desk",
		"scene_path": "res://scenes/StudyDeskScene.tscn",
		"title_zh": "书桌",
		"title_en": "Desk",
		"zh": "这里以后会进入学习模式。你可以选择英语或者法语，然后周围会出现一些鼓励你的小话、温柔的提醒、还有我很偏心的夸奖。努力也可以变得不那么孤单，因为我想陪你一点一点进步。",
		"en": "Later, this can become a study mode. You’ll be able to choose English or French, and the desk can fill with little encouragements, gentle reminders, and very biased praise from me. Studying does not have to feel lonely, because I want to accompany you while you grow little by little."
	},
	"monitor": {
		"label": "电脑 / Monitor",
		"scene_path": "res://scenes/MonitorScene.tscn",
		"title_zh": "电脑",
		"title_en": "Monitor",
		"zh": "这里以后会打开一个小游戏。可以先放一个很简单的小游戏，之后再慢慢变成房间里的小娱乐角。也许里面会藏一些只有你点进去才会发现的东西。",
		"en": "Later, this can open a small mini-game. We can start with something simple, then slowly turn it into the entertainment corner of the room. Maybe it can hide little things that only appear when you enter it."
	},
	"lamp": {
		"label": "小灯 / Lamp",
		"scene_path": "",
		"title_zh": "小灯",
		"title_en": "Lamp",
		"zh": "这盏灯像是房间里最轻的一点温柔。以后它可以和夜晚模式连在一起，也可以在你点它的时候，偷偷亮起一句安慰你的话。像是在说：别怕，我一直在。",
		"en": "This lamp feels like the softest bit of tenderness in the room. Later it can connect to the night mode, or quietly light up a comforting line when you click it. Almost like it is saying: do not be afraid, I am here."
	},
	"suitcase": {
		"label": "行李箱 / Suitcase",
		"scene_path": "",
		"title_zh": "行李箱",
		"title_en": "Suitcase",
		"zh": "这个行李箱里以后可以装我们想去的地方、一起想做的事、还有一些关于未来旅行的小愿望。它像一个还没有完全打开的未来，里面放着很多还没来得及发生的我们。",
		"en": "Later, this suitcase can hold places we want to go, things we want to do together, and little wishes about future trips. It feels like a future that has not been fully opened yet, filled with many versions of us that have not happened yet."
	},
	"final": {
		"title_zh": "房间里的最后秘密",
		"title_en": "The Final Secret in the Room",
		"zh": "你已经把这个房间里的每个小角落都点过啦。最后的秘密是：这个房间不是为了让你“玩完”，而是为了让你知道，只要你愿意停下来看看，就会在不同的地方找到我想留给你的温柔。以后这里还会慢慢长出更多东西，像一个一点点为你搭起来的小世界。",
		"en": "You have clicked every little corner in this room now. The final secret is: this room was not made just for you to ‘finish’ it. It was made so that whenever you slow down and look around, you can find little pieces of tenderness I wanted to leave for you. Later, it can keep growing into a small world built little by little for you."
	}
}

func _ready():
	prepare_layers()
	prepare_ui()
	prepare_areas()
	update_progress()

func prepare_layers():
	if background_color != null:
		background_color.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if room_image != null:
		room_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if overlay != null:
		overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		overlay.z_index = 100
	
	if popup_panel != null:
		popup_panel.mouse_filter = Control.MOUSE_FILTER_STOP
		popup_panel.z_index = 300

func prepare_ui():
	setup_title()
	setup_progress()
	setup_hover()
	setup_buttons()
	setup_popup()

func setup_title():
	if title_panel != null:
		title_panel.visible = true
		title_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		title_panel.z_index = 110
		title_panel.position = Vector2(456, 14)
		title_panel.size = Vector2(240, 44)
	
	if title_text != null:
		title_text.visible = true
		title_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
		title_text.z_index = 111
		title_text.position = Vector2(468, 21)
		title_text.size = Vector2(216, 28)
		title_text.bbcode_enabled = true
		title_text.scroll_active = false
		title_text.fit_content = false
		title_text.clip_contents = true
		title_text.text = "[center][font_size=18][color=#FFFFFF]Our Little Room[/color][/font_size][/center]"

func setup_progress():
	if progress_panel != null:
		progress_panel.visible = true
		progress_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		progress_panel.z_index = 110
		progress_panel.position = Vector2(356, 584)
		progress_panel.size = Vector2(440, 54)
	
	if progress_text != null:
		progress_text.visible = true
		progress_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
		progress_text.z_index = 111
		progress_text.position = Vector2(368, 591)
		progress_text.size = Vector2(416, 40)
		progress_text.bbcode_enabled = true
		progress_text.scroll_active = false
		progress_text.fit_content = false
		progress_text.clip_contents = true

func setup_hover():
	if hover_panel != null:
		hover_panel.visible = false
		hover_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hover_panel.z_index = 200
		hover_panel.size = Vector2(220, 36)
	
	if hover_label != null:
		hover_label.visible = false
		hover_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hover_label.z_index = 201
		hover_label.text = ""
		hover_label.size = Vector2(200, 28)
		hover_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		hover_label.add_theme_color_override("font_outline_color", Color(0.15, 0.05, 0.1, 0.95))
		hover_label.add_theme_constant_override("outline_size", 4)
		hover_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hover_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func setup_buttons():
	if back_button != null:
		back_button.visible = true
		back_button.z_index = 220
		back_button.text = "返回主菜单 / Back to Menu"
		back_button.position = Vector2(22, 22)
		back_button.size = Vector2(210, 42)
		back_button.pressed.connect(go_back)
	
	if final_secret_button != null:
		final_secret_button.visible = false
		final_secret_button.disabled = true
		final_secret_button.z_index = 220
		final_secret_button.text = "打开房间里的最后秘密 / Open the final secret"
		final_secret_button.position = Vector2(394, 522)
		final_secret_button.size = Vector2(365, 42)
		final_secret_button.pressed.connect(open_final_secret)
	
	if close_popup_button != null:
		close_popup_button.text = "收好这一点温柔 / Keep this little softness"
		close_popup_button.pressed.connect(close_popup)

func setup_popup():
	if popup_panel != null:
		popup_panel.visible = false
		popup_panel.z_index = 300

func prepare_areas():
	areas = {
		"photo_wall": photo_wall_area,
		"bookshelf": bookshelf_area,
		"bed": bed_area,
		"window": window_area,
		"desk": desk_area,
		"monitor": monitor_area,
		"lamp": lamp_area,
		"suitcase": suitcase_area
	}
	
	for id in areas.keys():
		discovered[id] = false
		setup_area(id)

func setup_area(id: String):
	var area = areas[id]
	
	if area == null:
		push_error("Missing hotspot node for id: " + id + ". Expected: Hotspots/" + get_expected_node_name(id))
		return
	
	if not (area is Area2D):
		push_error("Hotspot node for id " + id + " is not Area2D.")
		return
	
	area.input_pickable = true
	area.z_index = 10
	
	var collision_polygon = get_collision_polygon(area)
	if collision_polygon == null:
		push_error("No CollisionPolygon2D found inside " + area.name + ".")
		return
	
	if collision_polygon.polygon.size() < 3:
		push_warning(area.name + " has no valid collision polygon yet. Draw at least 3 points.")
	
	sync_visual_polygon_with_collision(area)
	
	if DEBUG_SHOW_ALL_HOTSPOTS:
		set_area_visual_color(id, NORMAL_COLOR)
		set_area_visual_visible(id, true)
	else:
		set_area_visual_color(id, HIDDEN_COLOR)
		set_area_visual_visible(id, false)

func _process(delta):
	if popup_panel != null and popup_panel.visible:
		clear_hover()
		return
	
	var hovered_id: String = get_hotspot_under_mouse()
	
	if hovered_id != current_hover_id:
		if current_hover_id != "":
			on_area_exited(current_hover_id)
		
		current_hover_id = hovered_id
		
		if current_hover_id != "":
			on_area_entered(current_hover_id)
	
	update_hover_label_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if is_mouse_over_control(back_button):
				return
			
			if final_secret_button != null and final_secret_button.visible:
				if is_mouse_over_control(final_secret_button):
					return
			
			if popup_panel != null and popup_panel.visible:
				return
			
			var clicked_id: String = get_hotspot_under_mouse()
			
			if clicked_id != "":
				on_hotspot_pressed(clicked_id)

func get_hotspot_under_mouse() -> String:
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	for id in hotspot_order:
		if is_mouse_inside_hotspot(id, mouse_pos):
			return id
	
	return ""

func is_mouse_inside_hotspot(id: String, mouse_pos: Vector2) -> bool:
	if not areas.has(id):
		return false
	
	var area = areas[id]
	if area == null or not (area is Area2D):
		return false
	
	var collision_polygon = get_collision_polygon(area)
	if collision_polygon == null:
		return false
	
	if collision_polygon.polygon.size() < 3:
		return false
	
	var local_mouse: Vector2 = area.to_local(mouse_pos)
	return Geometry2D.is_point_in_polygon(local_mouse, collision_polygon.polygon)

func is_mouse_over_control(control_node) -> bool:
	if control_node == null:
		return false
	
	if not (control_node is Control):
		return false
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	return control_node.get_global_rect().has_point(mouse_pos)

func on_area_entered(id: String):
	if hover_panel != null:
		hover_panel.visible = true
	
	if hover_label != null:
		hover_label.visible = true
		hover_label.text = hotspot_data[id]["label"]
	
	set_area_visual_color(id, HOVER_COLOR)
	set_area_visual_visible(id, true)

func on_area_exited(id: String):
	if hover_panel != null:
		hover_panel.visible = false
	
	if hover_label != null:
		hover_label.visible = false
	
	if DEBUG_SHOW_ALL_HOTSPOTS:
		set_area_visual_color(id, NORMAL_COLOR)
		set_area_visual_visible(id, true)
	else:
		set_area_visual_color(id, HIDDEN_COLOR)
		set_area_visual_visible(id, false)

func clear_hover():
	if current_hover_id != "":
		on_area_exited(current_hover_id)
		current_hover_id = ""
	
	if hover_panel != null:
		hover_panel.visible = false
	
	if hover_label != null:
		hover_label.visible = false

func update_hover_label_position():
	if hover_label == null or hover_panel == null:
		return
	
	if not hover_label.visible:
		return
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	var viewport_size: Vector2 = get_viewport_rect().size
	
	var panel_size: Vector2 = Vector2(220, 36)
	var panel_pos: Vector2 = mouse_pos + Vector2(18, -42)
	
	panel_pos.x = clamp(panel_pos.x, 12.0, viewport_size.x - panel_size.x - 12.0)
	panel_pos.y = clamp(panel_pos.y, 12.0, viewport_size.y - panel_size.y - 12.0)
	
	hover_panel.global_position = panel_pos
	hover_panel.size = panel_size
	
	hover_label.global_position = panel_pos + Vector2(10, 4)
	hover_label.size = Vector2(200, 28)

func on_hotspot_pressed(id: String):
	set_area_visual_color(id, CLICK_COLOR)
	set_area_visual_visible(id, true)
	
	if discovered[id] == false:
		discovered[id] = true
		discovered_count += 1
		update_progress()
		
		if discovered_count == count_valid_areas():
			if final_secret_button != null:
				final_secret_button.visible = true
				final_secret_button.disabled = false
	
	var scene_path: String = hotspot_data[id]["scene_path"]
	
	if scene_path != "" and ResourceLoader.exists(scene_path):
		get_tree().change_scene_to_file(scene_path)
	else:
		show_hotspot_popup(id)

func show_hotspot_popup(id: String):
	if popup_panel == null or popup_message == null:
		push_error("PopupPanel or PopupMessage is missing.")
		return
	
	clear_hover()
	
	var data = hotspot_data[id]
	popup_panel.visible = true
	popup_message.text = make_message_markup(
		data["title_zh"],
		data["title_en"],
		data["zh"],
		data["en"]
	)

func open_final_secret():
	if popup_panel == null or popup_message == null:
		return
	
	clear_hover()
	
	var data = hotspot_data["final"]
	popup_panel.visible = true
	popup_message.text = make_message_markup(
		data["title_zh"],
		data["title_en"],
		data["zh"],
		data["en"]
	)

func close_popup():
	if popup_panel != null:
		popup_panel.visible = false

func get_collision_polygon(area: Area2D) -> CollisionPolygon2D:
	for child in area.get_children():
		if child is CollisionPolygon2D:
			return child
	return null

func get_visual_polygon(area: Area2D) -> Polygon2D:
	for child in area.get_children():
		if child is Polygon2D:
			return child
	return null

func sync_visual_polygon_with_collision(area: Area2D):
	var collision_polygon = get_collision_polygon(area)
	var visual_polygon = get_visual_polygon(area)
	
	if collision_polygon == null or visual_polygon == null:
		return
	
	if visual_polygon.polygon.size() < 3:
		visual_polygon.polygon = collision_polygon.polygon
	
	visual_polygon.z_index = 20

func set_area_visual_color(id: String, color: Color):
	if not areas.has(id):
		return
	
	var area = areas[id]
	if area == null:
		return
	
	var visual = get_visual_polygon(area)
	if visual != null:
		visual.color = color

func set_area_visual_visible(id: String, visible_value: bool):
	if not areas.has(id):
		return
	
	var area = areas[id]
	if area == null:
		return
	
	var visual = get_visual_polygon(area)
	if visual != null:
		visual.visible = visible_value

func count_valid_areas() -> int:
	var count := 0
	
	for id in areas.keys():
		if areas[id] != null and areas[id] is Area2D:
			var collision_polygon = get_collision_polygon(areas[id])
			if collision_polygon != null and collision_polygon.polygon.size() >= 3:
				count += 1
	
	return count

func update_progress():
	if progress_text == null:
		return
	
	var total: int = count_valid_areas()
	
	if total == 0:
		progress_text.text = "[center][font_size=15][color=#FFFFFF]还没有可点击区域。[/color][/font_size]\n[font_size=12][color=#DDDDDD]No clickable areas are ready yet.[/color][/font_size][/center]"
		return
	
	if discovered_count < total:
		progress_text.text = "[center][font_size=15][color=#FFFFFF]你已经发现了 %d / %d 个区域。[/color][/font_size]\n[font_size=12][color=#DDDDDD]You have discovered %d / %d areas.[/color][/font_size][/center]" % [discovered_count, total, discovered_count, total]
	else:
		progress_text.text = "[center][font_size=15][color=#FFFFFF]你已经发现了所有区域，最后的秘密出现啦。[/color][/font_size]\n[font_size=12][color=#DDDDDD]You discovered every area, and the final secret has appeared.[/color][/font_size][/center]"

func make_message_markup(title_zh: String, title_en: String, body_zh: String, body_en: String) -> String:
	return """
[center]
[font_size=28][color=#D14D8B]%s[/color][/font_size]
[font_size=15][color=#8A8A8A]%s[/color][/font_size]

[font_size=22][color=#A64D79]%s[/color][/font_size]

[font_size=15][color=#7A7A7A]%s[/color][/font_size]
[/center]
""" % [title_zh, title_en, body_zh, body_en]

func go_back():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func get_expected_node_name(id: String) -> String:
	match id:
		"photo_wall":
			return "PhotoWallHotspot"
		"bookshelf":
			return "BookshelfHotspot"
		"bed":
			return "BedHotspot"
		"window":
			return "WindowHotspot"
		"desk":
			return "DeskHotspot"
		"monitor":
			return "MonitorHotspot"
		"lamp":
			return "LampHotspot"
		"suitcase":
			return "SuitcaseHotspot"
		_:
			return "UnknownHotspot"
