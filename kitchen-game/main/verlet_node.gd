extends Node2D
class_name VerletNode


@export var friction: float = 0.8
@export var object_gravity: Vector2 = Vector2(0, 10)
@export var mass: float = 1.0
@export var max_speed: float = 7000.0

@export var drag: float = 0.0

var force: Vector2 = Vector2.ZERO

var last_position: Vector2
var velocity: Vector2
var magnitude: float


func _ready() -> void:
	last_position = global_position


func _physics_process(delta) -> void:
	update_point(delta)


func update_point(delta: float) -> void:
	# find velocity
	velocity = (global_position - last_position) / delta
	last_position = global_position
	magnitude = velocity.length()
	drag = magnitude * 0.000001
	
	# find the drag of the object
	var drag_force = drag * velocity
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	# verlet integration
	global_position += (velocity - drag_force + force + (object_gravity * mass) * friction) * delta
	force = Vector2.ZERO


func apply_impulse(amount: Vector2) -> void:
	force += amount / mass

func apply_force(delta: float, amount: Vector2) -> void:
	force += amount / mass * delta
