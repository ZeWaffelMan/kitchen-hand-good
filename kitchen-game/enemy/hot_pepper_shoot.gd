extends State


@export var movement: EnemyMovement
@export var enemy: Enemy
@export var storage: EnemyStorage
@export var head: EnemyHead
@export var head_holder: Node2D
@export var hazard: Hazard
@export var face_controller: FaceController

@export var is_shooting: bool = false

@export var angle_offset: float = 90.0
@export var rotate_head_speed: float = 0.5

@export var max_time_until_shoot: float = 1.0
@onready var time_until_shoot: float = max_time_until_shoot

@export var max_shoot_switch_time: float = 3.0
@onready var shoot_switch_time: float = max_shoot_switch_time
var run_direction: Vector2 = Vector2.ZERO


func enter_state() -> void:
	storage.movement_animation_player.play("RESET")
	face_controller.can_blink = false
	enemy.eyes_animation_player.play("sqrunched")
	time_until_shoot = max_time_until_shoot
	
	run_direction = storage.last_player_position - head.global_position
	run_direction = run_direction.normalized()


func exit_state() -> void:
	hazard.monitoring = false


func physics_update_state(delta) -> void:
	if time_until_shoot > 0:
		time_until_shoot -= delta
	else:
		is_shooting = true
	
	if is_shooting:
		face_controller.can_blink = true
		# set the hazard for shooting
		hazard.monitoring = true
		movement.movement_animation_player.play("run")
		head.apply_force(run_direction * movement.acceleration * delta)
		
		if shoot_switch_time > 0:
			shoot_switch_time -= delta
		else:
			shoot_switch_time = max_shoot_switch_time
			transitioned.emit(self, "Rest")
