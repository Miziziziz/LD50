extends KinematicBody2D


const MAX_SPEED = 8.0
const MOUSE_SENS = 1.0

export(NodePath) var stick_path 
var stick : RigidBody2D

var lost = false

signal game_lost
signal hand_pos_updated

func _ready():
	stick = get_node(stick_path)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	emit_signal("hand_pos_updated", global_position)

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().call_group("instanced", "queue_free")
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

var mouse_delta = Vector2()
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative * MOUSE_SENS

var hand_last_pos : Vector2
var stick_last_rotation = 0.0
var stick_time_stable = 0
var stick_max_time_stable = 0.4

func _physics_process(delta):
	var move_vec = mouse_delta
	mouse_delta = Vector2.ZERO
	var move_dist = move_vec.length()
	var move_dir = move_vec.normalized()
#	if move_dist > MAX_SPEED:
#		move_dist = MAX_SPEED
	move_and_collide(move_dir * move_dist)
	
	var v_r = get_viewport_rect().size
	global_position.x = clamp(global_position.x, 0, v_r.x)
	global_position.y = clamp(global_position.y, 0, v_r.y)
	emit_signal("hand_pos_updated", global_position)
	
	
	
	if !lost and stick.global_rotation_degrees > 0:
		lost = true
		$PinJoint2D.node_b = ""
		emit_signal("game_lost")
	
	if !lost:
		var s_r = stick.global_rotation_degrees
		if is_equal_approx(s_r, stick_last_rotation):
			stick_time_stable += delta
		if stick_time_stable > stick_max_time_stable:
			var push_dir = Vector2.RIGHT
			if s_r < -95:
				push_dir = Vector2.LEFT
			stick.apply_impulse(Vector2.UP * 30.0, push_dir * 1.0)
		if !hand_last_pos.is_equal_approx(global_position):
			stick_time_stable = 0.0
		stick_last_rotation = s_r
	hand_last_pos = global_position
