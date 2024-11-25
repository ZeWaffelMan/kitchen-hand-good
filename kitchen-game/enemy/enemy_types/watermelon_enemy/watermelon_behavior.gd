extends Node
class_name Watermelon


var can_shoot: bool = false

@export var enemy_rest_state: EnemyRestState
@onready var reload_time: float = enemy_rest_state.rest_time



func _process(delta: float) -> void:
	if !can_shoot:
		if reload_time > 0:
			reload_time -= delta
		else:
			can_shoot = true
			reload_time = enemy_rest_state.rest_time
