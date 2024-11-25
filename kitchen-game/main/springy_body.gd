extends RigidBody2D
class_name EnemyHand


@export var point: Resource
@export var node_to_attach_to: Node2D
var anchor: Node2D

@export_group("Spring")
@export var max_distance: float = 10.0

@export var min_stiffness: float = 5.0
@export var max_stiffness: float = 15.0
var random_stiffness: float

@export var min_damp: float = 0.1
@export var max_damp: float = 0.4
var random_damp: float


func _ready() -> void:
	randomize()
	anchor = point.instantiate()
	node_to_attach_to.add_child(anchor)
	anchor.global_position = global_position


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	random_stiffness = randf_range(min_stiffness, max_stiffness)
	random_damp = randf_range(min_damp, max_damp)
	
	var axis: Vector2 = global_position - anchor.global_position
	var distance: float = axis.length()
	var direction: Vector2 = axis.normalized()
	
	# keep a max distance between the anchor and hand, then apply a sping force towards the anchor
	if distance > max_distance:
		global_position = anchor.global_position + (direction * max_distance)
	linear_velocity += (-axis * random_stiffness) - (random_damp * linear_velocity)
