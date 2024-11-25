extends Node


var effect: Resource
var effect_instance: Node2D


func create_effect(chosen_effect: Resource, color: Color) -> void:
	effect = chosen_effect
	
	effect_instance = effect.instantiate()
	get_tree().current_scene.add_child(effect_instance)
	effect_instance.modulate = color


func rotate_between(node_a: Vector2, node_b: Vector2, rotation_offset: float) -> void:
	if effect_instance != null:
		var mid_point: Vector2 = (node_a / 2) + (node_b / 2)
		var hit_direction: Vector2 = node_a - node_b
		var hit_angle: float = hit_direction.angle()
	
		effect_instance.global_position = mid_point
		effect_instance.global_rotation = hit_angle + deg_to_rad(rotation_offset)


func set_effect_position(target_position: Vector2) -> void:
	effect_instance.global_position = target_position


func direction_rotate(node_a: Node2D, node_b: Node2D, rotation_offset: float) -> void:
	var hit_direction = node_a.global_position - node_b.global_position
	hit_direction = hit_direction.normalized()
	var hit_angle = hit_direction.angle() + deg_to_rad(rotation_offset)
	effect_instance.global_rotation = hit_angle
