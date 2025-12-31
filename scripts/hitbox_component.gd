class_name HitboxComponent
extends Area3D

signal on_hit(target: HurtboxComponent)

@export_category("stats")
@export var damage_amount : float
@export var knockback_force : float = 0.0 # no knockback by default


func _on_area_entered(hurtbox: HurtboxComponent) -> void:
	if hurtbox == null:
		return

	hurtbox.get_hit(self)
	on_hit.emit(hurtbox)


func _on_body_entered(_body: Node3D) -> void:
	# Currently the only collidable body should be the level itself
	on_hit.emit(null)
