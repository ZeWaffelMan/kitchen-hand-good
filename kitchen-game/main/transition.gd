extends Node2D
class_name Transition


@export var hand_waddle: AudioStreamPlayer
@export var transition_in_sound: AudioStreamPlayer
@export var transition_out_sound: AudioStreamPlayer

@export var music_target_volume: float = -0.0

@export var world: World
@export var transition_animation_player: AnimationPlayer
@export var level_manager: LevelManager

@export var secret_box: StaticBody2D
@onready var secret_area_default_pos = secret_box.global_position

@onready var old_level: Level = level_manager.current_level

@export var jiggle_animation_player: AnimationPlayer
@export var move_to_animation_player: AnimationPlayer


enum TransitionStates{
	WAIT,
	PULL_UP,
	RESET,
	MOVE_MAP,
	PUT_AWAY
}

var transition_state = TransitionStates.WAIT

var new_level: Level
var is_transitioning: bool = false
var level_to_set: Level
var animation_to_play: String = ""

var has_started_traveling: bool = false

@export var max_time_to_pull_up: float = 1.5
@export var max_time_to_travel: float = 1.5
@export var max_done_travel_switch_time: float = 1.5
@onready var switch_time = max_time_to_pull_up

var has_opened_map = false


func _ready() -> void:
	level_manager.current_level.music.volume_db = music_target_volume
	level_manager.current_level.music.play()


func _process(delta: float) -> void:
	match transition_state:
		TransitionStates.WAIT:
			switch_time = max_time_to_pull_up
		TransitionStates.PULL_UP:
			old_level.music.volume_db = lerpf(old_level.music.volume_db, -80, 1 * delta)
			if switch_time > 0:
				has_opened_map = false
				switch_time -= delta
			else:
				if !has_opened_map:
					transition_in_sound.play()
					transition_animation_player.play("transition_open")
				has_opened_map = true
				move_to_animation_player.play(animation_to_play)
				if !transition_animation_player.is_playing():
					switch_time = max_time_to_pull_up
					transition_state = TransitionStates.RESET
		TransitionStates.RESET:
			set_levels()
			reset_players()
			
			transition_state = TransitionStates.MOVE_MAP
			switch_time = max_done_travel_switch_time
		TransitionStates.MOVE_MAP:
			if !has_started_traveling:
				jiggle_animation_player.play("hand_move")
				has_started_traveling = true
			else:
				if !hand_waddle.playing:
					hand_waddle.play()
					hand_waddle.pitch_scale = Sound.random_pitch(0.8, 1.2)
			
			if !move_to_animation_player.is_playing():
				jiggle_animation_player.play("RESET")
				has_started_traveling = false
				if switch_time > 0:
					switch_time -= delta
				else:
					transition_state = TransitionStates.PUT_AWAY
		TransitionStates.PUT_AWAY:
			transition_out_sound.play()
			
			level_to_set.is_active = true
			level_to_set.music.play()
			level_to_set.music.volume_db = music_target_volume
			transition_animation_player.play("transition_close")
			world.has_restarted = false
			is_transitioning = false
			transition_state = TransitionStates.WAIT


func set_levels() -> void:
	# kill off remaining enemies if any
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()
	
	# disable the old level      
	old_level.reset_level() 
	old_level.hide()
	old_level.process_mode = PROCESS_MODE_DISABLED
	
	# set the new level
	level_manager.level_state = level_manager.LevelStates.WAIT
	level_to_set.process_mode = PROCESS_MODE_INHERIT
	level_to_set.show()
	
	new_level = level_to_set
	level_manager.current_level.reset_level()
	secret_box.global_position = secret_area_default_pos


func reset_players() -> void:
	# bring back the player
	for player in world.players:
		player.health.health = player.health.max_health
		player.is_dead = false
		player.show()
		player.process_mode = PROCESS_MODE_ALWAYS


func transition_level(level: Level, old: Level, animation: String):
	old_level = old
	animation_to_play = animation
	is_transitioning = true
	level_to_set = level
	transition_state = TransitionStates.PULL_UP
