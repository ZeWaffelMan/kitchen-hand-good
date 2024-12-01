extends Node


@export var select_area: Area2D


func _physics_process(delta: float) -> void:
	if select_area.has_overlapping_areas():
		var areas = select_area.get_overlapping_areas()
		if Input.is_action_just_pressed("left_click"):
			for button in areas:
				if button is CustomButton:
					button.press()
