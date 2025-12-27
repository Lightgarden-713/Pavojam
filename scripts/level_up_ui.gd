class_name LevelUpUI
extends PanelContainer

@export_group("Refereces")
@export var game_manager : GameManager
@export var animation_player: AnimationPlayer

signal exited

func open() -> void:
	animation_player.play("open")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_upgrade_1_button_up() -> void:
	# Apply option 1 effect
	animation_player.play("close")

func _on_upgrade_2_button_up() -> void:
	# Apply option 2 effect
	animation_player.play("close")

func _on_exit_animation_finished() -> void:
	print("exit animation finished")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	exited.emit()
