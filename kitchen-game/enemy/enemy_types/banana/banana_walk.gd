extends State


@export var enemy: Enemy
@export var movement: EnemyMovement
@export var head: EnemyHead

@export var player_detection: PlayerDetection

@export var max_time_til_switch: float = 0.5
@onready var time_til_switch: float = max_time_til_switch

@export var max_switch_to_rest_time: float = 3.0
@onready var switch_to_rest_time: float = max_switch_to_rest_time


func enter_state() -> void:
	movement.movement_animation_player.play("run")


func exit_state() -> void:
	pass


func update_state(delta) -> void:
	pass


func physics_update_state(delta) -> void:
	if player_detection.sees_player():
		enemy.eyes_animation_player.play("sqrunched")
		if time_til_switch > 0:
			time_til_switch -= delta
		else:
			transitioned.emit(self, "LaunchSplit")
	else:
		time_til_switch = max_time_til_switch
	
	if switch_to_rest_time > 0:
		switch_to_rest_time -= delta
	else:
		switch_to_rest_time = max_switch_to_rest_time
		transitioned.emit(self, "Rest")
	
	head.apply_force(movement.move_direction * movement.acceleration * delta)
	
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")
