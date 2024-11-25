extends Node2D
class_name EnemyMovement


@export var has_changed_direction: bool = false

@export var randomize_direction_automatically: bool = true
@export var max_randomize_direction_time: float = 1.5
@onready var randomize_direction_time: float = max_randomize_direction_time

@export var direction_cannot_be_zero: bool = false
@export var new_direction_choices: Array[int] = [-1, 1]

@export var top_wall_detection: RayCast2D
@export var bottom_wall_detection: RayCast2D

@export var right_wall_detection: RayCast2D
@export var left_wall_detection: RayCast2D

@export_group("Movement")
@export var move_direction: Vector2 = Vector2(1, 1)

@export var movement_max_speed: float = 500.0
@export var uses_new_max_speed: bool = true
@export var acceleration: float = 150000.0
@export var friction: float = 0.90
var is_using_friction: bool = false
var standing: bool = false

@export var new_bounciness: float = 7.0
@onready var default_bounciness: float = 0.3

@export_group("References")
@export var head: EnemyHead

@export var movement_animation_player: AnimationPlayer
@export var squash_animation_player: AnimationPlayer

@export var storage: EnemyStorage


func _process(delta: float) -> void:
	if randomize_direction_automatically:
		if randomize_direction_time > 0:
			randomize_direction_time -= delta
		else:
			randomize_direction_time = max_randomize_direction_time
			pick_random()
	
	if standing:
		head.physics_material_override.bounce = new_bounciness
	else:
		head.physics_material_override.bounce = default_bounciness
	react_side_walls()
	react_upper_lower_walls()


func react_side_walls():
	if right_wall_detection.is_colliding():
		if move_direction.x >= 0:
			move_direction.x = -1
			move_direction.x = clamp(move_direction.x, -1, 1)
			has_changed_direction = true
	if left_wall_detection.is_colliding():
		if move_direction.x < 0:
			move_direction.x = 1
			move_direction.x = clamp(move_direction.x, -1, 1)
			has_changed_direction = true


func react_upper_lower_walls():
	if top_wall_detection.is_colliding():
		if move_direction.y <= 0:
			move_direction.y = 1
			move_direction.y = clamp(move_direction.y, -1, 1)
			has_changed_direction = true
	if bottom_wall_detection.is_colliding():
		if move_direction.y > 0:
			move_direction.y = -1
			move_direction.y = clamp(move_direction.y, -1, 1)
			has_changed_direction = true


func pick_random() -> Vector2:
	var random_direction: float = 0
	if direction_cannot_be_zero:
		random_direction = new_direction_choices.pick_random()
	else:
		random_direction = randf_range(-1, 1)
	move_direction.y = random_direction
	
	if direction_cannot_be_zero:
		random_direction = new_direction_choices.pick_random()
	else:
		random_direction = randf_range(-1, 1)
	move_direction.x = random_direction
	
	return move_direction
