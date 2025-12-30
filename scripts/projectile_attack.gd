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
@export var projectiles_per_attack: int

@export_group("Projectile Config")
@export_flags_3d_physics var projectile_collision_mask : int

# Upgradable Stats
var current_attacks_per_second : float
var current_projectiles_per_attack : float

var time_until_shooting : float

func _ready() -> void:
	current_attacks_per_second = attacks_per_second
	current_projectiles_per_attack = projectiles_per_attack
	time_until_shooting = 1 / attacks_per_second

func _process(delta: float) -> void:
	time_until_shooting -= delta
	if time_until_shooting <= 0:
		shoot()

func shoot() -> void:
	var entities_in_range : Array[Node3D] = []
	entities_in_range.append_array(entity_tracker.entities_within_detection_range)

	for projectile_n in range(current_projectiles_per_attack):
		# Pick target as a forward pos
		var target = global_position - global_transform.basis.z

		if attack_mode == AttackMode.AUTO_AIMED:

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

			# Can only target once per shooting
			entities_in_range.erase(closest_entity)

		# Calculate direction towards target
		var shoot_direction = global_position.direction_to(target)

		spawn_projectile(shoot_direction)

	# Reset shoot timer
	time_until_shooting = 1 / current_attacks_per_second

func spawn_projectile(projectile_direction: Vector3) -> void:
	var tree_root = get_tree().root

	var projectile : Projectile = projectile_prefab.instantiate() as Projectile

	projectile.hitbox.damage_amount = projectile_damage
	projectile.hitbox.collision_mask = projectile_collision_mask

	projectile.projectile_speed = projectile_speed
	projectile.direction = projectile_direction
	projectile.position = global_position

	# Vector3(0, 0.7, -0.7)  →  atan2()  →  Rotation Angle (≈ -45°)
	projectile.rotation.y = atan2(projectile_direction.x, projectile_direction.z)

	tree_root.call_deferred("add_child", projectile)
