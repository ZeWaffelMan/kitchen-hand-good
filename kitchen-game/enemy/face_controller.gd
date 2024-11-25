extends Node
class_name FaceController


var can_blink: bool = true

var blink_timer: float = randf_range(3.5, 4.3)
@export var blink_animation: AnimationPlayer


func _process(delta) -> void:
	if can_blink:
		if blink_timer < 0:
			blink_animation.play("blink")
		else:
			blink_timer -= delta


func blink() -> void:
	blink_animation.play("blink")
	blink_timer = randf_range(3.5, 4.3)


func _on_blink_animation_player_animation_finished(anim_name) -> void:
	if anim_name != "RESET":
		blink_animation.play("RESET")
		blink_timer = randf_range(3.5, 4.3)
