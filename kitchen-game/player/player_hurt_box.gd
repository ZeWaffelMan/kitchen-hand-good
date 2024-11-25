extends Area2D
class_name PlayerHurtBox


@export var health: PlayerHealth

var is_invincible: bool = false


func damage(amount: int, area: Node2D) -> void:
	is_invincible = health.is_invincible
	
	if !is_invincible:
		if health:
			health.damage(amount, area)
