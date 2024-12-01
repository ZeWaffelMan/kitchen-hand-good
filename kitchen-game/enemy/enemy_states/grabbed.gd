extends State
class_name EnemyGrabbed


@export var struggle_sound: AudioStreamPlayer

@export var enemy: Enemy
@export var head_collision: CollisionShape2D
@export var head: EnemyHead

@export var struggle_when_grabbed: bool = true

@export var ground_check: ObjectDetection
@export var bounce_point: Node2D

@export var animation_to_play: String = "uneasy"
@export var leave_animation_to_play: String = "neutral"
@export var mouth_animation_player: AnimationPlayer
@export var movement_animation_player: AnimationPlayer

@export var shadow: Node2D


func enter_state() -> void:
	enemy.enemy_state = enemy.EnemyStates.GRABBED
	enemy.movement_animation_player.play("RESET")
	struggle_sound.play()
	struggle_sound.pitch_scale = Sound.random_pitch(0.95, 1.05)
	mouth_animation_player.play(animation_to_play)
	
	head_collision.disabled = true


func exit_state() -> void:
	movement_animation_player.play("RESET")
	struggle_sound.stop()
	mouth_animation_player.play(leave_animation_to_play)
	head_collision.disabled = false


func update_state(delta) -> void:
	if struggle_when_grabbed:
		movement_animation_player.play("grabbed")
	if !head.is_grabbed:
		if enemy.is_secret_ingredient:
			if enemy.is_in_box:
				transitioned.emit(self, "Trapped")
		transitioned.emit(self, "Ragdoll")
