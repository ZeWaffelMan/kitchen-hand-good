extends Node2D


@export var main: Main

@export var sound_button: CustomButton

@export var music_button: ObjectDetection
@export var sound_effects_button: ObjectDetection

var music_muted: bool = false
var sound_effects_muted: bool = false
var can_unpause: bool = false



func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("pause"):
		can_unpause = true
	if Input.is_action_just_pressed("pause"):
		if can_unpause:
			unpause()
	
	if sound_button.is_checked:
		sound_effects_muted = true
	else:
		sound_effects_muted = false


func unpause() -> void:
	hide()
	main.is_paused = false
	can_unpause = false
	get_tree().paused = false
