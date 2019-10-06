extends KinematicBody2D

signal got_hit

var speed = 300
var equipped_weapon
var unarmed_attack

export (PackedScene) var UnarmedAttack


func _ready():
	unarmed_attack = UnarmedAttack.instance()
	add_child(unarmed_attack)


func _physics_process(delta):
		
	var velocity = Vector2()
	if Input.is_action_pressed("movement_left"):
		velocity.x -= 1
	if Input.is_action_pressed("movement_right"):
		velocity.x += 1
	if Input.is_action_pressed("movement_up"):
		velocity.y -= 1
	if Input.is_action_pressed("movement_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	move_and_slide(velocity)
	
	if Input.is_action_just_pressed("weapon_attack"):
		_attack()
	
	var facing = (get_viewport().get_mouse_position() - (get_viewport_rect().size / 2)).normalized()
	if facing.y < 0:
		$AnimatedSprite.animation = "back"
	elif facing.x >= 0.3:
		$AnimatedSprite.animation = "right"
		pass
	elif facing.x <= -0.3:
		$AnimatedSprite.animation = "left"
		pass
	else:
		$AnimatedSprite.animation = "default"


func pickup_weapon(item):
	if equipped_weapon: 
		remove_child(equipped_weapon)

	var weapon = item.instance()
	equipped_weapon = weapon
	equipped_weapon.position = $WeaponAnchorPoint.position
	call_deferred("add_child", weapon)


func _attack():
	
	if equipped_weapon:
		equipped_weapon.attack()
	else:
		var target_direction = (get_viewport().get_mouse_position() - position).normalized()
		unarmed_attack.attack(target_direction)

func hit():
	print_debug("ahh")
	emit_signal("got_hit")
	

func set_sword_to_deflect():
	if equipped_weapon.name == "Sword":
		equipped_weapon.is_deflecting = true
		equipped_weapon.is_enlarged = false

func set_sword_to_enlarge():
	if equipped_weapon.name == "Sword":
		equipped_weapon.is_enlarged = true
		equipped_weapon.is_deflecting = false


func set_gun_to_spread_shot():
	if equipped_weapon.name == "Gun":
		equipped_weapon.is_spread_shot = true
		equipped_weapon.is_plant_explosive = false


func set_gun_to_explosive():
	if equipped_weapon.name == "Gun":
		equipped_weapon.is_plant_explosive = true
		equipped_weapon.is_spread_shot = false

