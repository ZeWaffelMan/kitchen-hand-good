extends State


@export var run_around_state: CherryRunAround

@export var max_wait_blow_up_time: float = 0.6
@onready var wait_blow_up_time: float = max_wait_blow_up_time

@export var head: EnemyHead
@export var storage: EnemyStorage

@export var jump_impulse: float = 16000.0
@export var y_impulse_multiplier: float = 1.6
@export var enemy_health: EnemyHealth
@export var boom: Resource
@export var squash_animation_player: AnimationPlayer


func enter_state() -> void:
	#play jump animation
	head.is_only_ragdoll = true
	if storage.player != null:
		var axis: Vector2 = storage.player.global_position - head.global_position
		var direction: Vector2 = axis.normalized()
		head.apply_impulse(Vector2(direction.x * jump_impulse, direction.y * jump_impulse * y_impulse_multiplier))
		squash_animation_player.play("squash")


func update_state(delta) -> void:
	if wait_blow_up_time > 0:
		wait_blow_up_time -= delta
	else:
		wait_blow_up_time = max_wait_blow_up_time
		blow_up()


func blow_up() -> void:
	EffectCreator.create_effect(boom, "ffffff")
	EffectCreator.set_effect_position(head.global_position)
	enemy_health.kill()
