extends Node2D


@export var bullets_to_spawn: Array[RigidBody2D]
@export var bullet_force: float = 2000.0

var random_direction: Vector2 = Vector2.ZERO
var random_rotation: float = 0.0


func _ready() -> void:
	for bullet in bullets_to_spawn:
		random_direction.x = randf_range(-1, 1)
		random_direction.y = randf_range(-1, 1)
		random_direction = random_direction.normalized()
		
		random_rotation = randf_range(0.0, 360.0)
		
		bullet.apply_impulse(random_direction * bullet_force)
		bullet.global_rotation = random_rotation
