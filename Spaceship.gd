extends KinematicBody2D

export var player_num : int = 1
export var speed : float = 600
export var health : int = 3

onready var shoot_pos : Position2D = $ShootPosition

var my_box : StaticBody2D
var their_box : StaticBody2D

var bullet : Resource = preload("res://Bullet.tscn")
var aim_dir : Vector2 = Vector2.RIGHT

onready var cooldown : Timer = $"ShootCooldown"
var can_shoot : bool = true

func _ready():
	my_box = get_node("../../Box" + str(player_num))
	if player_num == 1:
		their_box = $"../../Box2"
	else :
		their_box = $"../../Box1"

func _process(delta):
	var current_aim_dir : Vector2 = Vector2(Input.get_joy_axis(player_num-1, JOY_ANALOG_RX), Input.get_joy_axis(player_num-1, JOY_ANALOG_RY)) 
	if current_aim_dir.length() > 0.1:
		aim_dir = current_aim_dir
		look_at(aim_dir + global_position)
	
	if Input.is_action_just_pressed("shoot_" + str(player_num)) and can_shoot:
		can_shoot = false
		cooldown.start()
		
		var newBullet : KinematicBody2D = bullet.instance()
		newBullet.global_position = shoot_pos.global_position
		newBullet.dir = aim_dir.normalized()
		
		newBullet.current_box = my_box
		newBullet.other_box = their_box
		
		$"../..".add_child(newBullet)

func _physics_process(delta : float):
	#var movement : Vector2 = Vector2(Input.get_action_strength("move_right_" + str(player_num)) -
	#		 Input.get_action_strength("move_left_" + str(player_num)),
	#		 Input.get_action_strength("move_down_" + str(player_num)) - Input.get_action_strength("move_up_" + str(player_num)))
	var movement : Vector2 = Vector2(Input.get_joy_axis(player_num-1, JOY_ANALOG_LX), Input.get_joy_axis(player_num-1, JOY_ANALOG_LY))
	if movement.length() > 0.1:
		move_and_slide(movement * speed)

func take_damage(damage : int):
	health -= damage
	if health <= 0:
		queue_free()

func _on_ShootCooldown_timeout():
	can_shoot = true
