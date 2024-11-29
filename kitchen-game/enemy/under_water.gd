extends Node2D


@export var enemy: Enemy

@export var does_float: bool = false
@export var head: EnemyHead

@export var new_gravity: float = -1.0
@onready var default_gravity = head.gravity_scale

@export var new_damp: float = 1.4
@onready var default_damp: float = head.linear_damp

@export var water_detection: ObjectDetection


func _process(delta: float) -> void:
	if water_detection.sees_object():
		head.linear_damp = new_damp
		if does_float:
			head.gravity_scale = new_gravity
	else:
		if enemy.enemy_state != enemy.EnemyStates.STAND:
			head.gravity_scale = default_gravity
		head.linear_damp = default_damp
