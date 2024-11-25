extends Node2D
class_name Map


enum MapStates{
	OPEN_MAP,
	READ_MAP,
	CLOSE_MAP,
}

var map_state = MapStates.OPEN_MAP

@onready var default_position: Vector2 = global_position
@export var new_position_node: Node2D
var is_active = false


func _process(delta: float) -> void:
	if is_active:
		match map_state:
			MapStates.OPEN_MAP:
				pull_out(delta)
				if global_position == new_position_node.global_position:
					map_state = MapStates.CLOSE_MAP
			MapStates.CLOSE_MAP:
				put_away(delta)
				if global_position == default_position:
					is_active = false
					map_state = MapStates.OPEN_MAP


func pull_out(delta) -> void:
	global_position = lerp(global_position, new_position_node.global_position, 30 * delta)


func put_away(delta) -> void:
	global_position = lerp(global_position, default_position, 30 * delta)
