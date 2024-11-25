extends State


@export var enemy: Enemy
@export var movement: EnemyMovement

@export var storage: EnemyStorage
@export var head: EnemyHead

@export var head_holder: Node2D
@export var head_rotate_speed: float = 10.0
@export var angle_offset: float = 90.0

@export var max_switch_time: float = 2.0
@onready var switch_time: float = max_switch_time


func enter_state() -> void:
	movement.movement_animation_player.play("idle")
	movement.is_using_friction = true


func exit_state() -> void:
	movement.is_using_friction = false
	if storage.player != null:
		storage.last_player_position = storage.player.global_position


func update_state(delta) -> void:
	if storage.player != null:
		var axis: Vector2 = storage.player.global_position - head.global_position
		var direction: Vector2 = axis.normalized()
		var angle = direction.angle()
		
		if enemy.enemy_state != enemy.EnemyStates.STAND:
			transitioned.emit(self, "Wait")
	
	if switch_time > 0:
		switch_time -= delta
	else:
		switch_time = max_switch_time
		transitioned.emit(self, "Shoot")
