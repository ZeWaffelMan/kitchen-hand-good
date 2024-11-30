extends State
class_name GrabHand


@export_group("Picking Up")
@export var object_detection: ObjectDetection
var is_holding: bool = false

var grabbed_body: EnemyHead

@export_group("Throw")
@export var hand_release_force: float = 2.3

@export var player_hand: PlayerHand
@export var hand_animation_player: AnimationPlayer

@export var player: Player
@export var player_health: PlayerHealth


func enter_state() -> void:
	# grab the body if it isn't grabbed already
	if player_hand.grabbable_body != null:
		if !player_hand.grabbable_body.is_grabbed and player_hand.grabbable_body.enemy.can_be_grabbed:
			hand_animation_player.play("grab")
			player.hand_state = player.HandStates.GRAB
			grabbed_body = player_hand.grabbable_body
			grabbed_body.hand = player_hand
			grabbed_body.is_grabbed = true
	is_holding = true


func exit_state() -> void:
	if grabbed_body != null:
		grabbed_body.hand = null
		grabbed_body.is_grabbed = false
	grabbed_body = null


func update_state(delta) -> void:
	if player_health.has_gotten_hurt:
		transitioned.emit(self, "Hurt")


func physics_update_state(delta: float) -> void:
	if player.can_shockwave:
		if player.using_mouse:
			if Input.is_action_pressed("left_click") and Input.is_action_pressed("right_click") or Input.is_action_pressed("shockwave"):
				transitioned.emit(self, "ShockWave")
		else:
			if Input.is_joy_button_pressed(player.player_id, JOY_BUTTON_Y):
				transitioned.emit(self, "ShockWave")
	pick_up(delta)


func pick_up(delta) -> void:
	if player.using_mouse:
		if Input.is_action_just_released("left_click"):
			if is_holding:
				is_holding = false
	else:
		if !Input.get_joy_axis(player.player_id, JOY_AXIS_TRIGGER_RIGHT):
			if is_holding:
				is_holding = false
		
	if !is_holding:
		if !grabbed_body.inside_wall_check.sees_object():
			if grabbed_body != null:
				grabbed_body.is_grabbed = false
				is_holding = false
				
				grabbed_body.apply_impulse(player_hand.velocity * hand_release_force)
			transitioned.emit(self, "Normal")
	if grabbed_body == null:
		transitioned.emit(self, "Normal")
