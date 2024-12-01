extends Node2D


@export var world: World
@onready var players = world.players

@export var ball: Resource
var ball_instance: Enemy
var is_first_serve: bool = false

enum BattleStates{
	START,
	IN_GAME,
	END,
}

var battle_state = BattleStates.START


func _process(delta: float) -> void:
	match battle_state:
		BattleStates.START:
			var has_spawned_ball: bool = false
			if len(world.players) != 0:
				has_spawned_ball = true
				var random_player: Player = players.pick_random()
				if is_first_serve:
					spawn_ball(random_player)
				else:
					spawn_ball(random_player)
			if has_spawned_ball:
				battle_state = BattleStates.IN_GAME
		BattleStates.IN_GAME:
			print("were going now")


func spawn_ball(player_to_give: Player) -> void:
	ball_instance = ball.instantiate()
	get_tree().current_scene.add_child(ball_instance)
	ball_instance.global_position = player_to_give.global_position
