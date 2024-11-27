extends Node


@export var has_destroy_time: bool = false
@export var has_screen_shake: bool = false
@export var screen_shake_amount: float = 0.3

@export var max_destroy_time: float = 5.0
@export var node_to_destroy: Node2D
@onready var current_destroy_time: float = max_destroy_time

@export var particles: Array[GPUParticles2D]


func _ready() -> void:
	if particles != null:
		for particle in particles:
			particle.emitting = true
	if has_screen_shake:
		CameraShake.add_trama(screen_shake_amount)


func _process(delta):
	for particle in particles:
		if !particle.emitting:
			if node_to_destroy != null:
				node_to_destroy.queue_free()
			else:
				queue_free()
	if has_destroy_time:
		if current_destroy_time > 0:
			current_destroy_time -= delta
		else:
			if node_to_destroy != null:
				node_to_destroy.queue_free()
			else:
				queue_free()


func _on_animation_finished():
	if !has_destroy_time:
		if node_to_destroy != null:
			node_to_destroy.queue_free()
		else:
			queue_free()
