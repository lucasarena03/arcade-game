extends Area2D

@onready var game = get_tree().root.get_node("Game")

var holder: Player = null

func _ready() -> void:
    reset_position()


func reset_position():
    # 128 0 -> 320 384
    global_position = Vector2(randf_range(128, 320), randf_range(0, 384))


func is_being_held() -> bool:
    return holder != null


func _on_area_entered(area: Area2D) -> void:
    if area is Player and not is_being_held():
        holder = area


func _process(delta: float) -> void:
    if is_being_held():
        global_position = holder.global_position + Vector2(8, 0)
