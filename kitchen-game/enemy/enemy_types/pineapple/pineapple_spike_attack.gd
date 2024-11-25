extends State


@export var enemy: Enemy
@export var hazard: Hazard
@export var player_detection: PlayerDetection

@export var max_go_back_time: float = 1.0
@onready var go_back_time: float = max_go_back_time

@export var face_controller: FaceController
@export var eyes_animation_player: AnimationPlayer
@export var mouth_animation_player: AnimationPlayer

@export var spikes: Node2D
@export var storage: EnemyStorage


func enter_state() -> void:
	face_controller.can_blink = true
	enemy.squash_animation_player.play("squash")
	storage.movement_animation_player.play("idle")
	eyes_animation_player.play("sqrunched")
	mouth_animation_player.play("neutral")
	hazard.monitoring = true
	spikes.visible = true
	storage.enemy.enemy_movement.is_using_friction = false


func exit_state() -> void:
	enemy.squash_animation_player.play("squash")
	hazard.monitoring = false
	spikes.visible = false
	storage.enemy.enemy_movement.is_using_friction = false


func update_state(delta) -> void:
	if enemy.enemy_state == enemy.EnemyStates.STAND:
		storage.enemy.enemy_movement.is_using_friction = true
	else:
		storage.enemy.enemy_movement.is_using_friction = false
	if !player_detection.sees_player():
		if go_back_time > 0:
			go_back_time -= delta
		else:
			go_back_time = max_go_back_time
			transitioned.emit(self, "Wait")
	else:
		go_back_time = max_go_back_time
