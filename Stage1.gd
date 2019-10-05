extends Node2D

signal next_stage

export (PackedScene) var Enemy

var enemy_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy_spawns = $EnemySpawns.get_children()
	var player = get_parent().get_node("Player")
	
	for spawn in enemy_spawns:
		var enemy = Enemy.instance()
		enemy.position = spawn.position
		enemy.connect("died", self, "_on_Enemy_died")
		enemy.target_player(player)
		enemy_count +=1
		call_deferred("add_child", enemy)


func _on_Enemy_died():
	enemy_count -= 1
	if enemy_count <= 0:
		$StageTransition/CollisionShape2D.disabled = false
		$StageTransition.show()


func _on_StageTransition_body_entered(body):
	if body.name == "Player":
		emit_signal("next_stage")
		$StageTransition.hide()
		$StageTransition/CollisionShape2D.set_deferred("disabled", true)
