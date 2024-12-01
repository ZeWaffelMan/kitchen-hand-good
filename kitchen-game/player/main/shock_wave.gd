extends State
class_name HandShockWave


@export var shock_wave_sound: AudioStreamPlayer

@export var player: Player

@export var player_health: PlayerHealth
@export var impulse_area: ObjectDetection

@export var shock_wave_force: float = 17000.0
@export var max_shockwave_time: float = 1.0
@onready var shockwave_time: float = max_shockwave_time
@export var hand_animation_player: AnimationPlayer
@export var this_player_box: PlayerFindBox

@export var shock_wave_effect: Resource
@export var gradient: Node2D


func enter_state() -> void:
	hand_animation_player.play("point")
	shock_wave_sound.play()
	shock_wave_sound.pitch_scale = Sound.random_pitch(0.9, 1.1)
	
	shockwave(shock_wave_force)
	EffectCreator.create_effect(shock_wave_effect, gradient.modulate)
	EffectCreator.set_effect_position(gradient.global_position)
	CameraShake.add_trama(0.5)


func update_state(delta) -> void:
	if shockwave_time > 0:
		shockwave_time -= delta
	else:
		shockwave_time = max_shockwave_time
		transitioned.emit(self, "Normal")
	
	if player_health.has_gotten_hurt:
		transitioned.emit(self, "Hurt")


func shockwave(impulse_force) -> void:
	for body in impulse_area.detected_bodies:
		if body != null:
			if body is RigidBody2D:
				var axis: Vector2 = body.global_position - impulse_area.global_position
				var direction: Vector2 = axis.normalized()
				body.apply_impulse(direction * impulse_force)
				if body is EnemyHead:
					body.health.is_pushed = true
	
	for area in impulse_area.detected_areas:
		var axis: Vector2 = area.global_position - impulse_area.global_position
		var direction: Vector2 = axis.normalized()
		if area is PlayerFindBox:
			if area != this_player_box:
				area.player.apply_impulse(direction * impulse_force)
