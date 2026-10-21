extends Control

@onready var room_button = get_node_or_null("MenuBox/RoomButton")
@onready var garden_button = get_node_or_null("MenuBox/GardenButton")
@onready var mailbox_button = get_node_or_null("MenuBox/MailboxButton")
@onready var chest_button = get_node_or_null("MenuBox/ChestButton")
@onready var constellation_button = get_node_or_null("MenuBox/ConstellationButton")

@onready var coming_soon_panel = get_node_or_null("ComingSoonPanel")
@onready var note_text = get_node_or_null("ComingSoonPanel/NoteText")
@onready var close_button = get_node_or_null("ComingSoonPanel/CloseButton")


func _ready():
	print("=== MAIN MENU READY ===")
	print("Script is running on node: ", name)
	
	print("Room button: ", room_button)
	print("Garden button: ", garden_button)
	print("Mailbox button: ", mailbox_button)
	print("Chest button: ", chest_button)
	print("Constellation button: ", constellation_button)
	print("ComingSoonPanel: ", coming_soon_panel)
	print("NoteText: ", note_text)
	print("CloseButton: ", close_button)
	
	if coming_soon_panel != null:
		coming_soon_panel.visible = false
	
	if room_button != null:
		room_button.pressed.connect(_on_room_pressed)
	if garden_button != null:
		garden_button.pressed.connect(_on_garden_pressed)
	if mailbox_button != null:
		mailbox_button.pressed.connect(_on_mailbox_pressed)
	if chest_button != null:
		chest_button.pressed.connect(_on_chest_pressed)
	if constellation_button != null:
		constellation_button.pressed.connect(_on_constellation_pressed)
	if close_button != null:
		close_button.pressed.connect(_on_close_pressed)


func _on_room_pressed():
	get_tree().change_scene_to_file("res://scenes/RoomGame.tscn")

func _on_garden_pressed():
	get_tree().change_scene_to_file("res://scenes/LoveGarden.tscn")

func _on_mailbox_pressed():
	print("MAILBOX BUTTON PRESSED")
	get_tree().change_scene_to_file("res://scenes/MailboxGame.tscn")


func _on_chest_pressed():
	print("CHEST BUTTON PRESSED")
	show_coming_soon("记忆宝箱", "Memory Chest")


func _on_constellation_pressed():
	print("CONSTELLATION BUTTON PRESSED")
	show_coming_soon("星星相册", "Photo Constellation")


func _on_close_pressed():
	print("CLOSE BUTTON PRESSED")
	if coming_soon_panel != null:
		coming_soon_panel.visible = false


func show_coming_soon(chinese_name: String, english_name: String):
	print("SHOW COMING SOON CALLED")
	
	if coming_soon_panel == null:
		push_error("ComingSoonPanel is null")
		return
	
	if note_text == null:
		push_error("NoteText is null")
		return
	
	coming_soon_panel.visible = true
	coming_soon_panel.z_index = 100
	
	# Force the popup to be visible and centered.
	coming_soon_panel.position = Vector2(290, 180)
	coming_soon_panel.size = Vector2(580, 280)
	coming_soon_panel.custom_minimum_size = Vector2(580, 280)
	
	note_text.visible = true
	note_text.position = Vector2(25, 25)
	note_text.size = Vector2(530, 180)
	note_text.custom_minimum_size = Vector2(530, 180)
	note_text.text = """
[center]
[font_size=24][color=#C71585]%s 还在慢慢准备中。[/color][/font_size]

[font_size=16][color=#777777]%s is still being prepared with love.[/color][/font_size]

[font_size=20][color=#C71585]先去打开信箱吧，那里已经有几封小信在等你。[/color][/font_size]

[font_size=15][color=#888888]For now, open the mailbox first. There are already a few little letters waiting for you.[/color][/font_size]
[/center]
""" % [chinese_name, english_name]
	
	print("Panel visible: ", coming_soon_panel.visible)
	print("Panel position: ", coming_soon_panel.position)
	print("Panel size: ", coming_soon_panel.size)
