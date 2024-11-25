extends Node


@export var target_node: Node2D
@export var node_with_velocity: Node2D
var target_velocity: Vector2


func _process(delta: float) -> void:
	target_velocity = node_with_velocity.velocity
	
	var tilt_direction: float = 0.0
	if target_velocity > Vector2.ZERO:
		tilt_direction = 1
	elif target_velocity < Vector2.ZERO:
		tilt_direction = -1
		
	var tilt_rotation = deg_to_rad(target_velocity.length() * 0.01 * tilt_direction)
	tilt_rotation = clampf(tilt_rotation, -1.5, 1.5)
	target_node.global_rotation = lerpf(target_node.global_rotation, tilt_rotation, 0.2)
