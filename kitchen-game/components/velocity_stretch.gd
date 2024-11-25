extends Node
class_name VelocityStretch


@export var stretch_rotate_to_default: bool = true

@export var stretch_amount: float = 1.1

@export var rotation_speed: float = 1.0
@export var stretch_speed: float = 1.0
@export var remove_stretch: float = 0.001
@export var stretch_threshold: float = 1.0

@export var object: Node2D
@export var reference_object: Node2D
@onready var object_velocity: Vector2 = Vector2.ZERO
@onready var last_object_position: Vector2 = Vector2.ZERO

@onready var default_scale: Vector2 = object.scale


func _process(delta) -> void:
	if object != null:
		# find the object's velocity
		if reference_object != null:
			object_velocity = (reference_object.global_position - last_object_position) / delta
			last_object_position = reference_object.global_position
		else:
			object_velocity = (object.global_position - last_object_position) / delta
			last_object_position = object.global_position
		
		# stretch and rotate the object towards that velocity if it reaches a certain threshold
		if object_velocity.length() > stretch_threshold:
			stretch(delta, stretch_amount)
			object.global_rotation = lerp_angle(object.global_rotation, object_velocity.angle(), rotation_speed * delta)
		elif stretch_rotate_to_default:
			if object.global_rotation != 0:
				object.global_rotation = lerp_angle(object.global_rotation, 0, rotation_speed * delta)
			if object.scale != default_scale:
				stretch(delta, default_scale.x)


func stretch(delta: float, amount: float) -> void:
	if object != null:
		object.scale.x = lerp(object.scale.x, object_velocity.length() * remove_stretch, stretch_speed * delta)
		object.scale.y = lerp(object.scale.y, -object_velocity.length() * remove_stretch, stretch_speed * delta)
		
		object.scale.x = clamp(object.scale.x, default_scale.x, amount)
		object.scale.y = clamp(object.scale.y, default_scale.x - amount + default_scale.x, default_scale.y)
