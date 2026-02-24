extends Area2D

@onready var game = get_tree().root.get_node("Game")

const starting_position: Vector2 = Vector2(560, 192)
const speed: float = 200.0

var target_position: Vector2
var distance_to_target: float = 0.0
var kicking_off: bool = false
var timer: float = 0.0
var sliding: bool = false
var velocity: Vector2 = Vector2.ZERO

var holder: Player = null

func _ready() -> void:
	reset_position()


func reset_position():
	holder = null
	global_position = starting_position
	target_position = Vector2(randf_range(128, 320), randf_range(0, 384))
	distance_to_target = (global_position - target_position).length_squared()
	kicking_off = true
	timer = 0.0


func is_being_held() -> bool:
	return holder != null


func _on_area_entered(area: Area2D) -> void:
	if area is Player and not is_being_held():
		holder = area
	if area is Opponent:
		game.lose()


func _process(delta: float) -> void:
	if is_being_held():
		global_position = holder.global_position + Vector2(8, 0)
	if kicking_off:
		timer += delta
		position = lerp(starting_position, target_position, timer / 1.5)
		position.y -= sin(timer * PI) * 128
		rotation += 4 * delta * randf()
		distance_to_target = (position - target_position).length_squared()
		if timer >= 1.0:
			kicking_off = false
			sliding = true
			velocity = Vector2.from_angle(randf_range(0, 2 * PI)) * speed * 0.2
	elif sliding:
		position += velocity * delta
		rotation += velocity.length_squared() * 0.01 * delta
		velocity *= 0.98
		if velocity.length_squared() < 8 * 8:
			velocity = Vector2.ZERO
			sliding = false
