extends Node2D
class_name World


const MAX_PLAYERS: int = 2

var num_players: int = 0
var player_id: int = 0
var joined_with_mouse = false
var joined_with_controller = false

@onready var level_manager: LevelManager = $LevelManager
@export var transition_animation_player: AnimationPlayer

@export var players: Array[Player]
@export var player: Resource

@export var transition_controller: Transition
@export var lobby_level: Level
@export var battle_level: Level
@export var next_level: Level

var has_restarted: bool = false


func _physics_process(delta: float) -> void:
	if !joined_with_mouse:
		if Input.is_action_just_pressed("left_click"):
			add_new_player(0, num_players, true)
			num_players += 1
			joined_with_mouse = true
			GameStats.player_number += 1
	if !joined_with_controller:
		for i in MAX_PLAYERS:
			if Input.is_joy_known(i):
				if Input.is_joy_button_pressed(i, JOY_BUTTON_A):
					add_new_player(0, num_players, false)
					num_players += 1
					GameStats.player_number += 1
					joined_with_controller = true


func add_new_player(player_id, number, joined_with_mouse) -> void:
	if num_players < 2:
		var new_player: Player = player.instantiate()
		get_tree().current_scene.add_child(new_player)
		
		new_player.world = self
		
		new_player.global_position = Vector2(960, 500)
		new_player.player_id = player_id
		new_player.player_number = number
		new_player.using_mouse = joined_with_mouse
		new_player.player_number = number
		players.append(new_player)


func _process(delta: float) -> void:
	# only switch this on if it is in the player vs player room
	if level_manager.current_level == battle_level:
		AudioServer.set_bus_effect_enabled(1, 0, true)
	else:
		AudioServer.set_bus_effect_enabled(1, 0, false)
	
	var all_players_dead = true
	if players != null:
		for player in players:
			if player != null:
				if !player.is_dead:
					all_players_dead = false
					break
	
	if len(players) != 0:
		if all_players_dead:
			if all_players_dead and !has_restarted:
				level_manager.switch_to_new_level(lobby_level, level_manager.current_level, "to_lobby")
				all_players_dead = false
				has_restarted = true
