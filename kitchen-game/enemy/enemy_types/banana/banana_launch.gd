extends State


@export var movement: EnemyMovement

@export var launch_force: float = 15000.0
@export var head: EnemyHead
@export var health: EnemyHealth

@export var max_time_until_split: float = 0.5
@onready var time_until_split: float = max_time_until_split
@export var peel: Sprite2D

@export var chunks: Resource


func enter_state() -> void:
	movement.movement_animation_player.play("RESET")
	launch()


func exit_state() -> void:
	pass


func physics_update_state(delta) -> void:
	if head.is_grabbed:
		time_until_split = max_time_until_split
	
	if time_until_split > 0:
		time_until_split -= delta
	else:
		time_until_split = max_time_until_split
		split()


func launch() -> void:
	print("launch")
	movement.squash_animation_player.play("squash")
	peel.visible = false
	
	head.is_only_ragdoll = true
	head.apply_impulse(Vector2.UP * launch_force)


func split() -> void:
	print("SPLIT!!!!!")
	
	var chunks_instance: Node2D = chunks.instantiate()
	get_tree().current_scene.add_child(chunks_instance)
	chunks_instance.global_position = head.global_position
	
	health.kill()
