extends Node

@onready var score_label = %ScoreLabel

var score: int = 0

func _process(delta: float) -> void:
    score_label.text = "%d" % score