extends Node2D

signal next_stage

var frog_scene = preload("res://Frog.tscn")
var octo_scene = preload("res://Octo.tscn")
var jellyfish_scene = preload("res://Jellyfish.tscn")

var enemy_count = 0
var enemy_types = [frog_scene, octo_scene, jellyfish_scene]
# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy_spawns = $EnemySpawns.get_children()
	var player = get_node("/root/World/Player")
	
	for index in range(0, enemy_spawns.size()):
		var enemy = enemy_types[index % 3].instance()
#		var enemy = jellyfish_scene.instance()
#		var enemy = octo_scene.instance()
#		var enemy = frog_scene.instance()
		
		enemy.position = enemy_spawns[index].position
		enemy.connect("died", self, "_on_Enemy_died")
		enemy.target_player(player)
		enemy_count +=1
		call_deferred("add_child", enemy)
#
#	for spawn in enemy_spawns:


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
