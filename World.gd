extends Node2D

var starting_zone = preload("res://StartingZone.tscn")
var stage_one = preload("res://Stage1.tscn")

var weapon = preload("Weapon.tscn")

var current_zone

func _ready():
	current_zone = starting_zone.instance()
	current_zone.connect("next_stage", self, "_on_StartingZone_next_stage")
	add_child(current_zone)
	$Player.position = current_zone.get_node("PlayerSpawn").position
	$WeaponPickup.position = current_zone.get_node("WeaponSpawn").position


func _on_WeaponPickup_picked_up(item):
	if item.NAME == "Weapon":
		$Player.pickup_weapon(weapon)


func _on_StartingZone_next_stage():
	print_debug("going to stage 1")
	call_deferred("remove_child", current_zone)
	current_zone = stage_one.instance()
	current_zone.connect("next_stage", self, "_on_Stage1_next_stage")
	call_deferred("add_child", current_zone)
	$Player.position = current_zone.get_node("PlayerSpawn").position


func _on_Stage1_next_stage():
	print_debug("going to stage 2")
