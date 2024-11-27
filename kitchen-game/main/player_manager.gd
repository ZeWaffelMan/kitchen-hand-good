extends Node2D


@export var player: Resource
var mouse_has_joined: bool = false
var added_players: Array[int]


func _physics_process(delta: float) -> void:
	if GameStats.player_number != GameStats.MAX_PLAYERS:
		for i in GameStats.MAX_PLAYERS:
			if Input.is_joy_known(i):
				if i not in added_players:
					if Input.is_joy_button_pressed(i, JOY_BUTTON_A):
						added_players.append(i)
						add_new_player(GameStats.player_id, GameStats.player_number, false)
						GameStats.player_id += 1
						GameStats.player_number += 1
		if !mouse_has_joined:
			if Input.is_action_just_pressed("left_click"):
				add_new_player(5, GameStats.player_number, true)
				mouse_has_joined = true
				GameStats.player_number += 1


func add_new_player(player_id, number, joined_with_mouse) -> void:
	var new_player: Player = player.instantiate()
	get_tree().root.add_child(new_player)
	
	new_player.global_position = global_position
	new_player.player_id = player_id
	new_player.using_mouse = joined_with_mouse
	new_player.player_number = number
	
