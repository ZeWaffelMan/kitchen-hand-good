extends Node2D
class_name Blood


@export var blood_particle: Resource
@export var destroy_time = 3.0

var particles: Array[Node2D]
var blood_instance: Node2D
@export var emit_on_start: bool = false
@export var has_upwards_force = true
@export var random_force_range: float = 500
@export var has_destroy_time: float = true


func _ready() -> void:
	if emit_on_start:
		squirt(10, random_force_range, "ffffff")


func _process(delta) -> void:
	# destroy after amount of time
	if has_destroy_time:
		if destroy_time > 0.0:
			destroy_time -= delta
		else:
			queue_free()


func squirt(amount, force, color) -> void:
	for n in amount:
		create_blood_particle(color)
		force = randf_range(-700, 750)
		# random force for the blood
		var random_x = randf_range(1, 4)
		var random_y = randf_range(-1, 6)
		blood_instance.apply_impulse(Vector2(force * random_x, force * random_y))
		
		# get the blood to go up
		if has_upwards_force:
			random_y = randf_range(-700 * 3, -950 * 3)
			blood_instance.apply_impulse(Vector2(0, random_y))


func create_blood_particle(color) -> void:
	blood_instance = blood_particle.instantiate()
	
	add_child.call_deferred(blood_instance)
	blood_instance.global_position = global_position
	blood_instance.modulate = color
	particles.append(blood_instance)
