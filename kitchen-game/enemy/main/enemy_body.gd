extends RigidBody2D
class_name EnemyHead


@export var big_player_detection: PlayerDetection
@export var launch_into_arena: bool = true
@export var launch_force: float = 6000.0

@export var secret_area_detection: ObjectDetection
var secret_area: SecretArea

@export var collides_with_ground: bool = true
@export var cling_to_player: bool = false
@export var is_only_ragdoll: bool = false
var player: PlayerHand

@export var speed_damage_camera_shake_amount: float = 0.3

@export_group("Swinging")
@export var rope: Rope
@export var stop_swinging_if_grabbed: bool = true

@export var does_hang: bool = false
@export var anchor_point: Node2D
@export var stiffness: float = 3.0
@export var swing_friction: float = 0.98
@export var rest_length: float = 300.0

@export var grab_scale_amount: float = 1.3
@export var body_sprites_holder: Node2D
@onready var default_size: float = body_sprites_holder.scale.x
var has_grabbed: bool = false

@export_group("Hit & Hurt Boxes")
@export var enemy_hurt_box: EnemyHurtBox
@export var speed_hurt_box: Area2D
@export var ground_check: ObjectDetection
@export var platform_check: ObjectDetection
@export var inside_wall_check: ObjectDetection

@export_group("Enemy")
@export var body_sprites: Node2D

@export var enemy: Enemy
@export var head: EnemyHead
@export var health: EnemyHealth
@export var ragdoll_state: EnemyRagdoll
@export var movement: EnemyMovement

@export_group("Movement")
@export var max_speed: float = 20000.0
var velocity: Vector2 = Vector2.ZERO
@onready var last_position: Vector2 = global_position
@export var rebalance_state: RebalanceEnemy
var head_magnitude: float = 0.0

@export_group("Player")
var is_grabbed: bool = false
var hand: PlayerHand

@export_group("Ground")
@export var rotate_to_stand_speed: float = 0.2
var rotation_before_grabbed: float = 0.0

@export var shadow: Node2D
@export var platform: StaticBody2D
@export var platform_offset: float = 40.0
@export var shadow_point: Node2D

var has_checked_for_wall: bool = false

@export_subgroup("Bounce")
@export var magnitude_threshold_to_bounce: float = 2300.0

@export var find_bounce_raycast: RayCast2D
@export var bounce_point: Node2D

@export var bounce_position_offset = 20.0
var bounce_point_offset: float = 20.0
var floor_bounce: float = 1.6

@export var squash_animation_player: AnimationPlayer
@export var squash_magnitude_threshold: float = 200.0

var secret_box_area: SecretArea
var has_standed = false
var has_changed_bounce_offset: bool = false

var box_bounds_bottom_left: Vector2 = Vector2.ZERO
var box_bounds_top_right: Vector2 = Vector2.ZERO

var collision_position: Vector2 = Vector2.ZERO
@export var stand_ground_check: ObjectDetection

@export var looking_for_ground_nodes: Node2D

var has_launched_into_arena: bool = false
var can_check_for_wall: bool = false


func _ready() -> void:
	health.is_invincible = true
	shadow.visible = false


func _process(delta: float) -> void:
	if big_player_detection.sees_player():
		var player = big_player_detection.closest_player()
		if !has_launched_into_arena:
			if launch_into_arena:
				var direction: Vector2 = player.global_position - global_position
				direction = direction.normalized()
				apply_impulse(direction * launch_force)
				has_launched_into_arena = true
	
	if inside_wall_check.sees_object():
		can_check_for_wall = true
	if can_check_for_wall:
		if !has_checked_for_wall:
			if !inside_wall_check.sees_object():
				set_collision_mask_value(1, true)
				has_checked_for_wall = true
				health.is_invincible = false
	
	bounce_point.global_position.x = global_position.x
	# find velocity and magnitude
	velocity = (global_position - last_position) / delta
	last_position = global_position
	head_magnitude = velocity.length()
	
	# set position of some nodes
	platform.global_position.y = bounce_point.global_position.y + platform_offset
	platform.global_position.x = global_position.x
	
	looking_for_ground_nodes.global_position = global_position
	
	# offset the bounce point if we are hovering the enemy over ground
	if is_grabbed or enemy.enemy_state == enemy.EnemyStates.STAND:
		bounce_point.global_position.y = global_position.y + bounce_position_offset
		has_changed_bounce_offset = true
	else:
		has_changed_bounce_offset = false
	
	# shadow for the enemy
	shadow.global_position.x = body_sprites.global_position.x
	if find_bounce_raycast.is_colliding() or ground_check.sees_object():
		find_shadow()
	else:
		shadow.visible = false
	
	if speed_hurt_box.monitoring:
		if speed_hurt_box.has_overlapping_bodies():
			if head_magnitude > squash_magnitude_threshold:
				squash_animation_player.play("squash")
			if head_magnitude > enemy.speed_damage_threshold:
				enemy_hurt_box.damage(1, head, false)
				if !enemy_hurt_box.health.is_invincible:
					CameraShake.add_trama(speed_damage_camera_shake_amount)
	
	if enemy.is_secret_ingredient and !enemy.is_in_box and !is_grabbed:
		put_ingredient_in_box()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if does_hang:
		linear_velocity += -rope_hang()
		rope.is_active = true
	else:
		rope.is_active = false
	
	match enemy.enemy_state:
		enemy.EnemyStates.RAGDOLL:
			if collides_with_ground:
				# bounce the ragdoll on the ground
				if stand_ground_check.sees_object():
					if head_magnitude > squash_magnitude_threshold:
						squash_animation_player.play("squash")
					if velocity.y > magnitude_threshold_to_bounce:
						if platform_check.sees_object():
							if head_magnitude > enemy.speed_damage_threshold:
								enemy_hurt_box.damage(1, head, false)
							if !enemy_hurt_box.health.is_invincible:
								CameraShake.add_trama(speed_damage_camera_shake_amount)
							bounce()
					# when stopped bouncing, set position to ground when hitting the ground
					if global_position.y >= bounce_point.global_position.y:
						global_position.y = bounce_point.global_position.y
						linear_velocity.y = 0
						apply_impulse(Vector2.UP * velocity.y * floor_bounce)
		enemy.EnemyStates.REBALANCE:
			head.set_collision_mask_value(3, false)
			head.set_collision_mask_value(7, false)
			# rotate back onto feet
			global_rotation = 0.0
			
			if rebalance_state.has_jumped:
				if global_position.y >= bounce_point.global_position.y:
					global_position.y = bounce_point.global_position.y
					linear_velocity.y = 0
		enemy.EnemyStates.STAND:
			head.set_collision_mask_value(3, false)
			head.set_collision_mask_value(7, false)
			# keep body inside the ground bounds
			keep_head_bounds()
			global_rotation = 0.0
			if !has_standed:
				linear_velocity.y = 0
				has_standed = true
		enemy.EnemyStates.STANDPLATFORM:
			global_rotation = 0.0
		enemy.EnemyStates.TRAPPED:
			set_collision_mask_value(11, true)
			set_collision_mask_value(1, false)
			enemy.can_be_grabbed = false
			
			if secret_box_area != null:
				box_bounds_bottom_left = secret_box_area.bottom_left_bounds_node.global_position
				box_bounds_top_right = secret_box_area.top_right_bounds_node.global_position
				
			keep_head_box_bounds()
	
	if is_grabbed:
		if stop_swinging_if_grabbed:
			does_hang = false
		shadow.visible = false
		if !has_grabbed:
			rotation_before_grabbed = global_rotation
			body_sprites_holder.scale = Vector2(default_size * grab_scale_amount, default_size * grab_scale_amount)
		has_grabbed = true
		grab()
	else:
		if has_grabbed:
			body_sprites_holder.scale = Vector2(default_size, default_size)
		has_grabbed = false
	
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
	
	# apply friction if enemy needs friction
	if enemy.enemy_movement.is_using_friction:
		linear_velocity *= enemy.enemy_movement.friction
	
	# for the avacado seed
	if cling_to_player:
		if player != null:
			global_position = player.hand_sprites.global_position
			global_rotation = player.hand_sprites.global_rotation


func rope_hang() -> Vector2:
	var axis: Vector2 = global_position - anchor_point.global_position
	var distance: float = axis.length()
	var direction: Vector2 = axis.normalized()
	
	if distance > rest_length:
		var swing_force: Vector2 = (direction * (1.0 - swing_friction)) + stiffness * direction * (distance - rest_length)
		return swing_force
	return Vector2.ZERO


func bounce() -> void:
	bounce_point_offset += bounce_point_offset
	bounce_point.global_position.y = bounce_point.global_position.y + bounce_point_offset


func grab() -> void:
	if hand != null:
		global_position = hand.global_position
		linear_velocity = Vector2.ZERO
		global_rotation = rotation_before_grabbed + hand.hand_sprites.global_rotation


func put_ingredient_in_box() -> void:
	if secret_area_detection.sees_object():
			secret_box_area = secret_area_detection.area
			secret_box_area.add_to_box(self)
			enemy.is_in_box = true


func find_shadow():
	var mid_point = (shadow_point.global_position + bounce_point.global_position) / 2
	if mid_point.y > find_bounce_raycast.get_collision_point().y:
		shadow.visible = true
		# keep the shadow position if we offset while the enemy is standing and move shadow
		if has_changed_bounce_offset:
			shadow.global_position.y = mid_point.y - (bounce_position_offset * 0.5)
		else:
			shadow.global_position.y = mid_point.y


func keep_head_bounds() -> void:
	if ground_check.sees_object():
		if ground_check.area != null:
			var ground: Ground = ground_check.area
			var top_right_bounds = ground.top_right_bounds
			var bottom_left_bounds = ground.bottom_left_bounds
			
			if global_position.y < top_right_bounds.y:
				global_position.y = top_right_bounds.y
			if !ground.can_fall_off_bottom:
				if global_position.y > bottom_left_bounds.y:
					global_position.y = bottom_left_bounds.y


func keep_head_box_bounds() -> void:
	if global_position.y < box_bounds_top_right.y:
		global_position.y = box_bounds_top_right.y
	if global_position.x > box_bounds_top_right.x:
		global_position.x = box_bounds_top_right.x
		
	if global_position.y > box_bounds_bottom_left.y:
		global_position.y = box_bounds_bottom_left.y
	if global_position.x < box_bounds_bottom_left.x:
		global_position.x = box_bounds_bottom_left.x
