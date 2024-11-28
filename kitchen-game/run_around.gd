extends Node


@export var movement: EnemyMovement
@export var head: EnemyHead


func _physics_process(delta: float) -> void:
	head.apply_force(movement.move_direction * movement.acceleration * delta)
