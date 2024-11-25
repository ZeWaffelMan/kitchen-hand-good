extends State


@export var fling_impulse: float = 35000.0
@export var storage: EnemyStorage
@export var head: EnemyHead

@export var max_destroy_time: float = 1.0
@onready var destroy_time: float = max_destroy_time
@export var node_to_destroy: Node2D


func enter_state() -> void:
	head.apply_impulse(storage.player.velocity.normalized() * fling_impulse)


func update_state(delta) -> void:
	if destroy_time > 0:
		destroy_time -= delta
	else:
		destroy_time = max_destroy_time
		node_to_destroy.queue_free()
