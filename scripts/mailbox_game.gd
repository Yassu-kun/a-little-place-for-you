extends Control

@onready var envelope_1 = $MainPanel/ContentBox/EnvelopeBox/Envelope1
@onready var envelope_2 = $MainPanel/ContentBox/EnvelopeBox/Envelope2
@onready var envelope_3 = $MainPanel/ContentBox/EnvelopeBox/Envelope3
@onready var envelope_4 = $MainPanel/ContentBox/EnvelopeBox/Envelope4
@onready var envelope_5 = $MainPanel/ContentBox/EnvelopeBox/Envelope5
@onready var final_button = $MainPanel/ContentBox/EnvelopeBox/FinalLetterButton

@onready var progress_text = $MainPanel/ContentBox/ProgressText
@onready var back_button = $MainPanel/ContentBox/BackButton

@onready var popup_panel = $PopupPanel
@onready var popup_message = $PopupPanel/PopupBox/PopupMessage
@onready var close_popup_button = $PopupPanel/PopupBox/ClosePopupButton


var opened_count := 0

var opened := {
	"miss": false,
	"tired": false,
	"kiss": false,
	"smile": false,
	"courage": false
}

var letters := {
	"miss": {
		"title_zh": "想我的时候打开",
		"title_en": "Open when you miss me",
		"zh": "如果你点开这封信的时候正在想我，那我想先轻轻抱抱你。虽然现在我可能不在你身边，可是我还是想给你留一个小地方，让你一打开，就像有一点点我在靠近你。这个小信箱，就是我偷偷放给你的一个拥抱。",
		"en": "If you opened this because you miss me, then the first thing I want to do is give you a soft hug. Even if I’m not physically beside you right now, I still wanted to leave you a tiny place you could open and feel a little closer to me. This little mailbox is my quiet hug for you."
	},
	"tired": {
		"title_zh": "累的时候打开",
		"title_en": "Open when you feel tired",
		"zh": "如果你今天很累，那你不用急着变得坚强，也不用逼自己马上振作起来。你可以先慢慢休息一下，慢慢呼吸一下，慢慢把紧绷的心放松一点。你已经很努力了，我真的很心疼你，也真的很为你骄傲。",
		"en": "If you are tired today, you do not need to rush into being strong, and you do not need to force yourself to recover immediately. You can rest slowly, breathe slowly, and let your tense little heart loosen a bit. You have already been trying so hard, and I truly feel for you, and I’m truly proud of you."
	},
	"kiss": {
		"title_zh": "想要亲亲的时候打开",
		"title_en": "Open when you need a kiss",
		"zh": "如果你现在很想要亲亲，那就把这封信当成我送过来的一个小亲亲吧。先亲一下你的额头，再亲一下你的脸，然后再很认真、很温柔地亲你一下。你是我会想认真捧在手心里的宝宝，所以我想把今天的亲亲也留在这里给你。",
		"en": "If you really want a kiss right now, then let this letter be a tiny kiss sent from me. First a kiss on your forehead, then a kiss on your cheek, and then one very gentle, very sincere kiss just for you. You are someone I want to hold very carefully in my hands, so I wanted to leave today’s kiss here for you too."
	},
	"smile": {
		"title_zh": "想笑一下的时候打开",
		"title_en": "Open when you want to smile",
		"zh": "如果你现在想笑一下，那你就想象我坐在电脑前，一边认真做这个小东西，一边担心你会不会觉得我太傻，结果又忍不住偷偷期待你会喜欢。其实只要你看到这里的时候轻轻笑一下，我就会觉得这些时间花得特别值得。",
		"en": "If you want a little smile right now, then imagine me sitting at my computer, making this little thing seriously, while worrying that maybe I’m being too silly, and at the same time secretly hoping that you’ll like it. Honestly, if you smile even a little when reading this, I’ll already feel all the time spent was absolutely worth it."
	},
	"courage": {
		"title_zh": "需要勇气的时候打开",
		"title_en": "Open when you need courage",
		"zh": "如果你现在需要一点勇气，那我想认真告诉你：你比你自己想象的更勇敢，也比你自己想象的更珍贵。你不需要一下子做到完美，你只要一步一步往前走就已经很了不起了。我会一直站在你这一边，很偏心地爱你，很坚定地相信你。",
		"en": "If you need a little courage right now, I want to tell you something sincerely: you are braver than you think, and more precious than you realize. You do not need to become perfect all at once. Just moving forward step by step is already something beautiful. I will always stand on your side, love you very unfairly, and believe in you very firmly."
	},
	"final": {
		"title_zh": "最后一封特别的信",
		"title_en": "The Final Special Letter",
		"zh": "你已经把前面的每一封小信都打开啦，所以这封是专门给你的最后奖励。其实我做这个小世界，不只是因为它可爱，也不只是因为我想做一个礼物。我更想给你一个地方——一个当你想我、累了、想被安慰、或者只是想点开看看时，就能找到一点温柔的小地方。只要你愿意，这里就会一直安安静静地等着你。",
		"en": "You opened every little letter before this one, so this is your final special reward. I did not make this little world only because it is cute, and not only because I wanted to make you a gift. I made it because I wanted to give you a place — a place you could open whenever you miss me, feel tired, want comfort, or simply want to click somewhere warm and gentle. As long as you want, this little place will quietly wait for you."
	}
}


func _ready():
	popup_panel.visible = false
	
	final_button.visible = false
	final_button.disabled = true
	
	envelope_1.text = "想我的时候打开 / Open when you miss me"
	envelope_2.text = "累的时候打开 / Open when you feel tired"
	envelope_3.text = "想要亲亲的时候打开 / Open when you need a kiss"
	envelope_4.text = "想笑一下的时候打开 / Open when you want to smile"
	envelope_5.text = "需要勇气的时候打开 / Open when you need courage"
	final_button.text = "最后一封特别的信 / The Final Special Letter"
	
	back_button.text = "返回主菜单 / Back to Menu"
	close_popup_button.text = "收好这封信 / Keep this letter"
	
	envelope_1.pressed.connect(func(): open_letter("miss"))
	envelope_2.pressed.connect(func(): open_letter("tired"))
	envelope_3.pressed.connect(func(): open_letter("kiss"))
	envelope_4.pressed.connect(func(): open_letter("smile"))
	envelope_5.pressed.connect(func(): open_letter("courage"))
	final_button.pressed.connect(func(): open_letter("final"))
	
	close_popup_button.pressed.connect(close_popup)
	back_button.pressed.connect(go_back)
	
	update_progress()


func open_letter(letter_id: String):
	var data = letters[letter_id]
	popup_panel.visible = true
	popup_message.text = make_letter_markup(
		data["title_zh"],
		data["title_en"],
		data["zh"],
		data["en"]
	)
	
	if letter_id != "final" and opened[letter_id] == false:
		opened[letter_id] = true
		opened_count += 1
		update_progress()
		
		if opened_count == 5:
			final_button.visible = true
			final_button.disabled = false


func update_progress():
	var zh_line := "你已经打开了 %d / 5 封小信。" % opened_count
	var en_line := "You have opened %d / 5 little letters." % opened_count
	
	if opened_count < 5:
		progress_text.text = """
[center]
[font_size=18][color=#B45C8A]%s[/color][/font_size]
[font_size=14][color=#8C8C8C]%s[/color][/font_size]
[/center]
""" % [zh_line, en_line]
	else:
		progress_text.text = """
[center]
[font_size=18][color=#D14D8B]你已经打开了所有小信，最后一封特别的信出现啦。[/color][/font_size]
[font_size=14][color=#8C8C8C]You opened all the little letters, and the final special letter has appeared.[/color][/font_size]
[/center]
"""


func make_letter_markup(title_zh: String, title_en: String, body_zh: String, body_en: String) -> String:
	return """
[center]
[font_size=28][color=#D14D8B]%s[/color][/font_size]
[font_size=15][color=#8A8A8A]%s[/color][/font_size]

[font_size=22][color=#A64D79]%s[/color][/font_size]

[font_size=15][color=#7A7A7A]%s[/color][/font_size]
[/center]
""" % [title_zh, title_en, body_zh, body_en]


func close_popup():
	popup_panel.visible = false


func go_back():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
