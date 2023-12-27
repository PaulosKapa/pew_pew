extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_input_event(_camera, _event, _position, _normal, _shape_idx):
	
	if Input.is_action_just_pressed("click"):
		get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_exit_input_event(_camera, _event, _position, _normal, _shape_idx):
	if Input.is_action_just_pressed("click"):
		get_tree().quit()
