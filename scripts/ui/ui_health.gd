class_name UIHealth
extends PanelContainer

@export_group("References")
@export var level: Level
@export var health_text: Label

var player_health: HealthComponent = null


func _ready() -> void:
	player_health = level.player_body.health_component


func _process(_delta: float) -> void:
	health_text.text = "Health: " + str(player_health.health) + " / " + str(player_health.current_max_health)
