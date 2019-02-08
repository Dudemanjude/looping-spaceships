extends Container

onready var tween : Tween = $Tween
onready var container : Node2D = $MovableContainer

var current_pos : int = 0

func move_to_next_position():
	move_to_position(current_pos + 1)

func move_to_position(pos : int):
	print(pos)
	tween.interpolate_property(container, "position", container.position, Vector2(125, 250*pos), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start() 
	current_pos = pos
