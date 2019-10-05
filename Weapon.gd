extends Area2D

var state = "idle"


func _ready():
	pass # Replace with function body.

func change_direction(angle):
	rotation = angle


func _process(delta):
	pass


func attack():
	if state == "idle":
		state = "attacked"
		var colliding_bodies = get_overlapping_bodies()
		for body in colliding_bodies:
			body.hit()
		
		$AttackCooldownTimer.start()


func _on_AttackCooldownTimer_timeout():
	state = "idle"
