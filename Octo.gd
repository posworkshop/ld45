extends KinematicBody2D

signal got_hit
signal died

var health

var target
var speed = 150
var attack_range = 400
var attack_range_buffer = 0.8 # attack_range is the max range, 
var attack_state = "idle"

var ink_bullet_scene  = preload("res://InkBullet.tscn")

func _ready():
	health = 4
	connect("got_hit", self, "_ouch")


func _process(delta):
	
	if target && target.name == "Player":
		var distance = (target.position - position)
		if distance.length() > (attack_range * attack_range_buffer):
			var velocity = distance.normalized() * speed
			move_and_slide(velocity)

		if distance.length() <= (attack_range):
			if attack_state == "idle":
				attack_state = "attacked"
				var bullet = ink_bullet_scene.instance()
				bullet.set_position(position)
				bullet.set_heading(distance)
				get_parent().add_child(bullet)
				$AttackCooldownTimer.start()
	
	if health <= 0:
		emit_signal("died")
		queue_free()


func hit():
	emit_signal("got_hit")


func _ouch():
	health -= 1
	print_debug("ouch")


func target_player(player):
	target = player


func _on_AttackCooldownTimer_timeout():
	attack_state = "idle"
