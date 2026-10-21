extends "res://scripts/house_v2/room_base.gd"


func _init():
	title_zh = "浴室"
	title_en = "Bathroom"
	spawn_point = Vector2(410, 322)


func build(stage: Control, register_callback: Callable, state: Dictionary) -> void:
	var night: bool = bool(state.get("night", false))

	draw_window(stage, Vector2(454, 28), Vector2(102, 64), night)
	register_hotspot(register_callback, "window", Rect2(454, 28, 102, 64), "窗户", "Window", "toggle_night", {})

	draw_bathtub(stage, Vector2(70, 184), Vector2(168, 82))
	register_hotspot(register_callback, "bathtub", Rect2(70, 184, 168, 82), "浴缸", "Bathtub", "message", {
		"title_zh": "浴缸",
		"title_en": "Bathtub",
		"body_zh": "疲惫的一天结束后，这里会是很温柔的小角落。以后可以做泡澡放松的小互动。",
		"body_en": "After a tiring day, this would be a gentle little corner. Later it can have a small bath-and-relax interaction."
	})

	draw_mirror(stage, Vector2(316, 54), Vector2(74, 74))
	register_hotspot(register_callback, "mirror", Rect2(316, 54, 74, 74), "镜子", "Mirror", "message", {
		"title_zh": "镜子",
		"title_en": "Mirror",
		"body_zh": "镜子里会看到今天也很可爱的她。",
		"body_en": "The mirror would show that she is cute today too."
	})

	draw_sink(stage, Vector2(318, 186), Vector2(74, 54))
	register_hotspot(register_callback, "sink", Rect2(318, 186, 74, 54), "洗手台", "Sink", "message", {
		"title_zh": "洗手台",
		"title_en": "Sink",
		"body_zh": "小小的洗手台，干净又安静。以后可以放牙刷、毛巾、护肤品。",
		"body_en": "A small clean sink. Later it can hold toothbrushes, towels, and skincare items."
	})

	draw_toilet(stage, Vector2(538, 190), Vector2(66, 84))
	register_hotspot(register_callback, "toilet", Rect2(538, 190, 66, 84), "马桶", "Toilet", "message", {
		"title_zh": "浴室角落",
		"title_en": "Bathroom corner",
		"body_zh": "这是浴室的必要部分。我们不用把它做得太花哨，但它让房子更像真正的家。",
		"body_en": "This is a necessary bathroom corner. It does not need to be fancy, but it makes the house feel more real."
	})

	draw_towel_rack(stage, Vector2(644, 164), Vector2(74, 56))
	register_hotspot(register_callback, "towels", Rect2(644, 164, 74, 56), "毛巾", "Towels", "message", {
		"title_zh": "柔软毛巾",
		"title_en": "Soft towels",
		"body_zh": "干净柔软的小毛巾，让浴室看起来更像一个真正可以生活的小家。",
		"body_en": "Clean soft towels make the bathroom feel more like a real little home."
	})

	draw_bath_mat(stage, Vector2(292, 270), Vector2(188, 64))

	draw_plant(stage, Vector2(646, 260), Vector2(48, 74))
	register_hotspot(register_callback, "plant", Rect2(646, 260, 48, 74), "小植物", "Plant", "plant", {})

	draw_door(stage, Vector2(800, 226), Vector2(32, 112))
	register_hotspot(register_callback, "door_living", Rect2(800, 226, 32, 112), "去客厅", "Go to living room", "switch_room", {"room": "living"})
