extends State


@export var seed_bullet: Resource
@export var hurt_box: EnemyHurtBox
@export var fire_point: Node2D

@export var watermelon: Watermelon
@export var enemy: Enemy

@export var player_detection: PlayerDetection
@export var storage: EnemyStorage
@export var head: EnemyHead
var player: PlayerHand

@export var shoot_force: float = 2500.0

@export var max_time_between_shots: float = 0.25
@onready var time_between_shots: float = max_time_between_shots

@export var max_time_til_done = 2.5
@onready var time_til_done: float = max_time_til_done

@export var enemy_movement: EnemyMovement


func enter_state():
	enemy.movement_animation_player.play("run")


func update_state(delta) -> void:
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")


func physics_update_state(delta) -> void:
	if watermelon.can_shoot:
		enemy.face_animation_player.play("small_open")
		head.apply_force(Vector2(enemy_movement.move_direction * enemy_movement.acceleration) * delta)
		if time_between_shots > 0:
			time_between_shots -= delta
		else:
			shoot()
			CameraShake.add_trama(0.15)
			enemy_movement.squash_animation_player.play("squash")
			time_between_shots = max_time_between_shots
		if time_til_done != null:
			if time_til_done > 0:
				time_til_done -= delta
			else:
				time_til_done = max_time_til_done
				watermelon.can_shoot = false
	if !watermelon.can_shoot:
		transitioned.emit(self, "Rest")
	


func shoot() -> void:
	var bullet_instance: Bullet = seed_bullet.instantiate()
	bullet_instance.hazard.hurt_box_exception = hurt_box
	bullet_instance.global_position = fire_point.global_position
	get_tree().current_scene.add_child(bullet_instance)
	
	var randomness: float = randf_range(-2, 2)
	var randomness_y: float = randf_range(1, 2)
	bullet_instance.apply_impulse(Vector2(randomness * 200, -shoot_force * randomness_y))
