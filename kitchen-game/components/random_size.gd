extends Node
class_name RandomSize


@export var set_size_node: Node2D

@export_category("Values")
@export var size_min: float = 0.2
@export var size_max: float = 0.35

@export_category("Extra")
@export var velocity_stretch_node: VelocityStretch


func _ready() -> void:
	randomize_size()


func randomize_size() -> void:
	# find the random size
	var random_size = randf_range(size_min, size_max)
	
	# set the size
	set_size_node.scale.x = random_size
	set_size_node.scale.y = random_size
	
	if velocity_stretch_node != null:
		velocity_stretch_node.stretch_amount = random_size + velocity_stretch_node.stretch_amount
		velocity_stretch_node.default_scale.x = random_size
		velocity_stretch_node.default_scale.y = random_size
