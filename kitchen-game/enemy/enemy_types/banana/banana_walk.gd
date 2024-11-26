extends State



@export var movement: EnemyMovement
@export var head: EnemyHead

@export var player_detection: PlayerDetection


func enter_state() -> void:
	movement.movement_animation_player.play("run")
	print("walk")


func exit_state() -> void:
	pass


func update_state(delta) -> void:
	pass


func physics_update_state(delta) -> void:
	if player_detection.sees_player():
		transitioned.emit(self, "LaunchSplit")
	
	head.apply_force(movement.move_direction * movement.acceleration * delta)
