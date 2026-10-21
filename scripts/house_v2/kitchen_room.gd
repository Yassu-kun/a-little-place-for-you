extends "res://scripts/house_v2/room_base.gd"


func _init():
	title_zh = "厨房"
	title_en = "Kitchen"
	spawn_point = Vector2(410, 322)


func build(stage: Control, register_callback: Callable, state: Dictionary) -> void:
	var night: bool = bool(state.get("night", false))

	draw_window(stage, Vector2(454, 28), Vector2(102, 64), night)
	register_hotspot(register_callback, "window", Rect2(454, 28, 102, 64), "窗户", "Window", "toggle_night", {})

	draw_fridge(stage, Vector2(66, 162), Vector2(70, 124))
	register_hotspot(register_callback, "fridge", Rect2(66, 162, 70, 124), "冰箱", "Fridge", "message", {
		"title_zh": "冰箱",
		"title_en": "Fridge",
		"body_zh": "以后可以在这里放小食物、甜点、便当和彩蛋留言。",
		"body_en": "Later this can store little food items, desserts, lunch boxes, and secret notes."
	})

	draw_counter(stage, Vector2(178, 162), Vector2(214, 64))
	register_hotspot(register_callback, "counter", Rect2(178, 162, 214, 64), "料理台", "Counter", "message", {
		"title_zh": "料理台",
		"title_en": "Counter",
		"body_zh": "一个准备食物的小角落。以后这里可以做成简单料理小游戏。",
		"body_en": "A little place to prepare food. Later this can become a simple cooking mini-game."
	})

	draw_wall_shelf(stage, Vector2(238, 132), Vector2(86, 4))
	draw_tiny_kitchen_stuff(stage, Vector2(436, 174))
	draw_chest(stage, Vector2(500, 166), Vector2(74, 40))

	draw_small_rug(stage, Vector2(306, 270), Vector2(184, 70), Color("#D59A7B"), Color("#F2D4C2"))

	draw_table(stage, Vector2(336, 258), Vector2(126, 60))
	register_hotspot(register_callback, "dining_table", Rect2(336, 258, 126, 60), "餐桌", "Dining Table", "message", {
		"title_zh": "餐桌",
		"title_en": "Dining Table",
		"body_zh": "以后这里可以做成一起吃饭、约会、留言的地方。",
		"body_en": "Later this can become a place for eating together, little dates, and notes."
	})

	draw_floor_pillow(stage, Vector2(292, 284), Vector2(34, 26), Color("#E9C0A7"))
	draw_floor_pillow(stage, Vector2(472, 284), Vector2(34, 26), Color("#E9C0A7"))

	draw_plant(stage, Vector2(634, 260), Vector2(48, 74))
	register_hotspot(register_callback, "plant", Rect2(634, 260, 48, 74), "小植物", "Plant", "plant", {})

	draw_door(stage, Vector2(800, 226), Vector2(32, 112))
	register_hotspot(register_callback, "door_living", Rect2(800, 226, 32, 112), "去客厅", "Go to living room", "switch_room", {"room": "living"})
