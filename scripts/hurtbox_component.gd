# Hurtbox component
#
# Add one or more hurtbox components to an entity
# for it to get hit by stuff like projectiles
class_name HurtboxComponent
extends Area3D

@export_category("References")
@export var owner_health_component: HealthComponent


func _ready() -> void:
	if owner_health_component == null:
		push_error("Health component not set for hitbox")


func get_hit(hitbox: HitboxComponent) -> void:
	owner_health_component.take_damage(hitbox.damage_amount)
