extends Area2D
class_name CustomButton


@export var click_sound: AudioStreamPlayer

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
		click_sound.play()
		click_sound.pitch_scale = Sound.random_pitch(0.9, 1.1)
		checked_sprite.hide()
		unchecked_sprite.show()
		is_checked = false
	else:
		click_sound.play()
		click_sound.pitch_scale = Sound.random_pitch(0.9, 1.1)
		checked_sprite.show()
		unchecked_sprite.hide()
		is_checked = true
