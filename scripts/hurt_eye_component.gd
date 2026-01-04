## Changes the eye texture UV offset when the player takes damage.
## Player-specific component - add this to the player only.
class_name HurtEyeComponent
extends Node

@export_group("References")
@export var health_component: HealthComponent
## The root node containing the mesh (e.g., the imported GLTF root like "Pavo")
@export var mesh_root: Node3D

@export_group("Settings")
## Name of the MeshInstance3D node to find (searches recursively)
@export var mesh_node_name: String = "Pavo"
## The material surface index for the eye (should be second as pavo only has 2 texture materials)
@export var eye_material_index: int = 1
## UV offset to show the hurt eye (adjust based on your texture atlas)
@export var hurt_eye_uv_offset: Vector2 = Vector2(-0.38, 0.0)
## Duration to show the hurt eye before reverting
@export var hurt_duration: float = 0.3

var _eye_material: BaseMaterial3D
var _eye_tween: Tween


func _ready() -> void:
	if health_component == null:
		push_error("HurtEyeComponent: health_component not set")
		return
	
	if mesh_root == null:
		push_error("HurtEyeComponent: mesh_root not set")
		return
	
	# Find the mesh recursively
	var eye_mesh = _find_mesh_recursive(mesh_root, mesh_node_name)
	
	if eye_mesh == null:
		push_error("HurtEyeComponent: Could not find mesh named '" + mesh_node_name + "'")
		return
	
	_eye_material = eye_mesh.get_active_material(eye_material_index) as BaseMaterial3D
	
	if _eye_material == null:
		push_error("HurtEyeComponent: Could not get eye material at index " + str(eye_material_index))
		return
	
	health_component.damage_taken.connect(_on_damage_taken)


func _find_mesh_recursive(node: Node, target_name: String) -> MeshInstance3D:
	# Check if this node is the mesh we're looking for
	if node is MeshInstance3D and node.name == target_name:
		return node as MeshInstance3D
	
	# Search children recursively
	for child in node.get_children():
		var result = _find_mesh_recursive(child, target_name)
		if result != null:
			return result
	
	return null


func _on_damage_taken() -> void:
	if _eye_material == null:
		return
	
	if _eye_tween:
		_eye_tween.kill()
	
	# Set UV offset to show hurt eye
	_eye_material.uv1_offset = Vector3(hurt_eye_uv_offset.x, hurt_eye_uv_offset.y, 0)
	
	# Wait and then reset to normal eye
	_eye_tween = create_tween()
	_eye_tween.tween_interval(hurt_duration)
	_eye_tween.tween_callback(_reset_eye)


func _reset_eye() -> void:
	if _eye_material != null:
		_eye_material.uv1_offset = Vector3.ZERO
