class_name HitFlashComponent
extends Node

@export_group("References")
@export var health_component : HealthComponent
@export var flashing_meshes : Array[MeshInstance3D]

@export_group("Flash parameters")
@export var flash_duration : float

var mesh_materials : Array[BaseMaterial3D]
var hit_flash_tween : Tween

func _ready() -> void:
	health_component.damage_taken.connect(_play_hit_flash)

	mesh_materials = []
	for mesh in flashing_meshes:
		for i in range(mesh.mesh.get_surface_count()):
			var material = mesh.get_active_material(i)
			if material is not BaseMaterial3D and material is not StandardMaterial3D:
				continue

			(material as BaseMaterial3D).emission_enabled = true
			mesh_materials.append(material)

func _play_hit_flash() -> void:
	if hit_flash_tween:
		hit_flash_tween.kill() # Abort the previous flash

	hit_flash_tween = create_tween()

	for material in mesh_materials:
		material.emission = Color.WHITE
		hit_flash_tween.tween_property(material, "emission", Color.BLACK, flash_duration)
