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
	var childs = upgrades_container.get_child_count()
	
	if childs > 6 and childs < 9:
		upgrades_container.add_theme_constant_override("separation", -36)

	if childs > 8 and childs < 11:
		upgrades_container.add_theme_constant_override("separation", -40)

	if childs > 12:
		upgrades_container.add_theme_constant_override("separation", -48)

	if childs > 16:
		upgrades_container.add_theme_constant_override("separation", -52)

	if childs > 20:
		upgrades_container.add_theme_constant_override("separation", -54)

	if childs > 24:
		upgrades_container.add_theme_constant_override("separation", -56)
