class_name XPComponent
extends Node

signal leveled_up(new_level: int)

@export_group("Stats")
@export var xp_to_first_level: float = 100.0
@export var level_scaling: float = 1.2
@export var absorption_factor : float = 1.0

var current_absorption_factor : float
var current_xp: float = 0.0
var xp_to_next_level: float
var level: int = 1

func _ready() -> void:
	current_absorption_factor = absorption_factor
	xp_to_next_level = xp_to_first_level

func add_xp(amount: float) -> void:
	var xp_increase = amount * current_absorption_factor
	current_xp += xp_increase
	print("Gained " + str(xp_increase) + " XP. Current: " + str(current_xp) + "/" + str(xp_to_next_level))

	while current_xp >= xp_to_next_level:
		_level_up()

func _level_up() -> void:
	current_xp -= xp_to_next_level # this way you keep the experience obtained that surpassed the level limit
	level += 1
	xp_to_next_level *= level_scaling
	leveled_up.emit(level)
	print("Level up! Now level " + str(level) + ". Next level at " + str(xp_to_next_level) + " XP")

func get_xp_percentage() -> float:
	return current_xp / xp_to_next_level

func get_level() -> int:
	return level
