class_name HitboxComponent
extends Area3D

signal on_hit(target: HurtboxComponent)

@export_category("stats")
@export var damage_amount: float

func register_hit(hurtbox: HurtboxComponent) -> void:
	on_hit.emit(hurtbox)
