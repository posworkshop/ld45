extends Node2D

signal next_stage

func _on_StageTransision_body_entered(body):
	if body.name == "Player":
		emit_signal("next_stage")
		$StageTransision.hide()
		$StageTransision/CollisionShape2D.set_deferred("disabled", true)


func _on_World_weapon_picked():
	$StageTransision/CollisionShape2D.set_deferred("disabled", false)
	$StageTransision.show()