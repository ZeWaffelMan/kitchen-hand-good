extends Area2D
class_name SecretArea


var ingredient_counter: int = 0
var has_collected_ingredient: bool = false

@export var top_right_bounds_node: Node2D
@export var bottom_left_bounds_node: Node2D

@onready var top_right_bounds: Vector2 = top_right_bounds_node.global_position
@onready var bottom_left_bounds: Vector2 = bottom_left_bounds_node.global_position


func add_to_box(enemy_head: EnemyHead) -> void:
	enemy_head.box_bounds_top_right = top_right_bounds
	enemy_head.box_bounds_bottom_left = bottom_left_bounds
	has_collected_ingredient = true
