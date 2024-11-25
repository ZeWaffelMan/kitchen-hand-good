extends StaticBody2D
class_name PlayerHand


@export var mass: float = 4.0
@export var hand_sprites: Node2D
@export var hurt_box: PlayerHurtBox

@export_group("Bounds")
@export var top_cursor_bounds: Node2D
@export var bottom_cursor_bounds: Node2D

@export_group("Picking Up")
@export var object_detection: ObjectDetection

var grabbable_body: EnemyHead
var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO
var force: Vector2 = Vector2.ZERO
var friction: float = 0.92

@onready var last_position = global_position


func _process(delta: float) -> void:
	velocity = (global_position - last_position) / delta
	last_position = global_position
	
	bounds()
	
	if object_detection.sees_object():
		if object_detection != null:
			if object_detection.body is EnemyHead:
				grabbable_body = object_detection.body
		else:
			grabbable_body = null
	
	force *= friction
	
	acceleration = Vector2(force.x / mass, force.y / mass)
	global_position += acceleration * delta


func apply_force(amount, delta):
	force += amount / mass * delta


func apply_impulse(amount):
	force += amount / mass


func bounds() -> void:
	# make the hand so it doesn't leave the camera
	if global_position.x > top_cursor_bounds.global_position.x:
		global_position.x = top_cursor_bounds.global_position.x
	if global_position.y < top_cursor_bounds.global_position.y:
		global_position.y = top_cursor_bounds.global_position.y
	
	if global_position.x < bottom_cursor_bounds.global_position.x:
		global_position.x = bottom_cursor_bounds.global_position.x
	if global_position.y > bottom_cursor_bounds.global_position.y:
		global_position.y = bottom_cursor_bounds.global_position.y
