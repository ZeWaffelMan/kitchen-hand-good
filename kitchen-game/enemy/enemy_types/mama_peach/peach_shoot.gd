extends State


@export var storage: EnemyStorage
@export var baby_peach_enemy: Resource
@export var head: EnemyHead
@export var recoil_force: float = 4000.0

@export var max_shoot_time: float = 2.0
@onready var shoot_time: float = max_shoot_time

@export var baby_shoot_force: float = 5000.0

@export var fire_point: Node2D


func enter_state() -> void:
	pass


func exit_state() -> void:
	pass


func physics_update_state(delta) -> void:
	if shoot_time > 0:
		shoot_time -= delta
	else:
		shoot_baby()
		transitioned.emit(self, "Rotate")


func shoot_baby() -> void:
	var axis: Vector2 = storage.last_player_position - head.global_position
	var direction: Vector2 = axis.normalized()
	
	head.apply_impulse(-direction * recoil_force)
	
	var baby_instance: Enemy = baby_peach_enemy.instantiate()
	get_tree().current_scene.add_child(baby_instance)
	baby_instance.global_position = fire_point.global_position
	
	baby_instance.head.apply_impulse(direction * baby_shoot_force)
