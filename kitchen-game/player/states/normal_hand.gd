extends State
class_name NormalHand


@export var player: Player
@export var player_health: PlayerHealth
@export var hand_animation_player: AnimationPlayer

@export var grab_detection: ObjectDetection


func enter_state() -> void:
	player.hand_state = player.HandStates.POINT
	hand_animation_player.play("point")


func update_state(delta) -> void:
	if player_health.has_gotten_hurt:
		transitioned.emit(self, "Hurt")


func physics_update_state(delta) -> void:
	if player.using_mouse:
		if Input.is_action_just_pressed("left_click"):
			if grab_detection.sees_object():
				transitioned.emit(self, "GrabThrow")
		
		elif Input.is_action_pressed("right_click"):
			transitioned.emit(self, "Slap")
		
		if player.can_shockwave:
			if Input.is_action_pressed("left_click") and Input.is_action_pressed("right_click") or Input.is_action_pressed("shockwave"):
				transitioned.emit(self, "ShockWave")
	else:
		if Input.get_joy_axis(player.player_id, JOY_AXIS_TRIGGER_RIGHT):
			if grab_detection.sees_object():
				transitioned.emit(self, "GrabThrow")
		
		elif Input.get_joy_axis(player.player_id, JOY_AXIS_TRIGGER_LEFT):
			transitioned.emit(self, "Slap")
		
		if player.can_shockwave:
			if Input.is_joy_button_pressed(player.player_id, JOY_BUTTON_Y):
				transitioned.emit(self, "ShockWave")
