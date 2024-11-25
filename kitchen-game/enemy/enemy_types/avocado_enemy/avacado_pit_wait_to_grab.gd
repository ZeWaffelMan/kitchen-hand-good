extends State


@export var head: EnemyHead

@export var grab_player_detection: PlayerDetection
var has_grabbed_player: bool = false
@export var storage: EnemyStorage
@export var new_size: float = 1.5
@export var body_sprites: Node2D
@export var mouth_animation_player: AnimationPlayer


func enter_state() -> void:
	mouth_animation_player.play("toungue_out")


func physics_update_state(delta) -> void:
	body_sprites.scale.x = new_size
	body_sprites.scale.y = new_size
	if grab_player_detection.sees_player():
		if !has_grabbed_player:
			var player = grab_player_detection.closest_player()
			head.player = player
			storage.player = player
			has_grabbed_player = true
			grab_player()
			transitioned.emit(self, "HoldAndDamage")


func grab_player() -> void:
	pass
