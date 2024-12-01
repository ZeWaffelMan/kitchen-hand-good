extends Node2D


@export var enemy: Enemy

@export var does_float: bool = false
@export var body: RigidBody2D

@export var new_gravity: float = 4.0
@onready var default_gravity = body.gravity_scale

@export var new_damp: float = 1.0
@onready var default_damp: float = body.linear_damp

@export var water_detection: ObjectDetection


func _process(delta: float) -> void:
	if water_detection.sees_object():
		body.linear_damp = new_damp
		if does_float:
			body.gravity_scale = new_gravity
	else:
		if enemy != null:
			if enemy.enemy_state != enemy.EnemyStates.STAND:
				body.gravity_scale = default_gravity
		else:
			body.gravity_scale = default_gravity
		body.linear_damp = default_damp
