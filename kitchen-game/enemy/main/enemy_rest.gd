extends State
class_name EnemyRestState


@export var use_friction_when_waiting: bool = true

@export var max_rest_time: float = 2.0
@onready var rest_time: float = max_rest_time

@export var next_state: String = ""

@export var movement_animation_to_play: String = "RESET"
@export var mouth_animation_to_play: String = "neutral"
@export var eyes_animation_to_play: String = ""

@export_group("Options")
@export var randomize_direction: bool = true

@export var does_switch_if_player: bool
@export var player_detection: PlayerDetection

@export_group("References")
@export var movement_animation_player: AnimationPlayer
@export var mouth_animation_player: AnimationPlayer
@export var enemy: Enemy
@export var movement: EnemyMovement
@export var wait_state: WaitState
@export var face_controller: FaceController


func enter_state() -> void:
	if eyes_animation_to_play != "":
		#face_controller.can_blink = false
		enemy.eyes_animation_player.play(eyes_animation_to_play)
	
	if movement_animation_player != null:
		movement_animation_player.play(movement_animation_to_play)
	
	if mouth_animation_player != null:
		mouth_animation_player.play(mouth_animation_to_play)
	
	if randomize_direction:
		movement.pick_random()
	
	rest_time = max_rest_time
	if use_friction_when_waiting:
		movement.is_using_friction = true


func exit_state() -> void:
	movement.is_using_friction = false
	face_controller.can_blink = true


func update_state(delta) -> void:
	if does_switch_if_player:
		if player_detection != null:
			if player_detection.sees_player():
				transitioned.emit(self, next_state)
	
	if rest_time > 0:
		rest_time -= delta
	else:
		transitioned.emit(self, next_state)
	if next_state == "":
		print_debug("forgot to set next state for enemy")
	
	if wait_state.does_wait_to_stand:
		if enemy.enemy_state != enemy.EnemyStates.STAND:
			transitioned.emit(self, "Wait")
