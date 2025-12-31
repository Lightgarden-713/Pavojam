class_name LevelUpOptionUI
extends MarginContainer

@export_group("References")
@export var option_image : TextureButton
@export var option_name : Label

signal selected
signal selection_started

func init(upgrade: PlayerUpgrade) -> void:
	option_name.text = upgrade.name
	option_image.texture_normal = upgrade.image
	option_image.texture_pressed = upgrade.image
	option_image.texture_hover = upgrade.image
	option_image.texture_disabled = upgrade.image
	option_image.texture_focused = upgrade.image


func _on_texture_button_button_up() -> void:
	selection_started.emit()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($VBoxContainer/ImageButton, "modulate", Color(0.55, 0.55, 0.55, 1.0), 0.3).from(Color(1, 1, 1, 1))
	await tween.finished
	selected.emit()
