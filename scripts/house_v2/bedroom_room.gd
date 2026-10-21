extends "res://scripts/house_v2/room_base.gd"


func _init():
	title_zh = "卧室"
	title_en = "Bedroom"
	spawn_point = Vector2(430, 350)


func build(stage: Control, register_callback: Callable, state: Dictionary) -> void:
	var night: bool = bool(state.get("night", false))

	draw_string_lights(stage, Vector2(292, 24), 5)

	draw_bed(stage, Vector2(46, 160), Vector2(150, 108))
	register_hotspot(register_callback, "bed", Rect2(34, 144, 178, 132), "床", "Bed", "sleep", {})

	draw_nightstand(stage, Vector2(205, 176), Vector2(46, 58))
	register_hotspot(register_callback, "nightstand", Rect2(205, 176, 46, 58), "床头柜", "Nightstand", "message", {
		"title_zh": "床头柜",
		"title_en": "Nightstand",
		"body_zh": "小小的床头柜上放着一盏温暖的灯。以后这里可以藏晚安留言、药盒、护手霜，或者每天一句小情话。",
		"body_en": "A tiny nightstand with a warm lamp. Later it can hide goodnight notes, care items, or one small love line every day."
	})

	draw_photo_wall(stage, Vector2(292, 24), Vector2(106, 54))
	register_hotspot(register_callback, "photo_wall", Rect2(250, 12, 190, 128), "照片墙", "Photo Wall", "photo_wall", {})

	draw_window(stage, Vector2(430, 34), Vector2(104, 70), night)
	register_hotspot(register_callback, "window", Rect2(430, 34, 104, 70), "窗户", "Window", "toggle_night", {})

	draw_bookshelf(stage, Vector2(606, 56), Vector2(112, 112))
	register_hotspot(register_callback, "bookshelf", Rect2(606, 56, 112, 112), "书架", "Bookshelf", "bookshelf", {})

	draw_bedroom_vanity(stage, Vector2(286, 172), Vector2(112, 62))
	register_hotspot(register_callback, "vanity", Rect2(292, 145, 112, 92), "梳妆台", "Vanity", "message", {
		"title_zh": "小梳妆台",
		"title_en": "Little vanity",
		"body_zh": "这里以后可以放发夹、香水、护肤品和她的小饰品，让房间更像她自己的小世界。",
		"body_en": "Later this can hold hair clips, perfume, skincare, and tiny accessories, making the room feel like her own little world."
	})

	draw_desk(stage, Vector2(420, 180), Vector2(150, 72))
	register_hotspot(register_callback, "desk", Rect2(420, 180, 150, 72), "学习桌", "Desk", "message", {
		"title_zh": "学习桌",
		"title_en": "Study Desk",
		"body_zh": "这里以后可以做成一个小小的语言学习角：法语、英语、鼓励语、每日一句，还有你想对她说的“今天也很棒”。",
		"body_en": "This can become a tiny language-learning corner: French, English, encouragement, daily phrases, and a little 'you did well today' from you."
	})

	draw_diary(stage, Vector2(485, 190))
	register_hotspot(register_callback, "diary", Rect2(476, 184, 48, 38), "日记本", "Diary", "diary", {})

	draw_small_rug(stage, Vector2(282, 278), Vector2(220, 88), Color("#D96EA5"), Color("#F9D7E8"))

	draw_plushie(stage, Vector2(112, 300))
	register_hotspot(register_callback, "plushie", Rect2(112, 300, 62, 58), "小玩偶", "Plushie", "plushie", {})

	draw_chest(stage, Vector2(540, 296), Vector2(58, 46))
	register_hotspot(register_callback, "decor_chest", Rect2(540, 296, 58, 46), "装饰箱", "Decor Chest", "theme", {})

	draw_plant(stage, Vector2(610, 282), Vector2(52, 78))
	register_hotspot(register_callback, "plant", Rect2(610, 282, 52, 78), "小植物", "Plant", "plant", {})

	draw_wardrobe(stage, Vector2(666, 246), Vector2(92, 118))
	register_hotspot(register_callback, "wardrobe", Rect2(666, 246, 92, 118), "衣柜", "Wardrobe", "wardrobe", {})

	draw_door(stage, Vector2(766, 238), Vector2(40, 128), "客厅 / Living")
	register_hotspot(register_callback, "door_living", Rect2(766, 238, 40, 128), "去客厅", "Go to living room", "switch_room", {
		"room": "living"
	})
