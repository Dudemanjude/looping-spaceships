extends KinematicBody2D

export var speed : float = 500

var times_teleported : int = 0

var dir : Vector2 = Vector2()
var current_box : StaticBody2D
var other_box : StaticBody2D

func _ready():
	yield(get_tree(), "idle_frame")
	look_at(global_position + dir)

func _physics_process(delta):
	var collision : KinematicCollision2D = move_and_collide(dir * speed * delta)
	
	if collision:
		if collision.collider.collision_layer == 1:
			times_teleported += 1
			
			if times_teleported > 1:
				queue_free()
			var offset = global_position - current_box.global_position
			global_position = other_box.global_position - offset
			
			var temp_box = current_box
			current_box = other_box
			other_box = temp_box
		elif collision.collider.collision_layer == 4 || collision.collider.collision_layer == 8:
			collision.collider.take_damage(1)
			queue_free()
		collision_mask = 13
	


