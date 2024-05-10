extends Node3D
var walls = [Global.test_wall]

# Called when the node enters the scene tree for the first time.
func _ready():
	$NavigationRegion3D/wall_spawner/spawner1.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner2.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner3.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner4.add_child(walls.pick_random().instantiate())
	await get_tree().create_timer(2).timeout
	$NavigationRegion3D.bake_navigation_mesh()
	print($NavigationRegion3D.bake_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
