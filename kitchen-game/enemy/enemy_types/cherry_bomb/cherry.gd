extends Node


@export var health: EnemyHealth
@export var jump_up_state: CherryJumpUp
@export var has_blown_up: bool = false


func _process(delta: float) -> void:
	if !has_blown_up:
		if health.health < health.max_health:
			jump_up_state.blow_up()
			health.health -= 1
		has_blown_up = true
