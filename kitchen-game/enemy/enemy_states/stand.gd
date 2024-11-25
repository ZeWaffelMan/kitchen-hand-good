extends State
class_name EnemyStand


@export var enemy: Enemy
@export var head: EnemyHead
@export var ground_check: ObjectDetection

@export var magnitude_ragdoll_threshold: float = 100.0
@onready var default_gravity: float = head.gravity_scale

@export var animation_to_play: String = "neutral"
@export var mouth_animation_player: AnimationPlayer
@export var health: EnemyHealth
@export var movement: EnemyMovement

@onready var default_max_speed = head.max_speed

@export var stand_ground_check: ObjectDetection


func enter_state():
	if movement.uses_new_max_speed:
		head.max_speed = movement.movement_max_speed
	
	enemy.enemy_state = enemy.EnemyStates.STAND
	head.max_speed = enemy.enemy_movement.movement_max_speed
	head.physics_material_override.bounce = enemy.enemy_movement.new_bounciness
	
	mouth_animation_player.play(animation_to_play)
	head.gravity_scale = 0
	
	head.set_collision_mask_value(8, true)


func exit_state() -> void:
	head.max_speed = default_max_speed
	head.physics_material_override.bounce = enemy.enemy_movement.default_bounciness
	head.gravity_scale = default_gravity
	head.has_standed = false
	
	head.set_collision_mask_value(8, false)


func update_state(delta) -> void:
	# walk to the left for now
	head.apply_force(Vector2.RIGHT * 4000 * delta)
	
	if health.is_pushed or head.is_only_ragdoll:
		transitioned.emit(self, "Ragdoll")
	if head.is_grabbed:
		transitioned.emit(self, "Grabbed")
	
	if !stand_ground_check.sees_object():
		transitioned.emit(self, "Ragdoll")
