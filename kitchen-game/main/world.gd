extends Node2D
class_name World


var num_players: int = 0
var player_id: int = 0
var joined_with_mouse = false

@onready var level_manager: LevelManager = $LevelManager
@export var transition_animation_player: AnimationPlayer

@export var players: Array[Player]
@export var player: Resource

@export var transition_controller: Transition
@export var lobby_level: Level
@export var next_level: Level

var has_restarted: bool = false


func _physics_process(delta: float) -> void:
	if !joined_with_mouse:
		if Input.is_action_just_pressed("left_click"):
			add_new_player(num_players, num_players, true)
			joined_with_mouse = true
	else:
		if level_manager.current_level.is_lobby_level:
			if Input.is_action_just_pressed("left_click"):
				level_manager.switch_to_new_level(next_level, lobby_level, "lobby_to_counter")


func add_new_player(player_id, number, joined_with_mouse) -> void:
	if num_players < 2:
		var new_player: Player = player.instantiate()
		get_tree().current_scene.add_child(new_player)
		
		new_player.global_position = Vector2(960, 500)
		new_player.player_id = player_id
		new_player.using_mouse = joined_with_mouse
		new_player.player_number = number
		players.append(new_player)
		num_players += 1


func _process(delta: float) -> void:
	var all_players_dead = true
	if players != null:
		for player in players:
			if player != null:
				if not player.is_dead:
					all_players_dead = false
					break
			
			if all_players_dead and !has_restarted:
				level_manager.switch_to_new_level(lobby_level, level_manager.current_level, "to_lobby")
				all_players_dead = false
				has_restarted = true
