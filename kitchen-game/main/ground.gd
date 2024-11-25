extends Area2D
class_name Ground


@export var top_right_bounds_node: Node2D
@export var bottom_left_bounds_node: Node2D
@export var can_fall_off_bottom: bool = false

@onready var top_right_bounds: Vector2 = top_right_bounds_node.global_position
@onready var bottom_left_bounds: Vector2 = bottom_left_bounds_node.global_position
