class_name UpgradeExperienceOrbAbsorption
extends PlayerUpgrade

@export_group("Upgrade Stats")
@export var flat_absorption_factor_increase : float

func apply_upgrade(player: ProtoController) -> void:
	player.xp_component.current_absorption_factor += flat_absorption_factor_increase
