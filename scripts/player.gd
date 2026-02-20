class_name Player extends Area2D

@onready var game = get_tree().root.get_node("Game")

@export var speed : int = 150
@export var stop_distance : float = 8.0

var _target: Vector2
var _moving: bool = false

func reset_position() -> void:
	global_position = Vector2(64, 192 + randf_range(-64, 64))


func _ready():
	_target = global_position

func _input(event):
	# Touch (mobile) or mouse click (desktop)
	if (event is InputEventScreenTouch and event.pressed) or event is InputEventScreenDrag:
		_target = event.position
		_moving = true


func _process(delta):
	if _moving:
		var direction = _target - global_position
		var distance = direction.length_squared()
		if distance > stop_distance * stop_distance:
			direction = direction.normalized()
			global_position += direction * speed * delta
		else:
			_moving = false


func _on_area_entered(area: Area2D) -> void:
	if area is Endzone:
		var ball = game.get_node("Ball")
		if ball.holder == self:
			game.score += 1
			ball.holder = null
			ball.reset_position()
			reset_position()
