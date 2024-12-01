extends Node


const MAX_PLAYERS: int = 2

var player_number: int = 0:
	set(value):
		player_number = clamp(value, 0, MAX_PLAYERS)

var player_id: int = 0:
	set(value):
		player_id = clamp(value, 0, MAX_PLAYERS)
