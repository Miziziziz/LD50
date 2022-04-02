extends Control


func _ready():
	visible = !GameManager.game_started
