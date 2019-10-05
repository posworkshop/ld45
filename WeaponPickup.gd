extends Area2D

signal picked_up(item)

const NAME = "Weapon"


func _ready():
	pass # Replace with function body.


func _on_WeaponPickup_body_entered(body):
	if body.name == "Player":
		hide()
		emit_signal("picked_up", self)
		$CollisionShape2D.set_deferred("disabled", true)
	