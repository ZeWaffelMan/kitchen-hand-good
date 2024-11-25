extends Area2D
class_name PlayerDetection


var detects_area: bool = false
var detected_areas: Array
var area: PlayerFindBox


func sees_player() -> bool:
	return detects_area


func _physics_process(delta: float) -> void:
	area_check()


func find_first(check_for_body: bool, check_for_area: bool) -> PlayerHand:
	if check_for_area:
		if detected_areas[0] is PlayerFindBox:
			area = detected_areas[0]
	return area.player


func closest_player() -> PlayerHand:
	var nearest_object_distance: float = 10_000_000.0
	for object in detected_areas:
		var axis: Vector2 = object.global_position - global_position
		var distance: float = axis.length()
		if distance < nearest_object_distance:
			if object is PlayerFindBox:
				area = object
			nearest_object_distance = distance
	if area is PlayerFindBox:
		return area.player
	else:
		return null


#func random_player() -> PlayerHand:
	#var players = len(get_overlapping_areas())
	#var random_player = randi_range(0, players)
	#if detected_areas[random_player] != null:
		#if detected_areas[random_player] is PlayerFindBox:
			#area = detected_areas[random_player]
	#return area.player


func area_check() -> void:
	if has_overlapping_areas():
		detects_area = true
		detected_areas = get_overlapping_areas()
		if area is PlayerFindBox:
			area = detected_areas[0]
	else:
		detects_area = false
		detected_areas = get_overlapping_areas()
		area = null
