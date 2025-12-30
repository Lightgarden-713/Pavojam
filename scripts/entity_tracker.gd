class_name EntityTracker
extends Area3D

@export_group("Settings")
@export var initial_detection_radius : float

@export_group("References")
@export var collision_shape : CollisionShape3D

var _sphere_detector : SphereShape3D = null

var entities_within_detection_range : Array[Node3D]

func _ready() -> void:
	if collision_shape == null or collision_shape.shape == null or collision_shape.shape is not SphereShape3D:
		push_error("Only supported collision shape is sphere shape 3D")

	_sphere_detector = collision_shape.shape as SphereShape3D
	update_detection_radius(initial_detection_radius)

func get_detection_radius() -> float:
	return _sphere_detector.radius

func update_detection_radius(new_radius: float) -> void:
	if _sphere_detector == null:
		return

	_sphere_detector.radius = new_radius

func _on_body_entered(body: Node3D) -> void:
	entities_within_detection_range.append(body)

func _on_body_exited(body: Node3D) -> void:
	entities_within_detection_range.erase(body)
