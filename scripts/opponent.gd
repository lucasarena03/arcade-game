class_name Opponent extends Area2D

@onready var warmup: int = 25
@onready var speed: int = 0
@onready var max_speed: int = 100

@onready var game = get_tree().root.get_node("Game")
@onready var sprite = $Sprite2D

func reset_position() -> void:
    speed = 0
    max_speed = (100 + floor(game.score / 5) * 20) * (0.9 + randf() * 0.2)
    print(max_speed)
    global_position = Vector2(624, 192 + randf_range(-128, 128))


func _process(delta: float) -> void:
    if speed > max_speed:
        speed = max_speed
    else:
        speed += ceil(warmup * delta)
    var ball = game.ball
    var direction = ball.global_position - global_position
    if direction.length_squared() > 16 * 16:
        direction = direction.normalized()
        sprite.flip_h = direction.x < 0
        global_position += direction * speed * delta
