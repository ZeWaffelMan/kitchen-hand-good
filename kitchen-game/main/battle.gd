extends Node2D


@export var score_blue: int = 0
@export var score_red: int = 0

@export var score_blue_label: Label
@export var score_red_label: Label

@export var world: World
@onready var players = world.players

@export var ball: Resource
var ball_instance: Enemy

@export var blue_goal_detection: ObjectDetection
@export var red_goal_detection: ObjectDetection

@export var spawn_points: Array[Node2D]

enum BattleStates{
	START,
	IN_GAME,
	END,
}

var battle_state = BattleStates.START

var spawn_index: int = 0


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	match battle_state:
		BattleStates.START:
			var has_spawned_ball: bool = false
			if len(world.players) != 0:
				has_spawned_ball = true
				var random_spawn: Node2D = spawn_points.pick_random()
				var next_spawn: Node2D = spawn_points[spawn_index]
				spawn_ball(next_spawn)
				
				if spawn_index == 0:
					spawn_index = 1
				else:
					spawn_index = 0
			if has_spawned_ball:
				battle_state = BattleStates.IN_GAME
		BattleStates.IN_GAME:
			if blue_goal_detection.sees_object() or red_goal_detection.sees_object():
				if blue_goal_detection.sees_object():
					score_red += 1
					score_red_label.text = str(score_red)
				if red_goal_detection.sees_object():
					score_blue += 1
					score_blue_label.text = str(score_blue)
				ball_instance.queue_free()
				battle_state = BattleStates.END
		BattleStates.END:
			battle_state = BattleStates.START


func spawn_ball(spawn_point: Node2D) -> void:
	ball_instance = ball.instantiate()
	get_tree().current_scene.add_child(ball_instance)
	ball_instance.global_position = spawn_point.global_position
