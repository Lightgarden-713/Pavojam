class_name HitFeedbackComponent
extends Node

@export_group("References")
@export var health_component: HealthComponent
@export var affected_meshes: Array[MeshInstance3D]

@export_group("Flash parameters")
@export var flash_duration: float

@export_group("Grow Parameters")
@export var grow_duration: float
@export var grow_amount: float

var mesh_materials: Array[BaseMaterial3D]
var hit_flash_tween: Tween
var hit_grow_tween: Tween

var meshes_initial_scales: Dictionary[MeshInstance3D, Vector3]


func _ready() -> void:
	health_component.damage_taken.connect(_play_hit_flash)
	health_component.damage_taken.connect(_play_grow)

	mesh_materials = []
	for mesh in affected_meshes:
		meshes_initial_scales[mesh] = mesh.scale
		for i in range(mesh.mesh.get_surface_count()):
			var material = mesh.get_active_material(i)
			if material is not BaseMaterial3D and material is not StandardMaterial3D:
				continue

			if mesh_materials.has(material):
				continue

			(material as BaseMaterial3D).emission_enabled = true
			(material as BaseMaterial3D).grow = true
			mesh_materials.append(material)


func _play_hit_flash() -> void:
	if hit_flash_tween:
		hit_flash_tween.kill() # Abort the previous flash

	hit_flash_tween = create_tween()

	for material in mesh_materials:
		material.emission = Color.WHITE
		hit_flash_tween.tween_property(material, "emission", Color.BLACK, flash_duration)


func _play_grow() -> void:
	if hit_grow_tween:
		hit_grow_tween.kill() # Abort the previous flash

	hit_grow_tween = create_tween()

	for material in mesh_materials:
		material.grow_amount = 0
		hit_grow_tween.tween_property(material, "grow_amount", grow_amount, grow_duration / 2)
		hit_grow_tween.tween_property(material, "grow_amount", 0, grow_duration / 2)

	# for mesh in affected_meshes:
	# 	# Alternative version using scale
	# 	var base_scale = meshes_initial_scales[mesh]
	# 	var grown_scale = base_scale
	# 	grown_scale.x += grow_amount
	# 	grown_scale.y += grow_amount
	# 	grown_scale.z += grow_amount

	# 	hit_grow_tween.tween_property(mesh, "scale", grown_scale, grow_duration / 2)
	# 	hit_grow_tween.tween_property(mesh, "scale", base_scale, grow_duration / 2)
