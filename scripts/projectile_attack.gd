class_name ProjectileAttack
extends Node3D

# TODO: test Auto aimed / Homing / Teledirected projectiles
enum AttackMode { AIMED, AUTO_AIMED }

@export_group("References")
@export var projectile_prefab: PackedScene
@export var entity_tracker: EntityTracker

@export_group("Attack Stats")
@export var projectile_damage: float
@export var projectile_speed: float
@export var attack_mode: AttackMode
@export var attacks_per_second: float
@export var projectiles_per_attack: float

@export_group("Projectile Config")
@export_flags_3d_physics var projectile_collision_mask : int

# Upgradable Stats
var current_attacks_per_second : float

var time_until_shooting : float

func _ready() -> void:
	current_attacks_per_second = attacks_per_second
	time_until_shooting = 1 / attacks_per_second

func _process(delta: float) -> void:
	time_until_shooting -= delta
	if time_until_shooting <= 0:
		shoot()

func shoot() -> void:
	# Pick target as a forward pos
	var target = global_position - global_transform.basis.z

	if attack_mode == AttackMode.AUTO_AIMED:
		var entities_in_range : Array[Node3D] = entity_tracker.entities_within_detection_range

		if entities_in_range.is_empty():
			# Reset shoot timer
			time_until_shooting = 1 / current_attacks_per_second
			return

		# get closest entity
		var closest_entity = entities_in_range[0]
		for entity in entities_in_range:
			if global_position.distance_to(entity.global_position) < global_position.distance_to(closest_entity.global_position):
				closest_entity = entity

		target = closest_entity.global_position

	# Calculate direction towards target
	var shoot_direction = global_position.direction_to(target)

	spawn_projectiles(shoot_direction)

	# Reset shoot timer
	time_until_shooting = 1 / current_attacks_per_second

func spawn_projectiles(main_projectile_direction: Vector3) -> void:
	var tree_root = get_tree().root

	# Spawn and setup Projectiles
	for projectile_n in range(projectiles_per_attack):
		var projectile : Projectile = projectile_prefab.instantiate() as Projectile

		projectile.hitbox.damage_amount = projectile_damage
		projectile.hitbox.collision_mask = projectile_collision_mask

		projectile.projectile_speed = projectile_speed
		projectile.direction = main_projectile_direction
		projectile.position = global_position

		# Vector3(0, 0.7, -0.7)  →  atan2()  →  Rotation Angle (≈ -45°)
		projectile.rotation.y = atan2(main_projectile_direction.x, main_projectile_direction.z)

		tree_root.call_deferred("add_child", projectile)
