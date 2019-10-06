extends KinematicBody2D

signal got_hit
signal died

var health

var target
var speed = 300
var attack_range = 80
var attack_range_buffer = 0.9 # attack_range is the max range, 
var attack_state = "idle"


func _ready():
	health = 2
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
				$TongueAttack.rotation = distance.angle()
				$TongueAttack/AnimationPlayer.play("TongueAttack")
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


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.hit()
