extends Node2D


@onready var level_manager: LevelManager = $LevelManager
@export var transition_animation_player: AnimationPlayer


#func add_new_player(player_id, number, joined_with_mouse) -> void:
	#var new_player: Player = player.instantiate()
	#get_tree().current_scene.add_child(new_player)
	#
	#new_player.global_position = global_position
	#new_player.player_id = player_id
	#new_player.using_mouse = joined_with_mouse
	#new_player.player_number = number
	#


func _process(delta: float) -> void:
	if level_manager.current_level.is_active:
		if check_if_player_dead():
			start_over()


func start_over():
	transition_animation_player.play("transition_close")
	#if !transition_animation_player.is_playing():
	var world =get_tree().current_scene.get_node("World")
	print("you died. go again!")


func check_if_player_dead() -> bool:
	#print(get_tree().get_nodes_in_group("player"))
	if get_tree().get_nodes_in_group("player").is_empty():
		return true
	else:
		return false
