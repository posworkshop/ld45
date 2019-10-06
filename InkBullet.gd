extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 800
var heading = Vector2()
var remaining_time = 5
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if heading.length() > 0:
		position += heading * speed * delta
		
		
	remaining_time -= delta
	
	if remaining_time <= 0:
		queue_free()

func set_position(initial_position):
	position = initial_position
	
	
func set_heading(initial_heading):
	heading = initial_heading.normalized()
	rotation = heading.angle()


func _on_InkBullet_body_entered(body):
	if body.name != "TileMap":
		body.hit()
		queue_free()


func reflect():
	speed = -speed
	set_collision_mask(3)
	
