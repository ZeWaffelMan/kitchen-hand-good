extends Node2D
class_name Transition


@export var world: World
@export var transition_animation_player: AnimationPlayer
@export var level_manager: LevelManager


enum TransitionStates{
	WAIT,
	PULL_UP,
	RESET,
	PUT_AWAY
}

var transition_state = TransitionStates.WAIT


var new_level: Level
var player: Player

var is_transitioning: bool = false

var level_to_set: Level


func _ready() -> void:
	player = world.player


func _process(delta: float) -> void:
	match transition_state:
		TransitionStates.WAIT:
			pass
		TransitionStates.PULL_UP:
			if !transition_animation_player.is_playing():
				transition_state = TransitionStates.RESET
		TransitionStates.RESET:
			# kill off remaining enemies if any
			var enemies = get_tree().get_nodes_in_group("enemy")
			for enemy in enemies:
				enemy.queue_free()
			
			# set the new level
			level_to_set.process_mode = PROCESS_MODE_INHERIT
			level_to_set.show()
			new_level = level_to_set
			level_manager.current_level.reset_level()
			
			# bring back the player
			player.health.health = player.health.max_health
			player.is_dead = false
			
			transition_state = TransitionStates.PUT_AWAY
		TransitionStates.PUT_AWAY:
			transition_animation_player.play("transition_close")
			is_transitioning = false
			transition_state = TransitionStates.WAIT



func transition_level(level: Level, animation: String, is_dead: bool):
	is_transitioning = true
	level_to_set = level
	transition_state = TransitionStates.PULL_UP
	transition_animation_player.play("transition_open")
