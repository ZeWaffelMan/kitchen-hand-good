extends Area2D
class_name OnCollisionDestroy


@export var node_to_destroy: Node
@export var destroy_effect: Resource

@export var change_color: bool = true
@export var colored_node: Node2D
@export var spawn_effect_with_rotation: bool = false

@export var death_area: Area2D


#func _ready() -> void:
	#if death_area == null:
		#death_area = self
	#
	#death_area.area_entered.connect(on_collision)
	#death_area.body_entered.connect(on_collision)
#
#
#func on_collision(body_or_area: PhysicsBody2D) -> void:
	## create the destroy effect if there is one
	#if destroy_effect != null:
		#var effect_instance = destroy_effect.instantiate()
		#get_tree().current_scene.add_child(effect_instance)
		#effect_instance.global_position = node_to_destroy.global_position
		#
		## change the rotation to match the node to destroy
		#if spawn_effect_with_rotation:
			#effect_instance.global_rotation = node_to_destroy.global_rotation
		## change the color to match the node to destroy
		#if change_color:
			#effect_instance.modulate = colored_node.modulate
	#
	#node_to_destroy.queue_free()
