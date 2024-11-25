extends Node2D
class_name Player


@export var max_slap_cooldown: float = 0.5
@onready var slap_cooldown = max_slap_cooldown

var player_id: int = 0
var player_number: int = 0
var using_mouse: bool = false

var can_shockwave: bool = true
var can_slap: bool = true

@export var grab_throw_state: GrabHand
var changed_throw_force: bool = false

@export var player_type_animation_player: AnimationPlayer


enum HandStates{
	POINT,
	GRAB,
	SLAP,
	SPREAD,
}

var hand_state = HandStates.POINT


func _ready() -> void:
	player_id = GameStats.player_id
	player_number = GameStats.player_number
	
	if player_number == 0:
		player_type_animation_player.play("player1")
	elif player_number == 1:
		player_type_animation_player.play("player2")
	elif player_number == 2:
		player_type_animation_player.play("player3")
	elif player_number == 3:
		player_type_animation_player.play("player4")


func _process(delta: float) -> void:
	if !changed_throw_force:
		if !using_mouse:
			grab_throw_state.hand_release_force = grab_throw_state.hand_release_force * 2.0
		changed_throw_force = true
	
	if slap_cooldown > 0:
		can_slap = false
		slap_cooldown -= delta
	else:
		can_slap = true
