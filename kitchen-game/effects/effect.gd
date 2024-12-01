extends Node


@export var has_destroy_time: bool = false
@export var has_screen_shake: bool = false
@export var screen_shake_amount: float = 0.3

@export var wait_for_animation: bool = true

@export var max_destroy_time: float = 5.0
@export var node_to_destroy: Node2D
@onready var current_destroy_time: float = max_destroy_time

@export var wait_for_sound: bool = false
@export var sound_to_wait_for: AudioStreamPlayer

@export var particles: Array[GPUParticles2D]


func _ready() -> void:
	if sound_to_wait_for != null:
		sound_to_wait_for.pitch_scale = Sound.random_pitch(0.9, 1.1)
	if particles != null:
		for particle in particles:
			particle.emitting = true
	if has_screen_shake:
		CameraShake.add_trama(screen_shake_amount)


func _process(delta):
	if wait_for_sound:
		if !sound_to_wait_for.playing:
			destroy()
			
	for particle in particles:
		if !particle.emitting:
			destroy()
			
	if has_destroy_time:
		if current_destroy_time > 0:
			current_destroy_time -= delta
		else:
			destroy()


func destroy() -> void:
	if node_to_destroy != null:
		node_to_destroy.queue_free()
	else:
		queue_free()


func _on_animation_finished():
	if wait_for_animation:
		if !has_destroy_time:
			destroy()
