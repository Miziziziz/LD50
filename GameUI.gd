extends Control


onready var lose_message = $LoseMessage
onready var timer_display = $TimerDisplay
onready var rank_display = $RankDisplay

var time_alive = 0.0

var ranks = [
	[100.0, "Literally God"],
	[80.0, "One With The Stick"],
	[60.0, "Recess Chad"],
	[40.0, "Dinosaur Nerd"],
	[20.0, "Good At Math"],
	[0.0, "Snot-Nosed Brat"],
]

func _ready():
	visible = GameManager.game_started
	lose_message.hide()

func game_lost():
	timer_display.hide()
	rank_display.hide()
	lose_message.show()
	$LoseMessage/Score.text = get_timer_str()
	$LoseMessage/Rank.text = get_rank()
	set_process(false)

func _process(delta):
	time_alive += delta
	timer_display.text = get_timer_str()
	rank_display.text = get_rank()

func get_timer_str():
	return str(time_alive).pad_decimals(1) + "s"

func get_rank():
	for rank in ranks:
		if time_alive > rank[0]:
			return rank[1]
	return ranks[-1][1]
