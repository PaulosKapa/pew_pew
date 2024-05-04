extends Control

var escape_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():

	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("pause")):
		match escape_pressed:
				false:
					$".".show()
					
					get_tree().paused = true
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					escape_pressed = true
				true:
					$".".hide()
					get_tree().paused = false
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					escape_pressed = false


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
