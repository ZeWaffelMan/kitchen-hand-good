extends Node
class_name RotateTowardsVelocity


@export var active: bool = true

@export var destination_object: Node2D
@export var object: Node2D

@export var node_speed: float = 1.0
@export var move_threshold: float = 2.5
@export var max_travel_distance: float = 3.0

var destination: Vector2 = Vector2.ZERO

var object_velocity: Vector2 = Vector2.ZERO
var object_magnitude: float = 0.0
@onready var last_object_position: Vector2 = object.global_position


func _ready() -> void:
	last_object_position = Vector2.ZERO


func _process(delta) -> void:
	# find objects velocity
	object_velocity = (destination_object.global_position - last_object_position) / delta
	last_object_position = object.global_position
	
	object_magnitude = object_velocity.length()
	
	if active:
		move_object(delta, destination)


func move_object(delta: float, destination: Vector2) -> void:
	# set the destination somewhere ahead of the object if he hit the threshold or set to default position if not
	if object_magnitude > move_threshold:
		destination = lerp(destination_object.global_position, object.global_position + object_velocity * max_travel_distance, object_velocity.length() * 30 * delta)
	else:
		destination = lerp(destination_object.global_position, object.global_position, 0.0 * delta)
	
	# give the destination a max distance away from the object
	destination.x = clampf(destination.x, -max_travel_distance + destination_object.global_position.x, max_travel_distance + destination_object.global_position.x)
	destination.y = clampf(destination.y, -max_travel_distance + destination_object.global_position.y, max_travel_distance + destination_object.global_position.y)
	
	# move the object to the destination
	object.global_position = lerp(object.global_position, destination, node_speed * delta)
