extends State
class_name FistHand


@export var player: Player
@export var hand: PlayerHand
@export var player_health: PlayerHealth

@export var hand_collision: CollisionShape2D
@export var hand_sprite: Sprite2D
@export var magnitude_damage_threshold: float = 5500.0
@export var hit_detection: ObjectDetection
@export var hit_impulse_amount: float = 8000.0
@export var damage_amount: float = 1.0
@export var hand_hit_impulse_amount: float = 7000.0
@export var hand_animation_player: AnimationPlayer


func enter_state() -> void:
	hand_animation_player.play("slap")
	player.hand_state = player.HandStates.SLAP


func update_state(delta) -> void:
	if player_health.has_gotten_hurt:
		transitioned.emit(self, "Hurt")


func physics_update_state(delta: float) -> void:
	if hand.velocity.length() > magnitude_damage_threshold:
		if hit_detection.has_overlapping_bodies():
			var bodies = hit_detection.get_overlapping_bodies()
			for body in bodies:
				if body is EnemyHead:
					if player.can_slap:
						if !body.enemy_hurt_box.health.is_invincible:
							body.enemy_hurt_box.damage(damage_amount, hand, false)
							if body is RigidBody2D:
								body.apply_force(Vector2(hand.velocity * hit_impulse_amount) * delta)
								hand.apply_impulse(Vector2(-hand.velocity.normalized() * 5000.0))
							player.slap_cooldown = player.max_slap_cooldown
	if player.using_mouse:
		if Input.is_action_just_released("right_click"):
			transitioned.emit(self, "Normal")
	else:
		if !Input.get_joy_axis(player.player_id, JOY_AXIS_TRIGGER_LEFT):
			transitioned.emit(self, "Normal")
	
	if player.can_shockwave:
		if player.using_mouse:
			if Input.is_action_pressed("left_click") and Input.is_action_pressed("right_click") or Input.is_action_pressed("shockwave"):
				transitioned.emit(self, "ShockWave")
		else:
			if Input.is_joy_button_pressed(player.player_id, JOY_BUTTON_Y):
				transitioned.emit(self, "ShockWave")
