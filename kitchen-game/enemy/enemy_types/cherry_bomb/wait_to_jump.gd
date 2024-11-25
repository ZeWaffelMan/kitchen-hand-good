extends State


@export var enemy: Enemy

@export var max_wait_time: float = 1.5
@onready var wait_time: float = max_wait_time
@export var movement: EnemyMovement


func enter_state() -> void:
	#play getting ready to jump animation
	movement.is_using_friction = true


func exit_state() -> void:
	movement.is_using_friction = false


func update_state(delta) -> void:
	if wait_time > 0:
		wait_time -= delta
	else:
		wait_time = max_wait_time
		transitioned.emit(self, "JumpUp")
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")
