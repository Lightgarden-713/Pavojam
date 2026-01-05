class_name ProjectileAttack
extends Node3D

# TODO: test Auto aimed / Homing / Teledirected projectiles
enum AimMode { AIMED, AUTO_AIMED }
enum ShootMode { SEQUENTIAL, PARALLEL }

@export_group("References")
@export var projectile_prefab: PackedScene
@export var entity_tracker: EntityTracker

@export_group("Attack Stats")
@export var projectile_damage: float
@export var projectile_speed: float
@export var aim_mode: AimMode
@export var shoot_mode: ShootMode
@export var attacks_per_second: float
@export var projectiles_per_attack: int

@export_subgroup("Sequential Shooting Stats")
@export var time_between_projectiles: float

@export_subgroup("Parallel Shooting Stats")
@export var angle_between_projectiles: float

@export_group("Projectile Config")
@export_flags_3d_physics var projectile_collision_mask: int

# Upgradable Stats
var current_projectile_damage: float
var current_attacks_per_second: float
var current_projectiles_per_attack: int
var is_attacking: bool
var time_until_attacking: float
var time_until_next_projectile: float
var remaining_projectiles_for_current_attack: int


func _ready() -> void:
	current_attacks_per_second = attacks_per_second
	current_projectiles_per_attack = projectiles_per_attack
	current_projectile_damage = projectile_damage
	time_until_attacking = 1 / attacks_per_second
	remaining_projectiles_for_current_attack = current_projectiles_per_attack


func _process(delta: float) -> void:
	time_until_attacking -= delta
	time_until_next_projectile -= delta
	if time_until_attacking <= 0:
		start_attack()

	if (is_attacking and
		remaining_projectiles_for_current_attack > 0 and
		time_until_next_projectile <= 0 ):
		shoot()


func start_attack() -> void:
	remaining_projectiles_for_current_attack = current_projectiles_per_attack
	time_until_next_projectile = 0 # First one fires instantly
	is_attacking = true
	time_until_attacking = 1 / current_attacks_per_second


func end_attack() -> void:
	is_attacking = false


func shoot() -> void:
	var entities_in_range: Array[Node3D] = []
	entities_in_range.append_array(entity_tracker.entities_within_detection_range)

	if aim_mode == AimMode.AUTO_AIMED and len(entities_in_range) == 0:
		# Consume shot
		if shoot_mode == ShootMode.SEQUENTIAL:
			remaining_projectiles_for_current_attack -= 1
			time_until_next_projectile = time_between_projectiles
			if remaining_projectiles_for_current_attack == 0:
				end_attack()
		elif shoot_mode == ShootMode.PARALLEL:
			end_attack()

		return

	# Calculate direction towards target
	var shoot_direction = get_aim_direction(entities_in_range)

	if shoot_mode == ShootMode.SEQUENTIAL:
		spawn_projectile(shoot_direction)

		remaining_projectiles_for_current_attack -= 1
		time_until_next_projectile = time_between_projectiles
	elif shoot_mode == ShootMode.PARALLEL:
		# get a "semicircle" centered at the shoot direction and shoot all projectiles
		var up_vector = global_transform.basis.y
		# Start from the furthest angle and start adding `angle_between projectiles`
		var offset_rotation = angle_between_projectiles * (remaining_projectiles_for_current_attack / 2.0)
		offset_rotation *= -1

		for projectile_n in range(remaining_projectiles_for_current_attack):
			spawn_projectile(shoot_direction.rotated(up_vector, deg_to_rad(offset_rotation)))
			offset_rotation += angle_between_projectiles

		remaining_projectiles_for_current_attack = 0

	if remaining_projectiles_for_current_attack <= 0:
		end_attack()


## Assume we always have at least one entity in range for autoaimed attacks, otherwise we don't even call this.
func get_aim_direction(entities_in_range: Array[Node3D]) -> Vector3:
	if aim_mode == AimMode.AIMED:
		# Forward direction
		return global_transform.basis.z
	elif aim_mode == AimMode.AUTO_AIMED:
		if entities_in_range.is_empty():
			return Vector3.ZERO

		# get closest entity
		var closest_entity = entities_in_range[0]
		for entity in entities_in_range:
			if global_position.distance_to(entity.global_position) < global_position.distance_to(closest_entity.global_position):
				closest_entity = entity

		return global_position.direction_to(closest_entity.global_position)

	return Vector3.ZERO


func spawn_projectile(projectile_direction: Vector3) -> void:
	var tree_root = get_tree().root

	var projectile: Projectile = projectile_prefab.instantiate() as Projectile

	projectile.hitbox.damage_amount = current_projectile_damage
	projectile.hitbox.collision_mask = projectile_collision_mask

	projectile.projectile_speed = projectile_speed
	projectile.direction = projectile_direction
	projectile.position = global_position

	# Vector3(0, 0.7, -0.7)  →  atan2()  →  Rotation Angle (≈ -45°)
	projectile.rotation.y = atan2(projectile_direction.x, projectile_direction.z)

	tree_root.call_deferred("add_child", projectile)
