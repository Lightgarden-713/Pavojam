class_name LevelUpOptionUI
extends MarginContainer

@export_group("References")
@export var option_image : TextureButton
@export var option_name : Label

signal selected

func init(upgrade: PlayerUpgrade) -> void:
	option_name.text = upgrade.name
	option_image.texture_normal = upgrade.image
	option_image.texture_pressed = upgrade.image
	option_image.texture_hover = upgrade.image
	option_image.texture_disabled = upgrade.image
	option_image.texture_focused = upgrade.image


func _on_texture_button_button_up() -> void:
	selected.emit()
