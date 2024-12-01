extends Area2D
class_name CustomButton


var is_lobby_button: bool = false
var is_checked = true


func press() -> void:
	if is_checked:
		print("off")
		is_checked = false
	else:
		print("on")
		is_checked = true
