class_name HealthComponent
extends Node

signal health_depleted
signal damage_taken

@export_group("Stats")
@export var max_health: float

var health: float
var current_max_health: float


func _ready() -> void:
	health = max_health
	current_max_health = max_health


func take_damage(damage_amount: float) -> void:
	if !is_alive():
		return

	damage_taken.emit()
	health -= damage_amount
	if !is_alive():
		health_depleted.emit()
		print("I'm ded")


func heal(heal_amount: float) -> void:
	if !is_alive():
		return

	health = min(health + heal_amount, current_max_health)


func increase_max_health(increase_amount: float) -> void:
	current_max_health += increase_amount
	health += increase_amount


func is_alive() -> bool:
	return health > 0
