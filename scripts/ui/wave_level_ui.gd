class_name WaveLevelUI
extends PanelContainer

@export_group("References")
@export var wave_manager: WaveManager
@export var wave_number_lavel: Label
@export var next_wave_label: Label

func _ready():
	wave_manager.wave_started.connect(_on_wave_started)

func _process(_delta: float) -> void:
	next_wave_label.text = "Next wave: %d s" % int(wave_manager.time_until_next_wave)

func _on_wave_started(wave_number: int):
	wave_number_lavel.text = "Wave %d" % wave_number
