extends RigidBody2D
class_name EnemyHand


@onready var anchor_position: Vector2 = global_position

@export var second_point: Node2D

@export_group("Spring")
@export var max_distance: float = 100.0
@export var stiffness: float = 0.01
@export var damp: float = 0.99


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var axis: Vector2 = global_position - anchor_position
	var distance: float = axis.length()
	var direction: Vector2 = axis.normalized()
	
	# keep a max distance between the anchor and hand, then apply a sping force towards the anchor
	if distance > max_distance:
		global_position = anchor_position + (direction * max_distance)
	linear_velocity += (-axis * stiffness) - (damp * linear_velocity)
	
	if second_point != null:
		axis = global_position - second_point.global_position
		distance = axis.length()
		direction = axis.normalized()
		
		# keep a max distance between the anchor and hand, then apply a sping force towards the anchor
		if distance > max_distance:
			global_position = second_point.global_position + (direction * max_distance)
		linear_velocity += (-axis * stiffness) - (damp * linear_velocity)
