extends State
class_name AvocadoRunAway


@export var enemy: Enemy
@export var storage: EnemyStorage
@export var movement: EnemyMovement
var player: PlayerHand
@export var head: EnemyHead
@export var acceleration_multiplier: float = 1.5
@export var max_time_to_stop: float = 1.5
@export var player_detection: PlayerDetection
@export var squash_check: ObjectDetection
@onready var time_to_stop: float = max_time_to_stop
@export var has_seen_object: bool = false


func enter_state() -> void:
	enemy.face_animation_player.play("sad")
	movement.randomize_direction_automatically = false
	time_to_stop = max_time_to_stop


func exit_state() -> void:
	movement.randomize_direction_automatically = true


func physics_update_state(delta) -> void:
	if !has_seen_object:
		if squash_check.sees_object():
			enemy.squash_animation_player.play("squash")
			has_seen_object = true
	if has_seen_object:
		if !squash_check.sees_object():
			has_seen_object = false
	
	if storage.player != null:
		player = storage.player
		var axis: Vector2 = player.global_position - head.global_position
		var direction: Vector2 = axis.normalized()
		
		if player_detection.sees_player():
			storage.player = player_detection.closest_player()
			time_to_stop = max_time_to_stop
			head.apply_force(-direction * movement.acceleration * acceleration_multiplier * delta)
		else:
			if time_to_stop > 0:
				time_to_stop -= delta
			else:
				transitioned.emit(self, "Rest")
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")
