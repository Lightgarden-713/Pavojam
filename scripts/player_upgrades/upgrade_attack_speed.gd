class_name UpgradeAttackSpeed
extends PlayerUpgrade

@export_group("Upgrade Stats")
@export var flat_attack_speed_increase : float

func apply_upgrade(player: ProtoController) -> void:
	player.projectile_attack_component.current_attacks_per_second += flat_attack_speed_increase
