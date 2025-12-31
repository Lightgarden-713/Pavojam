class_name ProjectileAttack
extends Node3D

# TODO: test Auto aimed / Homing / Teledirected projectiles
enum AttackMode { AIMED }

@export_group("References")
@export var projectile_prefab: PackedScene

@export_group("Attack Stats")
@export var projectile_damage: float
@export var projectile_speed: float
@export var attacks_per_second: float
@export var projectiles_per_attack: float

@export_group("Projectile Config")
@export_flags_3d_physics var projectile_collision_mask: int

# Upgradable Stats
var current_attacks_per_second: float
var current_projectile_damage: float

var time_until_shooting: float


func _ready() -> void:
	current_attacks_per_second = attacks_per_second
	current_projectile_damage = projectile_damage
	time_until_shooting = 1 / attacks_per_second


func _process(delta: float) -> void:
	time_until_shooting -= delta
	if time_until_shooting <= 0:
		shoot()


func shoot() -> void:
	var tree_root = get_tree().root

	# Pick target as a forward pos
	var target = global_position - global_transform.basis.z

	# Calculate direction towards target
	var shoot_direction = global_position.direction_to(target)

	# Spawn and setup Projectiles
	for projectile_n in range(projectiles_per_attack):
		var projectile: Projectile = projectile_prefab.instantiate() as Projectile

		projectile.hitbox.damage_amount = current_projectile_damage
		projectile.hitbox.collision_mask = projectile_collision_mask

		projectile.projectile_speed = projectile_speed
		projectile.direction = shoot_direction
		projectile.position = global_position

		# Vector3(0, 0.7, -0.7)  →  atan2()  →  Rotation Angle (≈ -45°)
		projectile.rotation.y = atan2(shoot_direction.x, shoot_direction.z)

		tree_root.call_deferred("add_child", projectile)
	# Reset shoot timer
	time_until_shooting = 1 / current_attacks_per_second
