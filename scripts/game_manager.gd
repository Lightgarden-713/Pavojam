class_name GameManager
extends Node

@export_group("References")
@export var level_up_ui : LevelUpUI

@export_group("Upgrades")
@export var upgrades_pool: Array[PlayerUpgrade]

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
		# only pause if not already paused, otherwise
		# unpause and go to the state previous to pausing
		var next_state = State.PAUSED if state != State.PAUSED else prev_state
		change_game_state(next_state)

func change_game_state(new_state: State) -> void:
	if new_state == state:
		return

	prev_state = state

	if new_state == State.PAUSED:
		get_tree().paused = true
		# open_pause_menu()
	elif new_state == State.LEVELING_UP:
		get_tree().paused = true
		var upgrades_to_choose = get_level_up_upgrades(3)
		level_up_ui.open(upgrades_to_choose)
	elif new_state == State.PLAYING:
		get_tree().paused = false

	state = new_state

func _on_level_up_finish() -> void:
	level_up_ui.selected_upgrade.apply_upgrade(player_controller)
	change_game_state(State.PLAYING)

func _on_player_level_up(_new_level: int) -> void:
	change_game_state(State.LEVELING_UP)

# === Player Upgrades ===
func get_level_up_upgrades(num_upgrades: int) -> Array[PlayerUpgrade]:
	var available_upgrades : Array[PlayerUpgrade] = []
	available_upgrades.append_array(upgrades_pool)

	var level_up_upgrades : Array[PlayerUpgrade] = []

	for upgrade_n in range(num_upgrades):
		# pick an upgrade from the available upgrades
		var random_upgrade = available_upgrades[randi_range(0, len(available_upgrades) - 1)]
		level_up_upgrades.append(random_upgrade)
		available_upgrades.erase(random_upgrade)

	return level_up_upgrades
