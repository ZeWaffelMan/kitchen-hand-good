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

@export var world: Node2D

@export var current_level: Level
@export var levels: Array[Resource]
var level_index: int = 0

@export_group("Secret Ingredient")
@onready var secret_ingredient_spawn_area: Node2D = current_level.secret_ingredient_spawn_area
@onready var secret_ingredient: Resource = current_level.secret_ingredient_to_spawn
var secret_ingredient_instance: Enemy

@export_group("Secret Area")
@export var secret_area: SecretArea
@export var secret_box: Node2D
@export var secret_area_new_offset: Node2D
@export var secret_box_expose_speed: float = 30.0
@onready var secret_box_default_position = secret_box.global_position

@export_group("Map")
@export var map: Map


func _process(delta):
	# check if there are players to start the level
	if !check_if_player_dead():
		current_level.is_active = true
	else:
		current_level.is_active = false
	
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
				map.is_active = true
		LevelStates.WAIT_FOR_MAP:
			hide_secret_area(delta)
			if !map.is_active:
				secret_ingredient_instance.queue_free()
				secret_area.has_collected_ingredient = false
				level_state = LevelStates.SET_NEW_LEVEL
		LevelStates.SET_NEW_LEVEL:
			switch_to_new_level()


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
	if secret_ingredient != null and secret_ingredient_spawn_area != null:
		secret_ingredient_instance = secret_ingredient.instantiate()
		secret_ingredient_instance.global_position = secret_ingredient_spawn_area.global_position
		get_tree().current_scene.add_child(secret_ingredient_instance)
	else:
		print_debug("can't find secret ingredient or spawn area for secret ingredient")


func switch_to_new_level() -> void:
	if current_level != null:
		if level_index < len(levels):
			current_level.queue_free()
			
			var new_level: Level = levels[level_index].instantiate()
			level_index += 1
			world.add_child(new_level)
			new_level.global_position = Vector2.ZERO
			
			current_level = new_level
			secret_ingredient_spawn_area = current_level.secret_ingredient_spawn_area
			
			level_state = LevelStates.WAIT
		else:
			print("beat the last level!")
