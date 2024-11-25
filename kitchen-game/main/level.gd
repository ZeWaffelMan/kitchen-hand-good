extends Node2D
class_name Level


enum LevelStates{
	WAIT,
	SPAWN,
	WAIT_TO_END,
}

var level_state = LevelStates.WAIT

@export var is_active: bool = true
@export var is_finished: bool = false

@export_group("Secret Ingredient")
@export var secret_ingredient_spawn_area: Node2D
@export var secret_ingredient_to_spawn: Resource

@export_group("Spawning")
@export var enemy_spawn_points: Array[Node2D]
@export var enemy_air_spawn_point_1: Node2D
@export var enemy_air_spawn_point_2: Node2D

@export var enemy_spawners_to_spawn: Array[Resource]
@export var max_next_spawner_time: float = 0.9
@export var min_next_spawner_time: float = 0.9
@onready var next_spawner_time = 0
var spawners_created: Array[Node]
var enemy_spawn_level: int = 0

@export var max_destroy_spawners_timer: float = 2.0
@onready var destroy_spawners_timer: float = max_destroy_spawners_timer


func _process(delta):
	if is_active:
		match level_state:
			LevelStates.WAIT:
				level_state = LevelStates.SPAWN
			LevelStates.SPAWN:
				if next_spawner_time > 0:
					next_spawner_time -= delta
				else:
					if enemy_spawners_to_spawn != null and enemy_spawn_level < len(enemy_spawners_to_spawn):
						spawn(enemy_spawners_to_spawn[enemy_spawn_level])
						enemy_spawn_level += 1
						next_spawner_time = randf_range(min_next_spawner_time, max_next_spawner_time)
					else:
						level_state = LevelStates.WAIT_TO_END
			LevelStates.WAIT_TO_END:
				if enemy_spawners_to_spawn != null and enemy_spawn_level >= len(enemy_spawners_to_spawn):
					if destroy_spawners_timer > 0:
						destroy_spawners_timer -= delta
					else:
						destroy_all_spawners()
						is_finished = true


func destroy_all_spawners() -> void:
			for spawner in spawners_created:
				if spawner != null:
					spawner.queue_free()


func spawn(spawner) -> void:
	var spawner_instance: EnemySpawner = spawner.instantiate()
	
	# set enemy spawner spawn points
	for spawn_point in enemy_spawn_points:
		spawner_instance.spawn_points.append(spawn_point)
	spawner_instance.range_1 = enemy_air_spawn_point_1
	spawner_instance.range_2 = enemy_air_spawn_point_2
	
	get_tree().current_scene.add_child(spawner_instance)
	spawner_instance.global_position = global_position
	spawners_created.append(spawner_instance)
