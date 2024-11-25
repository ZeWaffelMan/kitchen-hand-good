extends Node2D
class_name HandEcho


@export var hand_type_animation_player: AnimationPlayer

enum HandTypes {
	POINT,
	GRAB,
	SLAP,
}

var hand_state = HandTypes.POINT


func _process(delta: float) -> void:
	match hand_state:
		HandTypes.POINT:
			hand_type_animation_player.play("point")
		HandTypes.GRAB:
			hand_type_animation_player.play("grab")
		HandTypes.SLAP:
			hand_type_animation_player.play("slap")
