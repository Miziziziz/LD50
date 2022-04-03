extends Control


onready var lose_message = $LoseMessage
onready var timer_display = $TimerDisplay
onready var rank_display = $RankDisplay

var time_alive = 0.0

const rank_increment = 10.0
var ranks = [
	"Snot-Nosed Brat",
	"Velcro Sneakers",
	"Uses Stickers",
	"Good At Math",
	"Dinosaur Nerd",
	"Recess Chad",
	"One With The Stick",
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
	var last_rank = ranks[0]
	for i in range(ranks.size()):
		if time_alive < i * rank_increment:
			break
		last_rank = ranks[i]
	return last_rank
