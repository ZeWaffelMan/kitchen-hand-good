extends State


@export var enemy: Enemy

@export var max_wait_time: float = 1.5
@onready var wait_time: float = max_wait_time
@export var movement: EnemyMovement
@export var face_controller: FaceController


func enter_state() -> void:
	#play getting ready to jump animation
	movement.squash_animation_player.play("squash")
	movement.movement_animation_player.play("RESET")
	movement.is_using_friction = true
	face_controller.can_blink = false
	enemy.eyes_animation_player.play("sqrunched")


func exit_state() -> void:
	movement.is_using_friction = false


func update_state(delta) -> void:
	enemy.eyes_animation_player.play("sqrunched")
	if wait_time > 0:
		wait_time -= delta
	else:
		wait_time = max_wait_time
		transitioned.emit(self, "JumpUp")
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")
