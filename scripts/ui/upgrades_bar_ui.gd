class_name UpgradesBarUI
extends MarginContainer

@export_group("References")
@export var level_up_ui: LevelUpUI
@export var upgrades_container: VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_up_ui.exited.connect(_on_level_up_finish)


func _on_level_up_finish() -> void:
	var upgrade_rect = TextureRect.new()
	upgrade_rect.texture = level_up_ui.selected_upgrade.image
	upgrade_rect.custom_minimum_size = Vector2(64, 64)
	upgrades_container.add_child(upgrade_rect)
