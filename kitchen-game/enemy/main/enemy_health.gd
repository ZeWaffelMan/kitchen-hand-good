extends Node
class_name EnemyHealth


@export var can_be_damaged: bool = true
@export var unkillable: bool = false

@export var impact_sound: AudioStreamPlayer
@export var effect_to_spawn: Resource

@export_group("References")
@export var juice_color_node: Node2D
@export var enemy: Enemy
@export var head: EnemyHead

@export_subgroup("Effects")
@export var effect_animation_player: AnimationPlayer
@export var blood_effect: Resource
var juice_color

@export_group("Health")
@export var max_health: float = 2.0
@onready var health: float = max_health:
	set(value):
		health = clamp(value, 0, max_health)

var flash_time: float = 0.1
var current_flash_time: float = 0

@export var max_invincibility_time: float = 0.5
@onready var current_invincibility_time: float = max_invincibility_time

var is_invincible: bool = false
var is_pushed: bool = false

@export var hit_force: float = 4000.0
@export var max_reset_push_time: float = 0.5
@export var death_hazard: Resource
@onready var reset_push_time: float = max_reset_push_time

@export var squirt_effect: Resource
@export var hit_effect: Resource
@export var hit_effect_rotation_offset: float = 0.0
@export var death_effect: Resource

var has_created_death_effect: bool = false
var has_died: bool = false


func _ready() -> void:
	juice_color = juice_color_node.self_modulate


func _process(delta) -> void:
	if is_pushed:
		if reset_push_time > 0:
			reset_push_time -= delta
		else:
			is_pushed = false
			reset_push_time = max_reset_push_time
	
	# start the invincibility if we got hit
	if is_invincible == true:
		if current_invincibility_time > 0:
			current_invincibility_time -= delta
		else:
			end_invincibility()
	
	if health <= 0:
		kill()
	
	if current_flash_time > 0:
		current_flash_time -= delta
	else:
		effect_animation_player.play("RESET")


func end_invincibility() -> void:
	is_invincible = false
	is_pushed = false
	current_invincibility_time = max_invincibility_time


func damage(amount: float, area: Node2D, applies_hit_force: bool) -> void:
	if !has_died and can_be_damaged:
		if !is_invincible and !enemy.is_secret_ingredient:
			if area != head:
				spawn_hit_effect(area.global_position)
			CameraShake.add_trama(0.5)
			is_pushed = true
			if applies_hit_force:
				var hit_axis: Vector2 = area.global_position - head.global_position
				var hit_direction: Vector2 = hit_axis.normalized()
				head.apply_impulse(hit_direction * hit_force)
			
			is_invincible = true
			if !unkillable:
				health -= amount
			blood()
			
			impact_sound.play()
			impact_sound.pitch_scale = Sound.random_pitch(0.8, 1.2)
			
			current_flash_time = flash_time
			effect_animation_player.play("damage_flash")


func spawn_hit_effect(impact_position: Vector2) -> void:
	EffectCreator.create_effect(hit_effect, juice_color)
	
	EffectCreator.set_effect_position(head.global_position)
	EffectCreator.rotate_between(head.global_position, impact_position, hit_effect_rotation_offset)


func kill() -> void:
	has_died = true
	if !has_created_death_effect:
		impact_sound.play()
		impact_sound.pitch_scale = Sound.random_pitch(0.8, 1.2)
		if death_hazard != null:
			EffectCreator.create_effect(death_hazard, "ffffff")
			EffectCreator.set_effect_position(head.global_position)
		
		if effect_to_spawn != null:
			var effect_instance = effect_to_spawn.instantiate()
			get_tree().current_scene.add_child(effect_instance)
			effect_instance.global_position = head.global_position
		
		CameraShake.add_trama(0.5)
		blood()
		EffectCreator.create_effect(death_effect, juice_color)
		EffectCreator.set_effect_position(head.global_position)
		EffectCreator.effect_instance.global_rotation = randf_range(0, 360)
		has_created_death_effect = true
	
	enemy.visible = false
	enemy.process_mode = Node.PROCESS_MODE_DISABLED
	if !impact_sound.playing:
		enemy.queue_free()


func blood() -> void:
	var blood_instance: Blood = blood_effect.instantiate()
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.squirt(8, 3, juice_color)
	blood_instance.global_position = head.global_position
