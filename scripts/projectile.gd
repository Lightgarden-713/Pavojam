class_name Projectile
extends Node3D

@export_group("References")
@export var hitbox: HitboxComponent

@export_group("Travel Stats")
@export var projectile_speed: float

var direction: Vector3


func _ready() -> void:
	hitbox.on_hit.connect(_on_projectile_hit)


func _physics_process(delta: float) -> void:
	position += direction * delta * projectile_speed


func _on_projectile_hit(_target: HurtboxComponent) -> void:
	call_deferred("queue_free")
