extends Node2D

var car_pos := Vector2(640, 520)
var car_angle := -PI / 2.0
var speed := 0.0
var marks: Array[Vector2] = []

func _ready():
    queue_redraw()

func _process(delta):
    var steer = Input.get_axis("ui_left", "ui_right")
    var throttle = 1.0 if Input.is_action_pressed("ui_up") else 0.0
    var brake = 1.0 if Input.is_action_pressed("ui_down") else 0.0
    speed = move_toward(speed, throttle * 310.0, 180.0 * delta)
    speed = move_toward(speed, 0.0, (45.0 + brake * 360.0) * delta)
    if abs(speed) > 8.0:
        car_angle += steer * 2.4 * delta * clamp(abs(speed) / 160.0, .25, 1.0)
    car_pos += Vector2.UP.rotated(car_angle) * speed * delta
    car_pos.x = clamp(car_pos.x, 30.0, 1250.0)
    car_pos.y = clamp(car_pos.y, 30.0, 690.0)
    if abs(steer) > .55 and speed > 100.0:
        marks.append(car_pos)
        if marks.size() > 2500: marks.pop_front()
    queue_redraw()

func _draw():
    draw_rect(Rect2(0,0,1280,720), Color("#100d22"))
    # Simple readable prototype circuit: outer and inner shapes create asphalt ribbon.
    draw_circle(Vector2(640,360), 300, Color("#24233a"))
    draw_circle(Vector2(640,360), 175, Color("#100d22"))
    draw_arc(Vector2(640,360), 300, 0, TAU, 128, Color("#ff2fa8"), 5)
    draw_arc(Vector2(640,360), 175, 0, TAU, 128, Color("#28e7ff"), 4)
    for p in marks:
        draw_circle(p, 2.2, Color(0.03,0.02,0.06,.65))
    draw_set_transform(car_pos, car_angle)
    draw_rect(Rect2(-7,-13,14,26), Color("#ff8a2b"))
    draw_circle(Vector2(0,-9),3,Color("#ffe9a8"))
    draw_set_transform(Vector2.ZERO,0)
    draw_string(ThemeDB.fallback_font, Vector2(28,42), "NEON RACER / PROTOTYPE 0.1", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("#f2eaff"))
    draw_string(ThemeDB.fallback_font, Vector2(28,68), "Arrow keys for desktop test • touch controls next", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("#9e98b9"))
