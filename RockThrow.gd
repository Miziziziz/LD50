extends Node2D

onready var rock = $Rock
const throw_force = 60000.0

func _ready():
	rock.connect("body_entered", self, "on_hit")
	$PrepSound.play()

func throw():
	rock.mode = RigidBody2D.MODE_RIGID
	rock.apply_central_impulse(global_transform.x*throw_force)
	rock.gravity_scale = 0.0
	$ThrowSound.play()


func on_hit(body: PhysicsBody2D):
	get_tree().call_group("player", "drop_stick", true)
	rock.gravity_scale = 1.0
