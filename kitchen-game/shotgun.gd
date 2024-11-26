extends Node2D


@export var bullets_to_spawn: Array[RigidBody2D]
@export var bullet_force: float = 3000.0

var random_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	for bullet in bullets_to_spawn:
		if bullet != null and bullet is RigidBody2D:
			random_direction.x = randf_range(-1, 1)
			random_direction.y = randf_range(-1, 1)
			random_direction = random_direction.normalized()
			
			var random_torque = randf_range(-300000.0, 300000.0)
			
			bullet.apply_impulse(random_direction * bullet_force)
			bullet.apply_torque_impulse(random_torque)
