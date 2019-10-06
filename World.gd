extends Node2D

signal upgrade_gun_with_spread_shot
signal upgrade_gun_with_timed_explosive

signal upgrade_sword_with_deflect
signal upgrade_sword_with_enlarge

signal weapon_picked_up
var weapon_picked_up_signal_fired = false

var starting_zone = preload("res://StartingZone.tscn")
var upgrade_zone = preload("res://UpgradeZone.tscn")
var stage_one = preload("res://Stage1.tscn")
var stage_two = preload("res://Stage2.tscn")
var stage_two_divided = preload("res://Stage2_divided.tscn")


var sword = preload("Sword.tscn")
var gun = preload("Gun.tscn")

var bullet_scene = preload("Bullet.tscn")
var explosive_scene = preload("Explosive.tscn")

var current_zone

var picked_sword = false
var picked_gun = false

var go_to_divided_stage_two = false

func _ready():
	current_zone = starting_zone.instance()
	current_zone.connect("next_stage", self, "_on_StartingZone_next_stage")
	connect("weapon_picked_up", current_zone, "_on_World_weapon_picked")
	add_child(current_zone)
	$Player.position = current_zone.get_node("PlayerSpawn").position
	$WeaponPickup.position = current_zone.get_node("ItemSpawn1").position
	$WeaponPickup.show()
	$GunPickup.position = current_zone.get_node("ItemSpawn2").position
	$GunPickup.show()


func _on_StartingZone_next_stage():
	call_deferred("remove_child", current_zone)
	current_zone = stage_one.instance()
	current_zone.connect("next_stage", self, "_on_Stage1_next_stage")
	call_deferred("add_child", current_zone)
	$Player.position = current_zone.get_node("PlayerSpawn").position
	$WeaponPickup.hide()
	$WeaponPickup/CollisionShape2D.set_deferred("disabled", true)
	$GunPickup.hide()
	$GunPickup/CollisionShape2D.set_deferred("disabled", true)
	

func _on_Stage1_next_stage():
	call_deferred("remove_child", current_zone)
	current_zone = upgrade_zone.instance()
	current_zone.connect("next_stage", self, "_on_UpgradeZone_next_stage")
	call_deferred("add_child", current_zone)
	$Player.position = current_zone.get_node("PlayerSpawn").position
	if picked_gun:
		$SpreadShotPickup.position = current_zone.get_node("UpgradeSpawn1").position
		$SpreadShotPickup.show()
		$ExplosivePickup.position = current_zone.get_node("UpgradeSpawn2").position
		$ExplosivePickup.show()
	elif picked_sword:
		$DeflectPickup.position = current_zone.get_node("UpgradeSpawn1").position
		$DeflectPickup.show()
		$EnlargePickup.position = current_zone.get_node("UpgradeSpawn2").position
		$EnlargePickup.show()

	
func _on_UpgradeZone_next_stage():
	call_deferred("remove_child", current_zone)

	if go_to_divided_stage_two:
		current_zone = stage_two_divided.instance()
	else:
		current_zone = stage_two.instance()

	current_zone.connect("next_stage", self, "_on_stage_two_cleared")
	call_deferred("add_child", current_zone)
	$Player.reset_health()
	$Player.position = current_zone.get_node("PlayerSpawn").position
	$SpreadShotPickup/CollisionShape2D.set_deferred("disabled", true)
	$SpreadShotPickup.hide()
	$ExplosivePickup/CollisionShape2D.set_deferred("disabled", true)
	$ExplosivePickup.hide()
	$DeflectPickup/CollisionShape2D.set_deferred("disabled", true)
	$DeflectPickup.hide()
	$EnlargePickup/CollisionShape2D.set_deferred("disabled", true)
	$EnlargePickup.hide()
	
		
		
func _on_WeaponPickup_picked_up():
	if !weapon_picked_up_signal_fired:
		emit_signal("weapon_picked_up")
	picked_gun = false
	picked_sword = true
	$Player.pickup_weapon(sword)


func _on_GunPickup_picked_up():
	if !weapon_picked_up_signal_fired:
		emit_signal("weapon_picked_up")
	picked_gun = true
	picked_sword = false
	$Player.pickup_weapon(gun)
	
func _on_Gun_bullet_fired(position, heading):
	
	var bullet = bullet_scene.instance()
	bullet.set_position(position)
	bullet.set_heading(heading)
	add_child(bullet)


func _on_Gun_explosive_planted(position):
	var explosive = explosive_scene.instance()
	explosive.set_position(position)
	add_child(explosive)

func _on_DeflectPickup_picked_up():
	go_to_divided_stage_two = true
	$Player.set_sword_to_deflect()


func _on_EnlargePickup_picked_up():
	go_to_divided_stage_two = false
	$Player.set_sword_to_enlarge()


func _on_SpreadShotPickup_picked_up():
	go_to_divided_stage_two = false
	$Player.set_gun_to_spread_shot()


func _on_ExplosivePickup_picked_up():
	go_to_divided_stage_two = false
	$Player.set_gun_to_explosive()


func _on_Player_died():
	$Player/Camera2D/HUD/DiedLabel.visible = true
	
func _on_stage_two_cleared():
	$Player/Camera2D/HUD/WinLabel.visible = true
	