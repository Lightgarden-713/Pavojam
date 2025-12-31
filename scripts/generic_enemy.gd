extends RigidBody3D

@export_category("References")
@export var nav_agent: NavigationAgent3D
@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer

@export_category("Stats")
@export var speed = 1.0

@export_category("Drop")
@export var drops: Array[DropData]
@export var drop_force: float


func _ready() -> void:
	if health_component == null:
		push_error("Health Component not set up for enemy: " + name)

	health_component.health_depleted.connect(die)


func _process(_delta: float) -> void:
	_update_animation()


func _physics_process(_delta: float):
	# Get the next location on the path to the target
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()

	if nav_agent.is_target_reached():
		var direction_towards_target = current_location.direction_to(nav_agent.target_position)
		self.rotation.y = atan2(direction_towards_target.x, direction_towards_target.z)
		return

	# Calculate velocity towards that point
	var new_velocity = (next_location - current_location).normalized() * speed
	linear_velocity.x = new_velocity.x
	linear_velocity.z = new_velocity.z
	self.rotation.y = atan2(new_velocity.x, new_velocity.z)


# Call this from your main level script or a timer to update where the enemy wants to go
func update_target_location(target_position):
	nav_agent.target_position = target_position


func die() -> void:
	# Drop XP orbs
	var root_node = get_tree().root

	for drop_data in drops:
		var drop_prefab = drop_data.drop_prefab
		var amount_of_drops = drop_data.drop_amount

		for drop_n in range(amount_of_drops):
			var drop = drop_prefab.instantiate()
			var drop_rb = drop as RigidBody3D

			# TODO: use body collision shape instead of this
			drop.position = global_position + Vector3.UP
			drop_rb.linear_velocity = get_random_drop_direction() * drop_force

			root_node.call_deferred("add_child", drop)

	# Delte GO
	call_deferred("queue_free")


func get_random_drop_direction() -> Vector3:
	var dir = Vector3.UP
	var random_angle_radians = randf_range(0.0, 2 * PI)
	dir.x = cos(random_angle_radians)
	dir.z = sin(random_angle_radians)

	return dir.normalized()


func _update_animation() -> void:
	var horizontal_speed = Vector2(linear_velocity.x, linear_velocity.z).length()
	if horizontal_speed > 0.1 and animation_player.has_animation("walk") and not animation_player.is_playing():
		animation_player.play("walk")
