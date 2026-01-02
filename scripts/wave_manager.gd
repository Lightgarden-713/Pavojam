class_name WaveManager
extends Node3D

@export var enemy_scene: PackedScene = preload("res://scenes/enemies/rat_enemy.tscn")
@export var miniboss_scene: PackedScene = preload("res://scenes/enemies/miniboss.tscn")

@export_category("Timing")
@export var initial_delay_sec := 5.0
@export var time_between_waves_sec := 15.0
@export var spawn_wait_time := 0.2 # time to wait before spawning a second enemy to avoid collapsed enemies

@export_category("Wave Size")
@export var base_enemies := 10
@export var increase_per_wave := 5

var rand = RandomNumberGenerator.new()
var wave_number: int = 0
var time_until_next_wave: float = 0.0

signal wave_started(wave_number: int)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_until_next_wave = initial_delay_sec


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time_until_next_wave > 0:
		time_until_next_wave -= delta

		if time_until_next_wave <= 0:
			_start_next_wave()


func _start_next_wave():
	wave_number += 1
	wave_started.emit(wave_number)

	var enemies_to_spawn = base_enemies + increase_per_wave * wave_number
	for i in enemies_to_spawn:
		_spawn_enemy(enemy_scene)
		await get_tree().create_timer(spawn_wait_time).timeout

	if is_miniboss_wave():
		var miniboss = _spawn_enemy(miniboss_scene)
		miniboss.health_component.health_depleted.connect(_on_miniboss_killed, CONNECT_ONE_SHOT)

	# on miniboss_waves we wait until the miniboss is slained to go to the next wave
	if !is_miniboss_wave():
		time_until_next_wave = time_between_waves_sec


func _spawn_enemy(enemy_to_spawn: PackedScene) -> GenericEnemy:
	var enemy = enemy_to_spawn.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = _get_spawn_position()

	return enemy


func _get_spawn_position() -> Vector3:
	var spawners_count = get_child_count() - 1
	var chosen_spawner_i = rand.randi_range(0, spawners_count)
	return get_child(chosen_spawner_i).global_position


func _on_miniboss_killed() -> void:
	time_until_next_wave = time_between_waves_sec


func is_miniboss_wave() -> bool:
	return wave_number % 3 == 0
