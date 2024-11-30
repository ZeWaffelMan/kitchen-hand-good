extends Node


@export var health: EnemyHealth
@export var jump_up_state: CherryJumpUp


func _process(delta: float) -> void:
	if health.health < health.max_health:
		jump_up_state.blow_up()
