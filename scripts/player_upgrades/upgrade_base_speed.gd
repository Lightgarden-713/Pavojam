class_name UpgradeBaseSpeed
extends PlayerUpgrade

@export_group("Upgrade Stats")
@export var flat_speed_increase : float

func apply_upgrade(player: ProtoController) -> void:
	player.current_base_speed += flat_speed_increase
