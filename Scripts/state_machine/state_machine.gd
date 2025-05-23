extends Node

signal state_changed(current_state)


@export var start_state: NodePath
var states_map = {}

var states_stack = []
var current_state = null
var _active = false:
	set(value):
		_active = value
		set_active(value)

func _enter_tree():
	print("StateMachine: Entering tree")
	print("WHy",start_state.get_name_count())
	if start_state.is_empty():
		start_state = get_child(0).get_path()
		print(start_state)
	for child in get_children():
		var err = child.finished.connect(_change_state)
		if err:
			printerr(err)
	initialize(start_state)


func initialize(initial_state):
	_active = true
	states_stack.push_front(get_node(initial_state))
	current_state = states_stack[0]
	current_state.enter()


func set_active(value):
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null


func _unhandled_input(event):
	current_state.handle_input(event)


func _physics_process(delta):
	current_state.update(delta)


func _on_animation_finished(anim_name):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)


func _change_state(state_name):
	if not _active:
		return
	current_state.exit()

	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]

	current_state = states_stack[0]
	state_changed.emit(current_state)

	if state_name != "previous":
		current_state.enter()
