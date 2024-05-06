extends Node
#see rpc

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()
@onready var player = preload("res://scenes/player_teleportation.tscn")

# Called when the node enters the scene tree for the first time.

func _on_button_pressed():
	#join
	$Control.hide()
	enet_peer.create_client("localhost",PORT)
	multiplayer.multiplayer_peer = enet_peer

func _on_button_2_pressed():
	#host
	$Control.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	#upnp_setup()
func add_player(peer_id):
	
	var pl = player.instantiate()
	pl.name = str(peer_id)
	add_child(pl)
	pl.set_as_top_level(true)
	#spawn in map_point if it doesn't have childred


func remove_player(peer_id):
	var pl = get_node_or_null(str(peer_id))
	if pl:
		pl.queue_free()

func upnp_setup():
	var upnp = UPNP.new()
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
	"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
	"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())



func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
	#	node.set_turn(true)
		pass
