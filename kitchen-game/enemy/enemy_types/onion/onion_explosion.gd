extends Node


@export var effect: Resource
@export var enemy_health: EnemyHealth
@export var target: Node2D

@export var has_spawned_effect: bool = false


func _process(delta: float) -> void:
	if !has_spawned_effect:
		if enemy_health.health <= 0.0:
			spawn_effect(effect)
		has_spawned_effect = true


func spawn_effect(effect_to_spawn: Resource):
	var effect_instance = effect_to_spawn.instantiate()
	get_tree().current_scene.add_child(effect_instance)
	effect_instance.global_position = target.global_position
