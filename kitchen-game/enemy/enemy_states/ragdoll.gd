extends State
class_name EnemyRagdoll


@export var enemy: Enemy
@export var head: EnemyHead
@export var hurt_box: EnemyHurtBox

@export var ground_check: ObjectDetection
@export var platform_check: ObjectDetection

@export var velocity_fall_threshold: float = 500.0
@export var max_time_before_standing: float = 0.4
@onready var current_time_before_standing: float = max_time_before_standing

@export_group("Bounce Platform")
@export var land_point: Node2D
@export var land_raycast: RayCast2D
@export var min_land_distance: float = 20.0
@export var max_land_distance: float = 50.0
var random_y_distance: float = 0.0
var has_set_land_position: bool = false

@export var stand_ground_check: ObjectDetection

var rebalance_rotation_threshold: float = 3.0
@onready var default_head_gravity: float = head.gravity_scale
@export var platform: StaticBody2D

@export var max_time_to_collide_platform: float = 0.2
@onready var time_to_collide_platform: float = max_time_to_collide_platform

@export var speed_damage_hurt_box: Area2D


func enter_state() -> void:
	enemy.enemy_state = enemy.EnemyStates.RAGDOLL
	platform.set_collision_layer_value(7, true)
	head.set_collision_mask_value(7, true)
	head.gravity_scale = default_head_gravity
	
	random_y_distance = randf_range(min_land_distance, max_land_distance)
	
	current_time_before_standing = max_time_before_standing


func exit_state() -> void:
	platform.set_collision_layer_value(7, false)
	head.set_collision_mask_value(7, false)
	speed_damage_hurt_box.set_collision_mask_value(7, false)
	current_time_before_standing = max_time_before_standing
	has_set_land_position = false


func update_state(delta) -> void:
	# dont want to get damaged when colliding with ground at first
	if time_to_collide_platform > 0:
		time_to_collide_platform -= delta
	else:
		speed_damage_hurt_box.set_collision_mask_value(7, false)
		time_to_collide_platform = max_time_to_collide_platform
		
	if head.collides_with_ground:
		var head_magnitude: float = head.velocity.length()
		
		if enemy.is_secret_ingredient:
			if enemy.is_in_box:
				transitioned.emit(self, "Trapped")
		if head.is_grabbed:
			transitioned.emit(self, "Grabbed")
		
		if head.has_checked_for_wall:
			if !enemy.is_secret_ingredient:
				# stand up if on the ground
				if stand_ground_check.sees_object() and head_magnitude < velocity_fall_threshold:
					if current_time_before_standing > 0:
						current_time_before_standing -= delta
					else:
						# only rebalance if not rotated properly
						if abs(head.rotation_degrees) > rebalance_rotation_threshold and !head.is_only_ragdoll:
							transitioned.emit(self, "Rebalance")
						else:
							if stand_ground_check.sees_object() and !head.is_only_ragdoll:
								transitioned.emit(self, "Stand")
						
						current_time_before_standing = max_time_before_standing


func physics_update_state(delta) -> void:
	# set the position of the ground point if we haven't done that
	if ground_check.sees_object():
		platform.set_collision_layer_value(7, true)
	else:
		platform.set_collision_layer_value(7, false)
	
	# make sure we cant just set the food down in thin air
	if land_raycast.is_colliding():
		if head.velocity.y > enemy.speed_damage_threshold * 0.75:
			if !ground_check.sees_object():
				set_land_point_position()
		else:
			if !stand_ground_check.sees_object():
				set_land_point_position()


func set_land_point_position() -> void:
	var target_point: Vector2 = land_raycast.get_collision_point()
	target_point = target_point + Vector2(0, random_y_distance)
	
	land_point.global_position.y = target_point.y
	has_set_land_position = true
