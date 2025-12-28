class_name LevelUpUI
extends PanelContainer

@export_group("References")
@export var game_manager : GameManager
@export var animation_player: AnimationPlayer
@export var upgrade_options_container: Node

const LEVEL_UP_OPTION_PREFAB : PackedScene = preload("res://scenes/ui/level_up_option_ui.tscn")

var selected_upgrade : PlayerUpgrade = null

signal exited

func open(upgrades_to_choose: Array[PlayerUpgrade]) -> void:
	# Instantiate options
	for upgrade in upgrades_to_choose:
		# create UI node
		var upgrade_option : LevelUpOptionUI = LEVEL_UP_OPTION_PREFAB.instantiate() as LevelUpOptionUI
		upgrade_option.init(upgrade)
		upgrade_options_container.call_deferred("add_child", upgrade_option)

		# connect to signals
		upgrade_option.selected.connect(_on_upgrade_selected.bind(upgrade))

	animation_player.play("open")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_upgrade_selected(upgrade: PlayerUpgrade) -> void:
	animation_player.play("close")
	self.selected_upgrade = upgrade

func _on_exit_animation_finished() -> void:
	print("exit animation finished")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# delete all option nodes
	var ui_option_nodes : Array[Node] = upgrade_options_container.get_children()
	for ui_option in ui_option_nodes:
		ui_option.call_deferred("queue_free")

	exited.emit()
