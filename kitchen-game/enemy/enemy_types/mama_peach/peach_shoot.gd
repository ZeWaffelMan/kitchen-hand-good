extends State


@export var storage: EnemyStorage
@export var baby_peach_enemy: Resource
@export var head: EnemyHead
@export var recoil_force: float = 4000.0

@export var max_shoot_time: float = 2.0
@onready var shoot_time: float = max_shoot_time

@export var baby_shoot_force: float = 1000.0

@export var fire_point: Node2D

@export var face_animation_player: AnimationPlayer
@export var squash_animation_player: AnimationPlayer
@export var eyes_animation_player: AnimationPlayer

@export var hurt_box: EnemyHurtBox
@export var body_sprites: Node2D
@export var rotation_speed: float = 5.0
@export var angle_offset: float = -90


func enter_state() -> void:
	face_animation_player.play("uneasy")
	eyes_animation_player.play("sqrunched")


func exit_state() -> void:
	pass


func update_state(delta) -> void:
	if storage.player != null:
		var axis: Vector2 = storage.player.global_position - head.global_position
		var direction: Vector2 = axis.normalized()
		var angle: float = direction.angle()
		
		body_sprites.global_rotation = lerp_angle(body_sprites.global_rotation, angle + deg_to_rad(angle_offset), rotation_speed * delta)


func physics_update_state(delta) -> void:
	if head.does_hang:
		if shoot_time > 0:
			shoot_time -= delta
		else:
			shoot_baby()
			shoot_time = max_shoot_time
			transitioned.emit(self, "Rotate")


func shoot_baby() -> void:
	squash_animation_player.play("squash")
	
	var axis: Vector2 = storage.player.global_position - head.global_position
	var direction: Vector2 = axis.normalized()
	
	head.apply_impulse(-direction * recoil_force)
	
	var baby_instance: Enemy = baby_peach_enemy.instantiate()
	get_tree().current_scene.add_child(baby_instance)
	baby_instance.global_position = fire_point.global_position
	if baby_instance.find_hazard != null:
		baby_instance.find_hazard.hazard.hurt_box_exception = hurt_box
	
	baby_instance.head.apply_impulse(direction * baby_shoot_force)
