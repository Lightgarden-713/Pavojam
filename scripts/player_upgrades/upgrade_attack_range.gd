class_name UpgradeAttackRange
extends PlayerUpgrade

@export_group("Upgrade Stats")
@export var flat_attack_range_increase : float

func apply_upgrade(player: ProtoController) -> void:
	var player_entity_tracker = player.projectile_attack_component.entity_tracker
	player_entity_tracker.increase_detection_radius(flat_attack_range_increase)
