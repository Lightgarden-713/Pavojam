class_name UpgradeMaxHealth
extends PlayerUpgrade

@export_group("Upgrade Stats")
@export var flat_max_health_increase: float


func apply_upgrade(player: ProtoController) -> void:
	player.health_component.increase_max_health(flat_max_health_increase)
