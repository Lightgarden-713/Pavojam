extends Control
@export var scene_to_change : PackedScene


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(scene_to_change)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
