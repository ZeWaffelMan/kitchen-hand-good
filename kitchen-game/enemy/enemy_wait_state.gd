extends State
class_name WaitState


@export var does_wait_to_stand: bool = true
@export var enemy: Enemy
@export var movement_animation_player: AnimationPlayer
@export var movement: EnemyMovement

@export var next_state: String = ""


func enter_state() -> void:
	movement_animation_player.play("RESET")


func update_state(delta) -> void:
	enemy.enemy_movement.is_using_friction = false
	if does_wait_to_stand:
		if enemy.enemy_state == enemy.EnemyStates.STAND:
			transitioned.emit(self, next_state)
	else:
		transitioned.emit(self, next_state)
