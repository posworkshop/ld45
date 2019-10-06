extends Node2D

var is_enlarged = false
var is_deflecting = false


var state = "idle"


func _process(delta):
	var direction = get_viewport().get_mouse_position() - (get_parent().get_viewport_rect().size / 2)
	if direction.x >= 0:
		position = get_parent().get_node("WeaponAnchorPoint").position
	else:
		position.x = -get_parent().get_node("WeaponAnchorPoint").position.x
		position.y = get_parent().get_node("WeaponAnchorPoint").position.y
	rotation = (direction - position).angle()


func attack():
	if state == "idle":
		state = "attacked"
		if is_enlarged:
			$AnimationPlayer.play("BigAttack")
		else:
			$AnimationPlayer.play("Attack")
		$AttackCooldownTimer.start()


func _on_AttackCooldownTimer_timeout():
	state = "idle"


func _on_Area2D_body_entered(body):
	body.hit()


func _on_Area2D_area_entered(area):
	if is_deflecting:
		area.reflect()
