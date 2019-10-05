extends RayCast2D

var state = "idle"
var reach = 75


func _ready():
	pass # Replace with function body.


func attack(target_direction):
	if state == "idle":
		cast_to = target_direction * reach
		state = "attacked"
		if is_colliding():
			var body = get_collider()
			body.hit()

		$AttackCooldownTimer.start()


func _on_AttackCooldownTimer_timeout():
	state = "idle"
