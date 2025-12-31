# ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person games.
# Happy prototyping!

class_name ProtoController
extends CharacterBody3D

@export_group("References")
@export var body_mesh_node : Node3D

@export_group("Player component references")
@export var health_component : HealthComponent
@export var xp_component : XPComponent
@export var projectile_attack_component : ProjectileAttack
@export var hurtbox_component : HurtboxComponent

@export_group("Camera")

## Camera pitch clamp (degrees). Increase magnitude to allow looking further up/down.
@export_range(-89.0, 0.0, 0.5) var look_pitch_min_deg := -85.0
@export_range(0.0, 89.0, 0.5) var look_pitch_max_deg := 85.0

## Can we move around?
@export var can_move : bool = true
## Are we affected by gravity?
@export var has_gravity : bool = true
## Can we press to jump?
@export var can_jump : bool = true
## Can we hold to run?
@export var can_sprint : bool = false
## Can we press to enter freefly mode (noclip)?
@export var can_freefly : bool = false

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 7.0
## Speed of jump.
@export var jump_velocity : float = 4.5
## How fast do we run?
@export var sprint_speed : float = 10.0
## How fast do we freefly?
@export var freefly_speed : float = 25.0

@export_group("Knockback")
@export var knockback_force_duration : float = .75
@export var knockback_falloff_duration : float = .25
@export var knockback_falloff_curve : Curve
@export var knockback_max_vertical_angle_deg : float = 60

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var input_left : String = "ui_left"
## Name of Input Action to move Right.
@export var input_right : String = "ui_right"
## Name of Input Action to move Forward.
@export var input_forward : String = "ui_up"
## Name of Input Action to move Backward.
@export var input_back : String = "ui_down"
## Name of Input Action to Jump.
@export var input_jump : String = "ui_accept"
## Name of Input Action to Sprint.
@export var input_sprint : String = "sprint"
## Name of Input Action to toggle freefly mode.
@export var input_freefly : String = "freefly"

# Upgradable stats
var current_base_speed : float

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0
var freeflying : bool = false
var knockback_timer : float = 0.0
var knockback_vector : Vector3

## IMPORTANT REFERENCES
@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider

func _ready() -> void:
	# Initialize stats
	current_base_speed = base_speed

	check_knockback_stats()
	check_input_mappings()
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x

	hurtbox_component.on_hit.connect(_handle_on_hit)

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()

	# Look around
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)

	# Toggle freefly mode
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()

func _physics_process(delta: float) -> void:
	# If freeflying, handle freefly and nothing else
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		# align body_mesh_node with motion direction
		if input_dir.length_squared() > 0.1:
			body_mesh_node.look_at(body_mesh_node.global_position + motion, global_basis.y, true)

		motion *= freefly_speed * delta
		move_and_collide(motion)
		return

	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Apply jumping
	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity

	# Modify speed based on sprinting
	if can_sprint and Input.is_action_pressed(input_sprint):
			move_speed = sprint_speed
	else:
		move_speed = current_base_speed

	# Apply desired movement to velocity
	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		# align body_mesh_node with motion direction
		if input_dir.length_squared() > 0.1:
			body_mesh_node.look_at(body_mesh_node.global_position + move_dir, global_basis.y, true)

		if move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.y = 0
		velocity.z = 0

	# If we're getting knocked back
	if knockback_timer <= knockback_force_duration:
		knockback_timer += delta

		var current_knockback_force = knockback_vector

		var falloff_start_time = knockback_force_duration - knockback_falloff_duration
		if knockback_timer > falloff_start_time:
			var normalized_knockback_falloff_time = (knockback_timer - falloff_start_time) / knockback_falloff_duration
			var knockback_effective_factor = 1 - knockback_falloff_curve.sample(normalized_knockback_falloff_time)
			current_knockback_force *= knockback_effective_factor

		velocity += current_knockback_force

		if knockback_timer >= knockback_force_duration:
			can_move = true

	# Use velocity to actually move
	move_and_slide()

## Rotate us to look around.
## Base of controller rotates around y (left/right). Head rotates around x (up/down).
## Modifies look_rotation based on rot_input, then resets basis and rotates by look_rotation.
func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(look_pitch_min_deg), deg_to_rad(look_pitch_max_deg))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)


func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false


func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false


## Checks if some Input Actions haven't been created.
## Disables functionality accordingly.
func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false
	if can_jump and not InputMap.has_action(input_jump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + input_jump)
		can_jump = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false
	if can_freefly and not InputMap.has_action(input_freefly):
		push_error("Freefly disabled. No InputAction found for input_freefly: " + input_freefly)
		can_freefly = false

func check_knockback_stats() -> void:
	if knockback_falloff_duration > knockback_force_duration:
		push_error("Knockback falloff cannot be greater than the total knockback duration")

func apply_knockback(knockback_direction: Vector3) -> void:
	knockback_vector = knockback_direction
	knockback_timer = 0
	can_move = false

func _handle_on_hit(incoming_hitbox : HitboxComponent) -> void:
	if incoming_hitbox.knockback_force == 0:
		return

	# calculate knockback direction (might improve if we use collision shape centers)
	var knockback_dir = incoming_hitbox.global_position.direction_to(hurtbox_component.global_position)

	# cardinal to polar (r = 1)
	var theta = atan2(knockback_dir.z, knockback_dir.x)
	var phi = atan2(knockback_dir.y, Vector2(knockback_dir.x, knockback_dir.z).length())

	# clamp vertical angle
	phi = clamp(phi, -deg_to_rad(knockback_max_vertical_angle_deg), deg_to_rad(knockback_max_vertical_angle_deg))

	# go back to cartesian coords (use sin on Y axis so it keeps symmetrical on (-angle, angle))
	knockback_dir = Vector3(cos(phi) * cos(theta), sin(phi), cos(phi) * sin(theta))

	apply_knockback(incoming_hitbox.knockback_force * knockback_dir.normalized())
