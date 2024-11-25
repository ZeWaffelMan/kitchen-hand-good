extends State


@export var enemy: Enemy
@export var player_detection: PlayerDetection
@export var storage: EnemyStorage
@export var head: EnemyHead
@export var movement: EnemyMovement

@export var max_time_until_switch: float = 1.0
@onready var time_until_switch: float = max_time_until_switch

var has_seen_player: bool = false
@export var direction: float = 1

@export var face_controller: FaceController
@export var eyes_animation_player: AnimationPlayer

@export var max_walk_time: float = 5.0
@onready var walk_time: float = max_walk_time
@export var mouth_animation_controller: AnimationPlayer

var player: PlayerHand


func enter_state() -> void:
	enemy.enemy_movement.is_using_friction = false
	face_controller.can_blink = true
	mouth_animation_controller.play("toungue_out")
	eyes_animation_player.play("open")
	storage.movement_animation_player.play("run")
	has_seen_player = false


func exit_state() -> void:
	enemy.enemy_movement.is_using_friction = false
	time_until_switch = max_time_until_switch


func physics_update_state(delta) -> void:
	if head.is_grabbed:
		transitioned.emit(self, "Wait")
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")
	if !head.is_grabbed:
		if player_detection.sees_player():
			has_seen_player = true
	
	if walk_time > 0:
		walk_time -= delta
	else:
		walk_time = max_walk_time
		transitioned.emit(self, "Rest")
	
	if has_seen_player:
		enemy.movement_animation_player.play("RESET")
		eyes_animation_player.play("sqrunched")
		mouth_animation_controller.play("uneasy")
		face_controller.can_blink = false
		movement.is_using_friction = true
		if time_until_switch > 0:
			time_until_switch -= delta
		else:
			transitioned.emit(self, "SpikeAttack")
	
	if !has_seen_player:
		head.apply_force(Vector2(movement.move_direction) * movement.acceleration * delta)
