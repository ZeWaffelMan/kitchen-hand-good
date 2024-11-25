extends Node2D


var is_paused: bool = false
var is_fullscreen: bool = false


func _ready() -> void:
	set_settings()


func set_settings() -> void:
	Engine.time_scale = 1.0


func _process(delta) -> void:
	pause_game()
	if Input.is_action_just_pressed("tab"):
		epic_fullscreen()


func pause_game() -> void:
	if Input.is_action_just_pressed("pause"):
		if !is_paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			is_paused = true
	elif Input.is_action_just_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		is_paused = false


func epic_fullscreen() -> void:
	if !is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		is_fullscreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		is_fullscreen = false
