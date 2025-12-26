class_name ExperienceOrb
extends RigidBody3D

enum State { IDLE, BOUNCING, CHASING }

@export var xp_value = 1
@export var flight_speed = 2
@export var bounce_back_force = 2
@export var bounce_back_duration = 0.25
@export var acceleration_rate = 40

var target_player: ProtoController = null
var state = State.IDLE

func _physics_process(delta):
	if state != State.CHASING:
		return

	gravity_scale = 0
	collision_layer = 0
	chase(delta)

func magnetize(player_node):
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

func _on_pickup_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		magnetize(body)

func bounce(player):
	var away_direction = (global_position - player.global_position).normalized()
	away_direction.y = 0.5
	linear_velocity = away_direction * bounce_back_force

func chase(delta):
	var direction = (target_player.global_position - global_position).normalized()
	linear_velocity = direction * flight_speed
	flight_speed *= pow(acceleration_rate, delta)

	if global_position.distance_to(target_player.global_position) < 1.0:
		collect()
