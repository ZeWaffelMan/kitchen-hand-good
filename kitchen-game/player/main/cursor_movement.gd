extends Node
class_name CursorMovement


@export var max_speed: float = 50.0
@export var max_controller_speed: float = 70.0
@onready var default_max_speed: float = max_speed

@export var hand: PlayerHand
@export var player_gradiant: Node2D

@export_group("Effects")
@export var echo_effect: Resource

@export_group("Movement")
@export var cursor_speed: float = 1.8

@export var controller_default_speed: float = 2.5
@export var controller_speed_button_speed: float = 3.0
@onready var controller_speed: float = controller_default_speed

@export var mouse_sensitivity: float = 0.5:
	set(value):
		mouse_sensitivity = clampf(mouse_sensitivity, 0.1, 1.0)
@export var controller_sensitivity: float = 0.5:
	set(value):
		controller_sensitivity = clampf(controller_sensitivity, 0.1, 1.0)

@export_group("References")
@export var cursor: StaticBody2D
@export var point: Node2D
var destination: Vector2 = Vector2.ZERO

var head_velocity: Vector2 = Vector2.ZERO
var cursor_velocity: Vector2 = Vector2.ZERO
var last_cursor_position: Vector2 = Vector2.ZERO

var is_moving_mouse: bool = false
var mouse_movement: Vector2 = Vector2.ZERO
var last_mouse_movement: Vector2 = Vector2.ZERO

@onready var initial_cursor_speed: float = cursor_speed

@export_group("Hand Echo Effect")
@export var hand_echo_magnitude_threshold = 300.0
@export var max_echo_effect_time: float = 0.05
@onready var echo_effect_time: float = max_echo_effect_time

@export var player: Player
@export var hand_sprite: Node2D


func _ready() -> void:
	destination = cursor.global_position
	last_cursor_position = cursor.global_position
	point.visible = false


func _input(event) -> void:
	if Engine.time_scale > 0.1:
		if player.using_mouse:
			# cursor movement
			if event is InputEventMouseMotion:
				var mouse = event.relative
				mouse_movement = Vector2(mouse.x, mouse.y) * mouse_sensitivity
				is_moving_mouse = true
				
				if mouse_movement.length() >= max_speed:
					mouse_movement = clamp(mouse_movement.normalized() * max_speed, Vector2(-max_speed, -max_speed), Vector2(max_speed, max_speed))
				
				# find the drag of the object
				if cursor_velocity.length() > max_speed:
					cursor_velocity = cursor_velocity.normalized() * max_speed
				
				var new_position = cursor.position + Vector2(mouse_movement.x, mouse_movement.y) * cursor_speed
				cursor.position = new_position


func _process(delta) -> void:
	if echo_effect_time > 0:
		echo_effect_time -= delta
	else:
		if hand.velocity.length() > hand_echo_magnitude_threshold:
			create_echo_effect()
	
	if Engine.time_scale > 0.1:
		if player.using_mouse:
			mouse_cursor(delta)
		else:
			controller_cursor(delta)


func create_echo_effect() -> void:
	var echo_instance: HandEcho = echo_effect.instantiate()
	get_tree().current_scene.add_child(echo_instance)
	
	echo_instance.hand_state = player.hand_state
	echo_instance.global_position = hand_sprite.global_position
	echo_instance.global_rotation = hand_sprite.global_rotation
	echo_instance.modulate = player_gradiant.modulate
	
	echo_effect_time = max_echo_effect_time


func controller_cursor(delta: float) -> void:
	var input_vector = Vector2.ZERO
	
	if Input.get_joy_axis(player.player_id, JOY_AXIS_LEFT_X) or Input.get_joy_axis(player.player_id, JOY_AXIS_LEFT_X):
		input_vector.x = Input.get_action_raw_strength("stick_right") - Input.get_action_raw_strength("stick_left")
		input_vector.y = Input.get_action_raw_strength("stick_down") - Input.get_action_raw_strength("stick_up")
		
		if Input.is_joy_button_pressed(player.player_id, JOY_BUTTON_X):
			controller_speed = controller_speed_button_speed
		else:
			controller_speed = controller_default_speed
		
		if input_vector.length() > 0.5:
			mouse_movement = Vector2(input_vector.x, input_vector.y) * controller_sensitivity * 50
			
			if mouse_movement.length() >= max_controller_speed:
				mouse_movement = clamp(mouse_movement.normalized() * max_controller_speed, Vector2(-max_controller_speed, -max_controller_speed), Vector2(max_controller_speed, max_controller_speed))
			# find the drag of the object
			if cursor_velocity.length() > max_speed:
				cursor_velocity = cursor_velocity.normalized() * max_speed
			
			var new_position = cursor.position + Vector2(mouse_movement.x, mouse_movement.y) * controller_speed * delta * 60
			cursor.position = new_position


func mouse_cursor(delta: float) -> void:
	# find velocities for the cursor and head
	cursor_velocity = (cursor.global_position - last_cursor_position) / delta
	last_cursor_position = cursor.global_position
	
	# check to see if the mouse isn't moving
	if last_mouse_movement == mouse_movement and is_moving_mouse == true:
		is_moving_mouse = false
	last_mouse_movement = mouse_movement
