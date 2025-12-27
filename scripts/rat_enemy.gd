extends "res://scripts/generic_enemy.gd"

@export var animation_player: AnimationPlayer

func _ready() -> void:
	super._ready()
	# Any rat-specific setup here

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	# Play walk animation based on movement
	_update_animation()

func _update_animation() -> void:
	if animation_player == null:
		return
	

	var horizontal_speed = Vector2(velocity.x, velocity.z).length()
	if horizontal_speed > 0.1 and not animation_player.is_playing():
		animation_player.play("walk")
