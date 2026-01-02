class_name Projectile
extends Node3D

@export_group("References")
@export var hitbox: HitboxComponent

@export_group("Travel Stats")
@export var projectile_speed: float
@export var projectile_lifetime_sec: float
@export var gravity: float

var direction: Vector3
var projectile_time_left: float
var velocity: Vector3


func _ready() -> void:
	hitbox.on_hit.connect(_on_projectile_hit)
	projectile_time_left = projectile_lifetime_sec
	velocity = direction * projectile_speed


func _process(delta: float) -> void:
	projectile_time_left -= delta
	if projectile_time_left <= 0:
		call_deferred("queue_free")


func _physics_process(delta: float) -> void:
	position += velocity * delta
	velocity.y -= gravity * delta


func _on_projectile_hit(_target: HurtboxComponent) -> void:
	call_deferred("queue_free")
