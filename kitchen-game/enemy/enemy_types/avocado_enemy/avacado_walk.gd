extends State
class_name AvocadoWalk


@export var enemy: Enemy

@export var head: EnemyHead
@export var movement: EnemyMovement

@export var max_run_timer: float = 3.0
@onready var current_run_timer: float = max_run_timer

@export var movement_animation_player: AnimationPlayer
@export var player_detector: PlayerDetection
@export var storage: EnemyStorage


func enter_state() -> void:
	enemy.face_animation_player.play("neutral")
	movement_animation_player.play("run")


func update_state(delta) -> void:
	if current_run_timer > 0:
		current_run_timer -= delta
	else:
		current_run_timer = max_run_timer
		transitioned.emit(self, "Rest")
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")
		
	if player_detector.sees_player():
		storage.player = player_detector.closest_player()
		if storage.player != null:
			transitioned.emit(self, "RunAway")


func physics_update_state(delta) -> void:
	head.apply_force(movement.move_direction * movement.acceleration * delta)
