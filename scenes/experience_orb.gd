extends RigidBody3D

@export var xp_value = 1
@export var flight_speed = 0.5

var target_player: ProtoController = null

func _physics_process(delta):
	if target_player:
		# 1. Turn off normal physics so we can fly freely
		gravity_scale = 0
		# Turn off collision so it doesn't get stuck on walls
		collision_layer = 0 
		
		# 2. Fly towards the player
		var direction = (target_player.global_position - global_position).normalized()
		linear_velocity = direction * flight_speed
		
		# 3. Accelerate over time for a snappy feel
		flight_speed += 3 * delta 

		# 4. Check if we reached the player (Pickup)
		var distance = global_position.distance_to(target_player.global_position)
		if distance < 1.0:
			collect()

# Called by the Player's magnet area
func magnetize(player_node):
	target_player = player_node
	# Give it a little pop up before flying
	linear_velocity.y += 2.0 

func collect():
	# TODO: Add logic to give XP to player
	print("Collected XP!")
	target_player
	queue_free()


func _on_pickup_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		magnetize(body)
