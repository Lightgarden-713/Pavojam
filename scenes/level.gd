class_name Level
extends Node3D


@onready var player_body = $Player/ProtoController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(_delta):
	get_tree().call_group("enemies", "update_target_location", player_body.global_position)
