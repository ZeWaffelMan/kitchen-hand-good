extends Node2D


@export var world: World
@onready var players = world.players

@export var ball: Resource
var ball_instance: Enemy
var is_first_serve: bool = false

@export var spawn_points: Array[Node2D]

enum BattleStates{
	START,
	IN_GAME,
	END,
}

var battle_state = BattleStates.START


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	match battle_state:
		BattleStates.START:
			var has_spawned_ball: bool = false
			if len(world.players) != 0:
				has_spawned_ball = true
				var random_spawn: Node2D = spawn_points.pick_random()
				if is_first_serve:
					spawn_ball(random_spawn)
				else:
					spawn_ball(random_spawn)
			if has_spawned_ball:
				battle_state = BattleStates.IN_GAME
		BattleStates.IN_GAME:
			print("were going now")


func spawn_ball(spawn_point: Node2D) -> void:
	ball_instance = ball.instantiate()
	get_tree().current_scene.add_child(ball_instance)
	ball_instance.global_position = spawn_point.global_position
