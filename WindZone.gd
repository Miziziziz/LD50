extends Area2D

var wind_force = 50.0

var active_time = 0.0
var warmup_time_left = 0.0
const WARMUP_TIME = 1.0
var active = false

export var facing_right = true

func _physics_process(delta):
	if warmup_time_left > 0.0:
		$Wind.emitting = true
		warmup_time_left -= delta
	elif warmup_time_left <= 0.0 and active_time > 0.0:
		active_time -= delta
		for body in get_overlapping_bodies():
			if body is RigidBody2D:
				var dir = Vector2.RIGHT
				if !facing_right:
					dir = Vector2.LEFT
				body.apply_central_impulse(wind_force * dir)
	else:
		$Wind.emitting = false

func set_active_for_time(t):
	active_time = t
	warmup_time_left = WARMUP_TIME
