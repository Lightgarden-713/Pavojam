class_name GameManager
extends Node

@export_group("References")
@export var level_up_ui : LevelUpUI

@onready var player_controller : ProtoController = $World/Player/ProtoController

enum State {
	PLAYING,
	LEVELING_UP,
	PAUSED
}

var state = State.PLAYING
var prev_state = State.PLAYING

func _ready() -> void:
	level_up_ui.exited.connect(_on_level_up_finish)
	player_controller.xp_component.leveled_up.connect(_on_player_level_up)

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
		level_up_ui.open()
	elif new_state == State.PLAYING:
		get_tree().paused = false

	state = new_state

func _on_level_up_finish() -> void:
	change_game_state(State.PLAYING)

func _on_player_level_up(new_level: int) -> void:
	change_game_state(State.LEVELING_UP)
