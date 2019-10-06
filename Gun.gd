extends Node2D

var state = "idle"
var is_spread_shot = false
var is_plant_explosive = false

signal explosive_planted(position)
signal bullet_fired(position, heading)

func _ready():
	connect("bullet_fired", get_node("/root/World"), "_on_Gun_bullet_fired")
	connect("explosive_planted", get_node("/root/World"), "_on_Gun_explosive_planted")

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
		var fired_from = $Sprite/BulletSpawn.get_global_transform().origin
		if is_plant_explosive:
			emit_signal("explosive_planted", fired_from)
		else:
			var direction = $Sprite/BulletSpawn.get_global_transform().origin - $Sprite/Aim.get_global_transform().origin
			emit_signal("bullet_fired", fired_from, direction)
			if is_spread_shot:
				direction = direction.rotated(0.3)
				emit_signal("bullet_fired", fired_from, direction)
				direction = direction.rotated(-0.6)
				emit_signal("bullet_fired", fired_from, direction)
		$AnimationPlayer.play("Shoot")
		$AttackCooldownTimer.start()


func _on_AttackCooldownTimer_timeout():
	state = "idle"


