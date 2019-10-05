extends KinematicBody2D

signal got_hit
signal died

var health

var target
var speed = 200
var attack_range = 50

func _ready():
	health = 2
	connect("got_hit", self, "_ouch")


func _process(delta):
	
	if target && target.name == "Player":
		var distance = (position - target.position)
		if distance.length() > attack_range:
			var velocity = distance.normalized() * -speed
			move_and_slide(velocity)
	# when in ragne attack
	# when obstacle in way, move closer
	
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
