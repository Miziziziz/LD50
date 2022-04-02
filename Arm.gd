extends Position2D


onready var elbow = $Elbow
onready var hand = $Elbow/HandPos
var upper_arm_length  = 0.0
var lower_arm_length = 0.0
var total_arm_length = 0.0

var min_hand_dist = 30

func _ready():
	upper_arm_length = elbow.position.x
	lower_arm_length = hand.position.x
	total_arm_length = upper_arm_length + lower_arm_length

#func _process(delta):
#	update_arm_graphics()

var goal_hand_pos : Vector2
func set_goal_hand_pos(h_p: Vector2):
	goal_hand_pos = h_p + Vector2.LEFT * 25.0
	update_arm_graphics()

func update_arm_graphics():
	var shoulder_pos = global_position
	var hand_pos = goal_hand_pos
	var shoulder_to_hand = hand_pos - shoulder_pos
	var shoulder_to_hand_dist = shoulder_to_hand.length()
	shoulder_to_hand_dist = clamp(shoulder_to_hand_dist, min_hand_dist, total_arm_length)
	global_rotation = atan2(shoulder_to_hand.y, shoulder_to_hand.x)
	var angles = SSS_calc(upper_arm_length, lower_arm_length, shoulder_to_hand_dist)
	global_rotation += angles.B
	elbow.rotation = angles.C

func SSS_calc(side_a, side_b, side_c):
	if side_c >= side_a + side_b:
		return {"A": 0, "B": 0, "C": 0}
	var angle_a = law_of_cos(side_b, side_c, side_a)
	var angle_b = law_of_cos(side_c, side_a, side_b) + PI
	var angle_c = PI - angle_a - angle_b
	
	return {"A": angle_a, "B": angle_b-PI, "C": angle_c}

func law_of_cos(a, b, c):
	if 2 * a * b == 0:
		return 0
	return acos( (a * a + b * b - c * c) / ( 2 * a * b) )
