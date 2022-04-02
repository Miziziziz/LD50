extends Control


onready var lose_message = $LoseMessage
onready var timer_display = $TimerDisplay

var time_alive = 0.0

func _ready():
	lose_message.hide()

func game_lost():
	timer_display.hide()
	lose_message.show()
	$LoseMessage/Score.text = get_timer_str()
	set_process(false)

func _process(delta):
	time_alive += delta
	timer_display.text = get_timer_str()

func get_timer_str():
	return str(time_alive).pad_decimals(1) + "s"
