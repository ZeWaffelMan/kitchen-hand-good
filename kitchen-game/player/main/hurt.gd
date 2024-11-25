extends State
class_name HurtHand


@export var player: Player
@export var player_health: PlayerHealth
@export var hand_animation_player: AnimationPlayer
@export var hand: PlayerHand

@export var max_stunned_time: float = 0.4
@onready var stunned_time: float = max_stunned_time


func enter_state() -> void:
	player.hand_state = player.HandStates.SPREAD
	hand_animation_player.play("spread")


func exit_state() -> void:
	stunned_time = max_stunned_time


func update_state(delta: float) -> void:
	if stunned_time > 0:
		stunned_time -= delta
	else:
		stunned_time = max_stunned_time
		transitioned.emit(self, "Normal")
