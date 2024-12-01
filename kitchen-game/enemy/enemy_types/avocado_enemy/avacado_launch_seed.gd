extends Node
class_name AvocadoLaunchSeed


@export var shoot_sound: AudioStreamPlayer

@export var max_launch_time: float = 1.5
@onready var current_launch_time: float = max_launch_time

@export var avocado_pit: Sprite2D

@export var pit_player_detection: PlayerDetection
@export var pit_enemy: Resource
@export var pit_jump_force: float = 5.0
@export var head: EnemyHead
@export var launch_seed_point: Node2D
@export var has_launched_pit: bool = false

@export var squash_animation_player: AnimationPlayer

var player: Node2D


func _physics_process(delta: float) -> void:
	if pit_player_detection.sees_player():
		if pit_player_detection.area != null:
			player = pit_player_detection.area.player
			var axis: Vector2 = player.global_position - launch_seed_point.global_position
			
			if !has_launched_pit:
				if current_launch_time > 0:
					current_launch_time -= delta
				else:
					if avocado_pit != null:
						squash_animation_player.play("squash")
						avocado_pit.visible = false
					current_launch_time = max_launch_time
					has_launched_pit = true
					launch_pit(axis, pit_jump_force)


func launch_pit(force, direction):
	shoot_sound.play()
	shoot_sound.pitch_scale = Sound.random_pitch(0.9, 1.1)
	
	var pit_instance: Enemy = pit_enemy.instantiate()
	get_tree().current_scene.add_child(pit_instance)
	pit_instance.global_position = launch_seed_point.global_position
	
	pit_instance.head.apply_impulse(direction * force)
