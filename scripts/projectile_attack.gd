class_name ProjectileAttack
extends Node3D

# TODO: test Homing / Teledirected projectiles
enum AttackMode { AIMED, AUTO_AIMED }

@export_group("References")
@export var projectile_prefab: PackedScene

@export_group("Attack Stats")
@export var projectile_damage: float
@export var projectile_speed: float
@export var attacks_per_second: float
@export var projectiles_per_attack: float

@export_group("Projectile Config")
@export_flags_3d_physics var projectile_collision_mask : int

var time_until_shooting : float

func _ready() -> void:
	time_until_shooting = 1 / attacks_per_second

func _process(delta: float) -> void:
	time_until_shooting -= delta
	if time_until_shooting <= 0:
		shoot()

func shoot() -> void:
	# Pick target
	var target = global_position - global_transform.basis.z

	# Calculate direction towards target
	var shoot_direction = global_position.direction_to(target)

	# Spawn and setup Projectiles
	for projectile_n in range(projectiles_per_attack):
		var projectile : Projectile = projectile_prefab.instantiate() as Projectile
		projectile.projectile_speed = projectile_speed
		projectile.hitbox.damage_amount = projectile_damage
		projectile.hitbox.collision_mask = projectile_collision_mask
		projectile.direction = shoot_direction
		projectile.position = global_position

		get_tree().root.call_deferred("add_child", projectile)
	# Reset shoot timer
	time_until_shooting = 1 / attacks_per_second
