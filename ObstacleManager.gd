extends Node2D

onready var wind_zones = $WindZones.get_children()

var time_alive = 0.0

func end_game():
	set_process(false)

func _ready():
	if !GameManager.game_started:
		set_process(false)

func _process(delta):
	time_alive += delta
	if time_alive > 3.0:
#		wind_bot.set_active_for_time(4.0)
		set_process(false)
