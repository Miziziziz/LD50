extends Node2D

onready var wind_zones = $WindZones.get_children()

var time_alive = 0.0

var rock_obj = preload("res://RockThrow.tscn")
var rng : RandomNumberGenerator

var time_to_activate_wind = 10.0
var time_to_throw_rocks = 20.0
var rocks_double_time = 4.0

var wind_time = 4.0
var min_wind_inc = 6.0
var max_wind_inc = 10.0

var min_rock_throw_inc = 5.0
var max_rock_throw_inc = 10.0

func end_game():
	set_process(false)

func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = 666

	if !GameManager.game_started:
		set_process(false)

func _process(delta):
	time_alive += delta
	if time_alive > time_to_activate_wind:
		activate_wind()
		time_to_activate_wind += rng.rand_range(min_wind_inc, max_wind_inc)
	if time_alive > time_to_throw_rocks:
		spawn_rock()
		var rt = rng.rand_range(min_rock_throw_inc, max_rock_throw_inc)
		if time_alive > rocks_double_time:
			rt /= 2.0
		time_to_throw_rocks += rt


func activate_wind():
	var wz = wind_zones[rng.randi()%wind_zones.size()]
	wz.set_active_for_time(4.0)
	$WindSound.play()

const rock_top_height = 70.0
const rock_bot_height = 530.0
func spawn_rock():
	var rock_inst = rock_obj.instance()
	get_tree().get_root().add_child(rock_inst)
	var spawn_left = rng.randi() % 2 == 0
	rock_inst.global_position.x = $RockSpawnPoints/SpawnLeft.global_position.x
	if !spawn_left:
		rock_inst.global_rotation_degrees = 180.0
		rock_inst.global_position.x = $RockSpawnPoints/SpawnRight.global_position.x
	rock_inst.global_position.y = rng.rand_range(rock_top_height, rock_bot_height)
