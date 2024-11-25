extends Node


@export var enemy_health: EnemyHealth
@export var head: EnemyHead

@export var max_explode_time: float = 0.4
@export var min_explode_time: float = 0.5
@onready var current_explode_time: float = randf_range(min_explode_time, max_explode_time)

@export var explosion: Resource
@export var body_sprites: Node2D

@export var speed_box: Area2D
@export var player_detection: PlayerDetection


func enter_state() -> void:
	var random_rotation: float = randf_range(0, 360)
	body_sprites.global_rotation = random_rotation


func _process(delta: float) -> void:
	if head.is_grabbed:
		player_detection.monitoring = false
	else:
		player_detection.monitoring = true
	
	if current_explode_time > 0:
		current_explode_time -= delta
	else:
		current_explode_time = max_explode_time
		explode()
	
	if speed_box.has_overlapping_areas() or player_detection.sees_player():
		explode()


func explode() -> void:
	#var explosion_instance = explosion.instantiate()
	#get_tree().current_scene.add_child(explosion_instance)
	#explosion_instance.global_position = head.global_position
	
	CameraShake.add_trama(0.4)
	enemy_health.kill()
