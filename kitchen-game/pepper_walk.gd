extends State


@export var enemy: Enemy
@export var storage: EnemyStorage

@export var movement: EnemyMovement
@export var head: EnemyHead

@export var max_switch_time: float = 4.0
@onready var switch_time: float = max_switch_time

@export var player_detection: PlayerDetection
var player: PlayerHand
var run_direction: Vector2 = Vector2.ZERO


func enter_state() -> void:
	storage.movement_animation_player.play("run")
	pass


func exit_state() -> void:
	pass


func physics_update_state(delta) -> void:
	if player_detection.sees_player():
		player = player_detection.closest_player()
		storage.player = player
		
		var axis: Vector2 = player.global_position - head.global_position
		var direction: Vector2 = axis.normalized()
		run_direction = direction
		
		transitioned.emit(self, "Shoot")
	
	head.apply_force(run_direction * movement.acceleration * delta)
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")
