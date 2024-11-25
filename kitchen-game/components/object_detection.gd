extends Area2D
class_name ObjectDetection


@export_category("Checks")
@export var check_for_bodies: bool = true
@export var check_for_areas: bool = false

var detects_body: bool = false
var detected_bodies: Array
var body: Node2D

var detects_area: bool = false
var detected_areas: Array
var area: Node2D


func sees_object() -> bool:
	if check_for_bodies:
		return detects_body
	elif check_for_areas:
		return detects_area
	else:
		return false


func _physics_process(delta) -> void:
	if check_for_bodies:
		body_check()
	if check_for_areas:
		area_check()


func body_check() -> void:
	if monitoring:
		if has_overlapping_bodies():
			detects_body = true
			detected_bodies = get_overlapping_bodies()
			body = detected_bodies[0]
		else:
			detects_body = false
			detected_bodies = get_overlapping_bodies()
			body = null


func area_check() -> void:
	if monitoring:
		if has_overlapping_areas():
			detects_area = true
			detected_areas = get_overlapping_areas()
			area = detected_areas[0]
		else:
			detects_area = false
			detected_areas = get_overlapping_areas()
			area = null
