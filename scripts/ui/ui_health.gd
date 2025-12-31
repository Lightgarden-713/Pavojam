class_name UIHealth
extends PanelContainer

@export_group("References")
@export var level: Level
@export var health_text: Label
@export var health_bar: ProgressBar

var player_health: HealthComponent = null


func _ready() -> void:
	player_health = level.player_body.health_component
	health_bar.value = health_percentage()


func _process(_delta: float) -> void:
	health_text.text = "HP: " + str(int(player_health.health)) + " / " + str(int(player_health.current_max_health))
	health_bar.value = health_percentage()
	
func health_percentage()-> int:
	return int(player_health.health / player_health.current_max_health * 100)
