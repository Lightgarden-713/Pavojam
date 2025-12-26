class_name Level
extends Node3D

const XP_ORB_PREFAB : PackedScene = preload("res://scenes/experience/experience_orb.tscn")
const ORB_CHEAT_RADIUS : float = 8
const ORB_CHEAT_SPAWN_HEIGHT : float = 1
const ORB_CHEAT_XP_AMOUNT : float = 10

@onready var player_body : ProtoController = $Player/ProtoController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	_process_dev_cheat_inputs()

func _process_dev_cheat_inputs() -> void:
	if Input.is_action_just_pressed("spawn_xp_orb_cheat"):
		var new_orb = XP_ORB_PREFAB.instantiate() as ExperienceOrb
		var new_orb_position = randf_range(0.0, ORB_CHEAT_RADIUS) * Vector2.from_angle(randf_range(0.0, 360.0))
		new_orb.position = Vector3(new_orb_position.x, ORB_CHEAT_SPAWN_HEIGHT, new_orb_position.y)
		new_orb.xp_value = ORB_CHEAT_XP_AMOUNT
		call_deferred("add_child", new_orb)

func _physics_process(_delta):
	get_tree().call_group("enemies", "update_target_location", player_body.global_position)
