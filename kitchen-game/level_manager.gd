extends Node2D
class_name LevelManager


enum LevelStates{
	NOT_ACTIVE,
	WAIT,
	EXPOSE_SECRET,
	WAIT_FOR_MAP,
	SET_NEW_LEVEL,
}

var level_state = LevelStates.NOT_ACTIVE

@export var world: World

@export var current_level: Level

@export_group("Secret Ingredient")
@onready var secret_ingredient_spawn_area: Node2D = current_level.secret_ingredient_spawn_area
@onready var secret_ingredient: Resource = current_level.secret_ingredient_to_spawn
var secret_ingredient_instance: Enemy

@export_group("Secret Area")
@export var secret_area: SecretArea
@export var secret_box: Node2D
@export var secret_area_new_offset: Node2D
@export var secret_box_expose_speed: float = 15.0
@onready var secret_box_default_position = secret_box.global_position

@export_group("Map")
@export var transition: Transition

var has_checked_to_start: bool = false
var has_switched_level: bool = false
@onready var old_level: Level = current_level
@export var point_to_travel_to: Node2D


func _ready() -> void:
	current_level.show()
	current_level.is_active = true
	current_level.process_mode = PROCESS_MODE_INHERIT


func _physics_process(delta: float) -> void:
	if current_level != world.lobby_level:
		if Input.is_action_just_pressed("lobby_button"):
			switch_to_new_level(world.lobby_level, current_level, "to_lobby")


func _process(delta):
	if !current_level.is_lobby_level:
		match level_state:
			LevelStates.WAIT:
				#expose the secret if the level is finished
				if current_level != null:
					if current_level.is_finished:
						level_state = LevelStates.EXPOSE_SECRET
			LevelStates.EXPOSE_SECRET:
				if check_if_dead():
					spawn_secret_ingrediant()
				# collect the ingredient and switch to the map if is collected
				if !secret_area.has_collected_ingredient:
					if secret_ingredient_instance != null:
						expose_secret_area(delta)
				else:
					secret_area.has_collected_ingredient = true
					level_state = LevelStates.WAIT_FOR_MAP
			LevelStates.WAIT_FOR_MAP:
				if !has_switched_level:
					switch_to_new_level(current_level.next_level, current_level, current_level.next_level_animation)
					has_switched_level = true
				if !transition.is_transitioning:
					hide_secret_area(delta)
					secret_area.has_collected_ingredient = false
					level_state = LevelStates.WAIT
					has_switched_level = false


func check_if_dead() -> bool:
	if get_tree().get_nodes_in_group("enemy").is_empty():
		return true
	else:
		return false


func check_if_player_dead() -> bool:
	if get_tree().get_nodes_in_group("player").is_empty():
		return true
	else:
		return false


func expose_secret_area(delta) -> void:
	secret_box.global_position = lerp(secret_box.global_position, secret_area_new_offset.global_position, secret_box_expose_speed * delta)


func hide_secret_area(delta) -> void:
	secret_box.global_position = lerp(secret_box.global_position, secret_box_default_position, secret_box_expose_speed * delta)


func spawn_secret_ingrediant() -> void:
	if current_level.secret_ingredient_to_spawn != null and current_level.secret_ingredient_spawn_area != null:
		secret_ingredient_instance = current_level.secret_ingredient_to_spawn.instantiate()
		secret_ingredient_instance.global_position = current_level.secret_ingredient_spawn_area.global_position
		get_tree().current_scene.add_child(secret_ingredient_instance)
	else:
		print_debug("can't find secret ingredient or spawn area for secret ingredient")


func switch_to_new_level(level_to_switch_to: Level, old_level: Level, map_animation_to_play: String) -> void:
	if current_level != null:
		transition.transition_level(level_to_switch_to, old_level, map_animation_to_play)
		print("transition")
		
		level_to_switch_to.global_position = Vector2.ZERO
		
		current_level = level_to_switch_to
		secret_ingredient_spawn_area = current_level.secret_ingredient_spawn_area
		
		has_checked_to_start = false
