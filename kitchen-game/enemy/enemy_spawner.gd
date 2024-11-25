extends Node2D
class_name EnemySpawner


@export var spawn_in_the_air: bool = false
@export var spawn_on_other: bool = true

var spawn_points: Array[Node2D]

@export var enemy_to_spawn: Resource
var range_1: Node2D
var range_2: Node2D

@export var min_spawn_time: float = 5.0
@export var max_spawn_time: float = 10.0
var current_spawn_time: float = 0.0

var spawn_position: Vector2 = Vector2.ZERO


func _process(delta):
	if current_spawn_time <= 0:
		spawn(enemy_to_spawn)
		current_spawn_time = randf_range(min_spawn_time, max_spawn_time)
	else:
		current_spawn_time -= delta


func spawn(enemy):
	if spawn_in_the_air and spawn_on_other:
		var random_number: int = randi_range(0, 1)
		if random_number == 0:
			spawn_in_air()
		else:
			spawn_other()
	else:
		if spawn_in_the_air:
			spawn_in_air()
		elif spawn_on_other:
			spawn_other()
		else:
			spawn_position = global_position
	
	var enemy_instance: Node2D = enemy.instantiate()
	
	get_tree().current_scene.add_child(enemy_instance)
	enemy_instance.global_position = spawn_position


func spawn_in_air() -> void:
	if range_1 != null and range_2 != null:
		spawn_position.x = randf_range(range_1.global_position.x, range_2.global_position.x)
		spawn_position.y = range_1.global_position.y


func spawn_other() -> void:
	if !spawn_points.is_empty():
		var random_spawn_point = spawn_points.pick_random()
		spawn_position = random_spawn_point.global_position
