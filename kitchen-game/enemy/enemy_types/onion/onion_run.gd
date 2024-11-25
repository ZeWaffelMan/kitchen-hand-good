extends State
class_name OnionRun


@export var enemy: Enemy

@export var head: EnemyHead
@export var movement: EnemyMovement

@export var max_run_timer: float = 3.0
@onready var current_run_timer: float = max_run_timer

@export var movement_animation_player: AnimationPlayer


func enter_state() -> void:
	enemy.face_animation_player.play("happy")
	movement_animation_player.play("run")


func update_state(delta) -> void:
	if current_run_timer > 0:
		current_run_timer -= delta
	else:
		current_run_timer = max_run_timer
		transitioned.emit(self, "Rest")
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")


func physics_update_state(delta) -> void:
	head.apply_force(movement.move_direction * movement.acceleration * delta)
