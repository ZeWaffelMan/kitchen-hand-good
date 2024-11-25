extends State
class_name HoldAndDamage


@export var head: EnemyHead
@export var storage: EnemyStorage
@export var damage_amount: int = 1
@export var fling_magnitude_threshold: float = 10_000.0

@export var max_damage_time: float = 2.0
@onready var damage_time: float = max_damage_time


func enter_state() -> void:
	damage_time = max_damage_time


func physics_update_state(delta) -> void:
	if storage.player != null:
		if storage.player.velocity.length() > fling_magnitude_threshold:
			head.cling_to_player = false
			transitioned.emit(self, "Flung")
		
		if damage_time > 0:
			damage_time -= delta
		else:
			storage.player.hurt_box.damage(damage_amount, head)
			damage_time = max_damage_time
