extends Area2D
class_name EnemyHurtBox


@export var enemy: Enemy
@export var health: EnemyHealth


func damage(amount: int, area: Node2D, applies_hit_force: bool) -> void:
	if health:
		health.damage(amount, area, applies_hit_force)
	else:
		print_debug("can't find health node")
