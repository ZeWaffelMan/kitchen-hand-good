extends State
class_name WalkUp


@export var enemy: Enemy
@export var head: EnemyHead

@export var speed: float = 10000.0
@export var speed_factor: Vector2 = Vector2(0.5, -1.0)
@export var high_enough_check: ObjectDetection


func physics_update_state(delta) -> void:
	if high_enough_check.sees_object():
		head.apply_force(Vector2(speed * speed_factor.x, speed * speed_factor.y) * delta)
	else:
		transitioned.emit(self, "JumpUpStab")
	if enemy.enemy_state != enemy.EnemyStates.STAND:
		transitioned.emit(self, "Wait")
