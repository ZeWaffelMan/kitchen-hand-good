extends Node2D
class_name Enemy


@export var find_hazard: Bullet
@export var enemy_movement: EnemyMovement

@export var movement_animation_player: AnimationPlayer
@export var squash_animation_player: AnimationPlayer

@export var face_animation_player: AnimationPlayer
@export var eyes_animation_player: AnimationPlayer

var speed_damage_threshold: float = 3000.0
var ragdoll_magnitude_threshold: float = 400.0

@export var does_wait_to_launch: bool = true
@export var head: EnemyHead
@export var speed_hurt_box_collision: CollisionShape2D

@export var is_in_box: bool = false
@export var can_be_grabbed: bool = true

@export var turn_into_secret: TurnIntoSecret
var is_secret_ingredient: bool = false

@export var enemy_juice_color_node: Node2D
@onready var juice_color = enemy_juice_color_node.self_modulate

@export var dust_particles: GPUParticles2D

@export var storage: EnemyStorage

enum EnemyStates{
	RAGDOLL,
	REBALANCE,
	STAND,
	STANDPLATFORM,
	GRABBED,
	TRAPPED,
}

var enemy_state = EnemyStates.RAGDOLL


func _ready() -> void:
	if dust_particles != null:
		dust_particles.emitting = true
	if turn_into_secret != null:
		is_secret_ingredient = true


func _process(delta: float) -> void:
	if head.is_grabbed:
		speed_hurt_box_collision.disabled = true
	else:
		speed_hurt_box_collision.disabled = false
