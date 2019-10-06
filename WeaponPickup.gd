extends Area2D

signal picked_up

const NAME = "Sword"


func _ready():
	pass # Replace with function body.


func _on_WeaponPickup_body_entered(body):
	if body.name == "Player":
		emit_signal("picked_up")
	