extends "res://scripts/house_v2/room_base.gd"


func _init():
	title_zh = "客厅"
	title_en = "Living Room"
	spawn_point = Vector2(410, 322)


func build(stage: Control, register_callback: Callable, state: Dictionary) -> void:
	var night: bool = bool(state.get("night", false))

	draw_door(stage, Vector2(30, 226), Vector2(32, 112))
	register_hotspot(register_callback, "door_bedroom", Rect2(30, 226, 32, 112), "去卧室", "Go to bedroom", "switch_room", {"room": "bedroom"})

	draw_door(stage, Vector2(280, 34), Vector2(32, 86))
	register_hotspot(register_callback, "door_kitchen", Rect2(280, 34, 32, 86), "去厨房", "Go to kitchen", "switch_room", {"room": "kitchen"})

	draw_window(stage, Vector2(416, 28), Vector2(102, 64), night)
	register_hotspot(register_callback, "window", Rect2(416, 28, 102, 64), "窗户", "Window", "toggle_night", {})

	draw_door(stage, Vector2(558, 34), Vector2(32, 86))
	register_hotspot(register_callback, "door_bathroom", Rect2(558, 34, 32, 86), "去浴室", "Go to bathroom", "switch_room", {"room": "bathroom"})

	draw_bookshelf(stage, Vector2(654, 54), Vector2(104, 88))
	register_hotspot(register_callback, "bookshelf", Rect2(654, 54, 104, 88), "书架", "Bookshelf", "bookshelf", {})

	draw_sofa(stage, Vector2(92, 194), Vector2(162, 74))
	register_hotspot(register_callback, "sofa", Rect2(92, 194, 162, 74), "沙发", "Sofa", "message", {
		"title_zh": "沙发",
		"title_en": "Sofa",
		"body_zh": "坐下来休息一下。以后这里可以加入一起看电影、聊天、抱着小玩偶休息的小互动。",
		"body_en": "A cozy place to sit and rest. Later this can have little interactions like watching movies, chatting, or resting with a plushie."
	})

	draw_floor_pillow(stage, Vector2(120, 286), Vector2(42, 28), Color("#E8B9C7"))
	draw_floor_pillow(stage, Vector2(178, 290), Vector2(42, 28), Color("#D5E7BE"))

	draw_small_rug(stage, Vector2(300, 260), Vector2(188, 76), Color("#C978A0"), Color("#F3D0E2"))

	draw_table(stage, Vector2(336, 248), Vector2(112, 56))
	register_hotspot(register_callback, "coffee_table", Rect2(336, 248, 112, 56), "茶几", "Coffee Table", "message", {
		"title_zh": "茶几",
		"title_en": "Coffee Table",
		"body_zh": "以后这里可以摆花、小零食、小照片，或者两个人一起看的小东西。",
		"body_en": "Later this table can hold flowers, snacks, tiny photos, or cute little shared things."
	})

	draw_wall_shelf(stage, Vector2(360, 156), Vector2(82, 4))

	draw_tv(stage, Vector2(604, 194), Vector2(112, 72))
	register_hotspot(register_callback, "tv", Rect2(604, 194, 112, 72), "电视", "TV", "message", {
		"title_zh": "电视",
		"title_en": "TV",
		"body_zh": "以后这里可以做成一起看电影的小互动，也可以放你们喜欢的动画或小短片提示。",
		"body_en": "Later this can become a little 'watch together' interaction, with movies, animations, or tiny video prompts."
	})

	draw_chest(stage, Vector2(614, 274), Vector2(82, 32))

	draw_plant(stage, Vector2(530, 262), Vector2(48, 74))
	register_hotspot(register_callback, "plant", Rect2(530, 262, 48, 74), "小植物", "Plant", "plant", {})

	draw_door(stage, Vector2(800, 226), Vector2(32, 112))
	register_hotspot(register_callback, "exit", Rect2(800, 226, 32, 112), "出门", "Exit", "close", {})
