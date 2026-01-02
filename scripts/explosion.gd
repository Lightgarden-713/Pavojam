class_name Explosion
extends Node

@export_group("References")
@export var explosion_root_node: Node
@export var telegraphy_sphere_mesh: MeshInstance3D
@export var hitbox: HitboxComponent

@export_group("Explosion Stats")
@export var time_to_explode_sec: float
@export var explosion_radius: float

var telegraphy_sphere: SphereMesh


func _ready() -> void:
	hitbox.monitoring = false
	telegraphy_sphere = telegraphy_sphere_mesh.mesh as SphereMesh
	telegraphy_sphere.radius = 0
	telegraphy_sphere.height = 0
	var tween = create_tween()
	tween.tween_property(telegraphy_sphere, "radius", explosion_radius, time_to_explode_sec)
	tween.parallel().tween_property(telegraphy_sphere, "height", 2 * explosion_radius, time_to_explode_sec)
	tween.tween_callback(_on_explode)
	tween.tween_interval(0.1)
	tween.tween_callback(_cleanup)


func _on_explode() -> void:
	hitbox.monitoring = true
	(telegraphy_sphere.material as StandardMaterial3D).albedo_color.a *= 2.0


func _cleanup() -> void:
	explosion_root_node.call_deferred("queue_free")
