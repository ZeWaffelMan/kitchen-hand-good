extends State
class_name CherryRunAround


@export var storage: EnemyStorage
@export var enemy: Enemy
@export var movement: EnemyMovement
@export var head: EnemyHead
@export var last_player_position: Vector2 = Vector2.ZERO

@export var max_rest_time: float
@onready var rest_time: float = max_rest_time

@export var player_detection: PlayerDetection
var player: PlayerHand
@export var face_controller: FaceController


func enter_state() -> void:
	movement.movement_animation_player.play("run")
	enemy.face_animation_player.play("sad")


func update_state(delta) -> void:
	if rest_time > 0:
		rest_time -= delta
	else:
		rest_time = max_rest_time
		transitioned.emit(self, "Rest")
	
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")


func physics_update_state(delta) -> void:
	if player_detection.sees_player():
		storage.player = player_detection.closest_player()
		if storage.player != null:
			last_player_position = storage.player.global_position
			transitioned.emit(self, "WaitToJump")
		
	head.apply_force(movement.acceleration * movement.move_direction * delta)
