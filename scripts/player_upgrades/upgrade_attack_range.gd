class_name UpgradeAttackRange
extends PlayerUpgrade

@export_group("Upgrade Stats")
@export var flat_attack_range_increase : float

func apply_upgrade(player: ProtoController) -> void:
	var player_entity_tracker = player.projectile_attack_component.entity_tracker
	var current_radius = player_entity_tracker.get_detection_radius()
	player_entity_tracker.update_detection_radius(current_radius + flat_attack_range_increase)
