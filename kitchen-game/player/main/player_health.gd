extends Node
class_name PlayerHealth


@export var player: Player
@export var life_sprites: Array[Node2D]

@export var max_health: int = 3
@onready var health: int = max_health:
	set(value):
		health = clamp(value, 0, max_health)
		var i = 0
		for life in life_sprites:
			i += 1
			if health >= i:
				life.visible = true
			else:
				life.visible = false

@export var max_invincibility_time: float = 2.0
@onready var current_invincibility_time: float = max_invincibility_time

@export var effect_animation_player: AnimationPlayer
@export var hand: PlayerHand
@export var hurt_impulse: float = 7000.0
@export var hand_gradient: Node2D
@export var hand_sprites: Node2D

@export var hurt_effect: Resource
@export var echo_effect: Resource

var is_invincible: bool = false

var has_gotten_hurt: bool = false

@export var kill_effect_amount: int = 3


func _process(delta) -> void:
	# start the invincibility if hit
	if has_gotten_hurt:
		has_gotten_hurt = false
	if is_invincible:
		if current_invincibility_time > 0:
			current_invincibility_time -= delta
		else:
			effect_animation_player.play("RESET")
			end_invincibility()
	
	if health <= 0 and !player.is_dead:
		kill()
		player.hide()


func end_invincibility() -> void:
	is_invincible = false
	current_invincibility_time = max_invincibility_time


func kill() -> void:
	for i in kill_effect_amount:
		EffectCreator.create_effect(echo_effect, hand_gradient.modulate)
		EffectCreator.set_effect_position(hand_sprites.global_position)
		i += 1
		player.is_dead = true


func damage(amount: int, area: Node2D) -> void:
	# damage the player if it isn't invinsible
	if !is_invincible and player.can_be_damaged:
		var axis = hand.global_position - area.global_position
		var direction = axis.normalized()
		hand.apply_impulse(hurt_impulse * direction)
		CameraShake.change_speed(0.3, 0.4)
		CameraShake.add_trama(0.6)
		has_gotten_hurt = true
		effect_animation_player.play("invincibility")
		is_invincible = true
		
		EffectCreator.create_effect(hurt_effect, hand_gradient.modulate)
		EffectCreator.set_effect_position(hand_sprites.global_position)
		EffectCreator.direction_rotate(hand_sprites, area, 0.0)
		health -= amount
