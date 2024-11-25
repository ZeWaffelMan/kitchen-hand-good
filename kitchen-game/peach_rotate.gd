extends State


@export var storage: EnemyStorage

@export var player_detection: PlayerDetection
@export var body_sprites: Node2D
@export var head: EnemyHead
var player: PlayerHand

@export var angle_offset: float = -90.0
@export var rotation_speed: float = 5.0

@export var max_switch_time: float = 2.0
@onready var switch_time: float = max_switch_time

@export var face_animation_player: AnimationPlayer


func enter_state() -> void:
	face_animation_player.play("neutral")


func exit_state() -> void:
	pass


func update_state(delta) -> void:
	if head.does_hang:
		# rotate the peach
		if switch_time > 0:
			switch_time -= delta
		else:
			switch_time = max_switch_time
			if player != null:
				storage.last_player_position = player.global_position
				transitioned.emit(self, "Shoot")
		
		if player_detection.sees_player():
			player = player_detection.closest_player()
			if player != null:
				var axis: Vector2 = player.global_position - head.global_position
				var direction: Vector2 = axis.normalized()
				var angle: float = direction.angle()
				
				body_sprites.global_rotation = lerp_angle(body_sprites.global_rotation, angle + deg_to_rad(angle_offset), rotation_speed * delta)
