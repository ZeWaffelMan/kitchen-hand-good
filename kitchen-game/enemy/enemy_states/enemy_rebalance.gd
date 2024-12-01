extends State
class_name RebalanceEnemy


@export var jump_sound: AudioStreamPlayer
@export var land_sound: AudioStreamPlayer

@export var max_switch_state_time: float = 0.1
@onready var current_switch_state_time = max_switch_state_time

@export var jump_force: float = 5000.0
var has_jumped: bool = false

@export_group("References")
@export var enemy: Enemy
@export var head: EnemyHead
@export var head_sprites: Node2D

@export var ground_check: ObjectDetection
@export var platform_check: ObjectDetection
@export var bounce_point: Node2D
@export var platform: StaticBody2D

@export var stand_ground_check: ObjectDetection

@export var enemy_movement_animation_player: AnimationPlayer
@export var max_switch_ragdoll_time: float = 1.0
@onready var switch_ragdoll_time: float = max_switch_ragdoll_time

var has_landed: bool = false


func enter_state() -> void:
	enemy.enemy_state = enemy.EnemyStates.REBALANCE
	platform.set_collision_layer_value(7, false)
	enemy_movement_animation_player.play("rebalance")
	jump_up()


func exit_state() -> void:
	platform.set_collision_layer_value(7, true)
	current_switch_state_time = max_switch_state_time
	has_jumped = false
	head.gravity_scale = 0


func update_state(delta: float) -> void:
	if head.is_grabbed:
		transitioned.emit(self, "Grabbed")
	if !stand_ground_check.sees_object():
		if switch_ragdoll_time > 0:
			switch_ragdoll_time -= delta
		else:
			switch_ragdoll_time = max_switch_ragdoll_time
			transitioned.emit(self, "Ragdoll")
	
	if head.global_position.y < bounce_point.global_position.y + -20:
		has_jumped = true
	
	if has_jumped:
		if stand_ground_check.sees_object():
			#if !has_landed:
				#land_sound.play()
				#land_sound.pitch_scale = Sound.random_pitch(0.95, 1.15)
				#has_landed = true
			if !enemy_movement_animation_player.is_playing():
				transitioned.emit(self, "Stand")
		else:
			has_landed = false


func jump_up() -> void:	
	jump_sound.play()
	jump_sound.pitch_scale = Sound.random_pitch(1.0, 1.1)
	
	enemy.squash_animation_player.play("squash")
	head.apply_impulse(Vector2.UP * jump_force)
