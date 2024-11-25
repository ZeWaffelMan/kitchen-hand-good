extends Node2D
class_name EnemyStorage


@export var enemy: Enemy
@export var head: EnemyHead
@export var movement_animation_player: AnimationPlayer

var player: PlayerHand
var last_player_position: Vector2 = Vector2.ZERO
