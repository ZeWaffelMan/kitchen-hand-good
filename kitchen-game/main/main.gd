extends Node2D


@onready var pause_menu = $PauseMenu

var is_paused: bool = false
var is_fullscreen: bool = false


func _ready() -> void:
	set_settings()


func set_settings() -> void:
	Engine.time_scale = 1.0


func _physics_process(delta: float) -> void:
	if is_paused:
		if Input.is_action_just_pressed("pause"):
			unpause()
	else:
		if Input.is_action_just_pressed("pause"):
			pause()
	if Input.is_action_just_pressed("tab"):
		epic_fullscreen()
	
	if !is_paused:
		if Input.is_action_just_pressed("left_click"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func pause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_menu.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	is_paused = true
	get_tree().paused = true


func unpause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pause_menu.hide()
	is_paused = false
	Engine.time_scale = 0
	get_tree().paused = false


func epic_fullscreen() -> void:
	if !is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		is_fullscreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		is_fullscreen = false
