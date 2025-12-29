class_name PlayerUpgrade
extends Resource

@export_group("Upgrade Info")
@export var name : String
@export var image : Texture2D

func apply_upgrade(_player: ProtoController) -> void:
	push_error("Unimplemented method exception")
