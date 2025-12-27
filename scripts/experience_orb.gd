class_name ExperienceOrb
extends RigidBody3D

enum State { SPAWNING, IDLE, BOUNCING, CHASING }

@export_group("References")
@export var pickup_range : Area3D

@export_group("XP config")
@export var xp_value = 1

@export_group("Orb movement config")
@export var flight_speed = 2
@export var bounce_back_force = 2
@export var bounce_back_duration = 0.25
@export var acceleration_rate = 40

var target_player: ProtoController = null
var state = State.SPAWNING

func _ready() -> void:
	# Disable magnet until we exit the SPAWNING state
	pickup_range.monitoring = false

func _physics_process(delta):
	if state == State.SPAWNING:
		return

	if state != State.IDLE:
		gravity_scale = 0
		collision_layer = 0

	if state != State.CHASING:
		return

	chase(delta)

func magnetize(player_node: ProtoController):
	if target_player:
		return
	target_player = player_node
	state = State.BOUNCING
	bounce(player_node)

	await get_tree().create_timer(bounce_back_duration).timeout
	state = State.CHASING

func collect():
	target_player.xp_component.add_xp(xp_value)
	queue_free()

func bounce(player: ProtoController):
	var away_direction = (global_position - player.global_position).normalized()
	away_direction.y += 0.5 # fly a little upwards

	linear_velocity = away_direction * bounce_back_force

func chase(delta):
	var direction = (target_player.global_position + Vector3(0,0.5,0) - global_position).normalized()
	linear_velocity = direction * flight_speed
	flight_speed *= pow(acceleration_rate, delta)

	if global_position.distance_to(target_player.global_position) < 1.0:
		collect()

func _on_pickup_range_body_entered(player: ProtoController) -> void:
	print("body entered")

	if player != null:
		magnetize(player)

# Only body colliding with xp ball is the level geometry
func _on_body_entered(_body: Node) -> void:
	print("Touched Ground")
	state = State.IDLE
	# enable magnet
	pickup_range.monitoring = true
