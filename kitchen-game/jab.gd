extends State


@export var head_turn_speed: float = 10.0

@export var enemy_storage: EnemyStorage
@export var player_detection: PlayerDetection
var player: PlayerHand
@export var body_sprites: Node2D
@export var head: EnemyHead
@export var angle_offset: float = 90.0
@export var hazard: Hazard


func enter_state() -> void:
	hazard.monitoring = true


func exit_state() -> void:
	hazard.monitoring = false


func update_state(delta) -> void:
	if player_detection.sees_player():
		player = player_detection.closest_player()
		if player != null:
			enemy_storage.player = player
			var axis: Vector2 = player.global_position - head.global_position
			var direction: Vector2 = axis.normalized()
			var angle = direction.angle()
			
			body_sprites.global_rotation = lerp_angle(body_sprites.global_rotation, angle + deg_to_rad(angle_offset), head_turn_speed * delta)
	else:
		transitioned.emit(self, "Rest")
