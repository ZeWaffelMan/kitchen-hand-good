extends State


@export var run_around_state: CherryRunAround

@export var max_wait_blow_up_time: float = 0.5
@onready var wait_blow_up_time: float = max_wait_blow_up_time

@export var head: EnemyHead
@export var storage: EnemyStorage

@export var jump_impulse: float = 25000.0
@export var enemy_health: EnemyHealth
@export var boom: Resource


func enter_state() -> void:
	#play jump animation
	head.is_only_ragdoll = true
	if storage.player != null:
		var axis: Vector2 = run_around_state.last_player_position - head.global_position
		var direction: Vector2 = axis.normalized()
		head.apply_impulse(direction * jump_impulse)


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
