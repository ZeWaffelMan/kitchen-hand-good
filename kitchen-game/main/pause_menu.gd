extends Node2D


var can_unpause: bool = false



func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("pause"):
		can_unpause = true
	if Input.is_action_just_pressed("pause"):
		if can_unpause:
			unpause()


func unpause() -> void:
	print("unpause")
	hide()
	can_unpause = false
	get_tree().paused = false
