class_name UpgradeMaxAmmo
extends PlayerUpgrade

@export_group("Upgrade Stats")
@export var projectile_amount_increase : int

func apply_upgrade(player: ProtoController) -> void:
	player.projectile_attack_component.current_projectiles_per_attack += projectile_amount_increase
