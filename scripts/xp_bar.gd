class_name XPBar extends ProgressBar

@export_group("References")
@export var level: Level

var player_xp : XPComponent = null

func _ready() -> void:
	player_xp = level.player_body.xp_component

func _process(_delta: float) -> void:
	self.value = player_xp.get_xp_percentage() * 100
