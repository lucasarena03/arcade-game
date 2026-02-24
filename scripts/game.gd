extends Node


@onready var score_label = %ScoreLabel
@onready var opponents = %Opponents
@onready var player = %Player
@onready var ball = %Ball
@onready var loss_label = %LossLabel

const opponent_template = preload("res://scenes/opponent.tscn")

var score: int = 0

func score_touchdown() -> void:
	score += 1
	ball.reset_position()
	player.reset_position()
	if score == 1 or score % 5 == 0:
		var new_opponent = opponent_template.instantiate()
		opponents.add_child.call_deferred(new_opponent)
		await new_opponent.ready
	for opponent in opponents.get_children():
		opponent.reset_position()


func _process(delta: float) -> void:
	score_label.text = "%d" % score


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()


func lose() -> void:
	if loss_label.visible:
		return
	player.queue_free.call_deferred()
	loss_label.show()
	loss_label.text = "You lost the ball!\nYou managed to score %d touchdowns before losing it.\n\nTap anywhere to play again" % score


func _on_control_gui_input(event: InputEvent) -> void:
	if loss_label.visible and event is InputEventScreenTouch and event.pressed:
		get_tree().reload_current_scene()
