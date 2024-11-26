extends Node


@export var head: EnemyHead
@export var enemy_push_check: ObjectDetection
@export var push_force: float = 600000.0

@export var enemy_exception: EnemyHead


func _physics_process(delta: float) -> void:
	if !head.is_grabbed:
		var objects = enemy_push_check.get_overlapping_bodies()
		for object in objects:
			if object is EnemyHead:
				if object != enemy_exception:
					var axis: Vector2 = head.global_position - object.global_position
					var direction: Vector2 = axis.normalized()
					head.apply_force(direction * push_force * delta)
