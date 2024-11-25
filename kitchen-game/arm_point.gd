extends RigidBody2D


@export var max_distance: float = 100.0
@export var anchor: Node2D

func _process(delta: float) -> void:
	anchor.global_position = get_global_mouse_position()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var axis = anchor.global_position - global_position
	var distance = axis.length()
	var direction = axis.normalized()
	linear_velocity += (distance - max_distance) * direction
