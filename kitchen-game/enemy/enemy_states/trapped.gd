extends State
class_name EnemyTrapped


@export var enemy: Enemy


func enter_state() -> void:
	enemy.enemy_state = enemy.EnemyStates.TRAPPED
