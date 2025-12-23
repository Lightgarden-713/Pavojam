extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@export var speed = 1.0

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	# Get the next location on the path to the target
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	
	# Calculate velocity towards that point
	var new_velocity = (next_location - current_location).normalized() * speed
	velocity.x = new_velocity.x
	velocity.z = new_velocity.z
	
	move_and_slide()

# Call this from your main level script or a timer to update where the enemy wants to go
func update_target_location(target_position):
	nav_agent.target_position = target_position
