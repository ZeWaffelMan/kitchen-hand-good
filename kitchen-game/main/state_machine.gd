extends Node
class_name StateMachine


@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	# get all the states and connect the signal to them
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			
	# start at the initial state
	if initial_state:
		initial_state.enter_state()
		current_state = initial_state


func _process(delta) -> void:
	if current_state:
		current_state.update_state(delta)


func _physics_process(delta) -> void:
	if current_state:
		current_state.physics_update_state(delta)


func on_child_transition(State, new_state_name: String):
	# switch to new state
	if State != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit_state()
	
	if new_state != null:
		new_state.enter_state()
	
	current_state = new_state
