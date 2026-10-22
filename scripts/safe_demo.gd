extends Node2D

var player_position := Vector2(400, 280)
var target_position := Vector2(400, 280)
var collected := 0
var flowers := [Vector2(170, 180), Vector2(630, 180), Vector2(210, 440), Vector2(590, 420)]
var font: Font

func _ready() -> void:
    font = ThemeDB.fallback_font
    queue_redraw()

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        target_position = event.position

func _process(delta: float) -> void:
    var move := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    if move.length() > 0.01:
        target_position = player_position
        player_position += move * 220.0 * delta
    else:
        player_position = player_position.move_toward(target_position, 220.0 * delta)
    player_position = player_position.clamp(Vector2(25, 70), get_viewport_rect().size - Vector2(25, 25))
    for i in range(flowers.size() - 1, -1, -1):
        if player_position.distance_to(flowers[i]) < 29.0:
            flowers.remove_at(i)
            collected += 1
    queue_redraw()

func _draw() -> void:
    var size := get_viewport_rect().size
    draw_rect(Rect2(Vector2.ZERO, size), Color("e5f2d8"))
    draw_rect(Rect2(0, 0, size.x, 65), Color("3c6651"))
    draw_string(font, Vector2(20, 38), "A Little Place For You — clean development demo", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color.WHITE)
    draw_string(font, Vector2(20, 94), "Move: arrows / WASD    Click: walk    Collect the flowers", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("274e36"))
    draw_string(font, Vector2(20, 124), "Flowers collected: %d / 4" % collected, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("274e36"))
    for flower in flowers:
        draw_circle(flower, 14, Color("ef83a6"))
        draw_circle(flower, 6, Color("ffe09a"))
    draw_circle(player_position, 19, Color("426bba"))
    draw_circle(player_position + Vector2(-6, -5), 3, Color.WHITE)
    draw_circle(player_position + Vector2(6, -5), 3, Color.WHITE)
    if flowers.is_empty():
        draw_string(font, Vector2(230, 230), "All flowers collected!", HORIZONTAL_ALIGNMENT_LEFT, -1, 30, Color("274e36"))
