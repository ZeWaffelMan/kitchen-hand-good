extends State
class_name Alert


@export var enemy: Enemy
@export var max_switch_timer: float = 1.0
@onready var current_switch_timer: float = max_switch_timer


func enter_state() -> void:
	current_switch_timer = max_switch_timer


func update_state(delta) -> void:
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")
		
	if current_switch_timer > 0:
		current_switch_timer -= delta
	else:
		transitioned.emit(self, "Shoot")
