extends Node2D
class_name Rope


@export_category("Checks")

@export var is_active: bool = false

@export_group("Rope")
@export var target_distance: float = 37.0
@export var stiffness: float = 20.0
@export var k: float = 0.0089
@export var object_target_distance: float = 350.0
@export var amount_of_points: int = 5

@export_group("References")
@export var points: Array[Node2D]
@export var points_position: Array[Vector2]
@export var object: PhysicsBody2D
@export var verlet_point: Resource

@export var anchor: Node2D
var cursor_velocity: Vector2

@export var line: Line2D


func _ready() -> void:
	points_position.resize(len(points))
	
	for i in amount_of_points:
		var point = verlet_point.instantiate()
		add_child(point)
		points.append(point)
		point.object_gravity.y = 17.0


func _process(delta) -> void:
	line.points = points
	
	var axis = anchor.global_position - object.global_position
	var distance = axis.length()
	
	if is_active:
		for i in len(points):
			points[i].visible = true
			points[i].visible = false
			
		var rigidness: int = 8
		for i in rigidness:
			update_constrain(delta)
	else:
		for i in len(points):
			points[i].visible = false
			points[i].global_position = object.global_position


func update_constrain(delta) -> void:
	if points != null:
		for i in len(points):
			line.points[i] = points[i].position
	if points != null:
			for i in len(points):
				# skip last point
				if i != len(points) - 1:
					# variables for verlet integration constraint
					var axis = points[i].global_position - points[i + 1].global_position
					var distance = axis.length()
					var offset = axis / distance
					
					var step = target_distance - distance
					
					# set the first point to the mouses postion
					if i == 0:
						points[i].global_position = anchor.global_position
					if distance > target_distance:
						# w is the inverse mass of the point
						var inverse_mass_a = points[i].mass
						if i < len(points) - 1:
							var inverse_mass_b = points[i + 1].mass
							
							if distance > target_distance:
								# move the points to where they should go
								points[i].global_position += (step * offset * 1 / inverse_mass_a / (inverse_mass_a + inverse_mass_b) * stiffness) * delta
								points[i + 1].global_position -= (step * offset * 1 / inverse_mass_a / (inverse_mass_a + inverse_mass_b) * stiffness) * delta
				else:
					# variables for verlet integration constraint
					var axis = points[i].global_position - object.global_position
					var distance = axis.length()
					var offset = axis / distance
					
					var step = target_distance - distance
					if distance > target_distance:
						points[i].global_position += (step * offset * stiffness) * delta
