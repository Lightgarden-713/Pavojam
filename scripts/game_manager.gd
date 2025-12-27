class_name GameManager
extends Node

enum State {
	PLAYING,
	LEVELING_UP,
	PAUSED
}

var state = State.PLAYING
var prev_state = State.PLAYING

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_menu"):
		change_game_state(State.PAUSED if state != State.PAUSED else prev_state)

func change_game_state(new_state: State) -> void:
	if new_state == state:
		return

	prev_state = state

	if new_state == State.PAUSED:
		get_tree().paused = true
		# open_pause_menu()
	elif new_state == State.LEVELING_UP:
		get_tree().paused = true
		# start_level_up_sequence()
	elif new_state == State.PLAYING:
		get_tree().paused = false

	state = new_state
