extends Area2D
class_name CustomButton


var is_lobby_button: bool = false
var is_checked = true

@export var checked_sprite: Sprite2D
@export var unchecked_sprite: Sprite2D


func _ready() -> void:
	if is_checked:
		checked_sprite.show()
		unchecked_sprite.hide()
	else:
		unchecked_sprite.show()
		checked_sprite.hide()


func press() -> void:
	if is_checked:
		checked_sprite.hide()
		unchecked_sprite.show()
		is_checked = false
	else:
		checked_sprite.show()
		unchecked_sprite.hide()
		is_checked = true
