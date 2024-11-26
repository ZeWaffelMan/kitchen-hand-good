extends Area2D
class_name Hazard


@export var is_auto_kill: bool = false

@export var damage_amount: float = 1.0
@export var hurt_box_exception: Area2D
@export var node_to_destroy: Node2D

@export var only_hurt_player: bool = false
@export var applies_enemy_hit_force: bool = true

@export var destroy_when_hit: bool = false


func _process(delta: float) -> void:
	if monitoring:
		if has_overlapping_areas():
			var areas = get_overlapping_areas()
			for area in areas:
				if area is EnemyHurtBox or area is PlayerHurtBox:
					if area != hurt_box_exception or hurt_box_exception == null:
						if area is EnemyHurtBox and !only_hurt_player:
							var hurt_box: EnemyHurtBox = area
							if is_auto_kill:
								hurt_box.health.kill()
							hurt_box.damage(damage_amount, self, applies_enemy_hit_force)
							if destroy_when_hit:
								if node_to_destroy != null:
									node_to_destroy.queue_free()
								else:
									print_debug("can't find node to destroy")
						elif area is PlayerHurtBox:
							var hurt_box: PlayerHurtBox = area
							if is_auto_kill:
								area.health.kill()
							area.damage(damage_amount, self)
							if destroy_when_hit:
								if node_to_destroy != null:
									node_to_destroy.queue_free()
								else:
									print_debug("can't find node to destroy")


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
