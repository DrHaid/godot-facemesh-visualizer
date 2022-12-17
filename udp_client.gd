extends Node

signal face_mesh_received(points)

var PORT_CLIENT = 5052
var socketUDP = PacketPeerUDP.new()

func _ready():
	start_client()

func _process(_delta):
	if socketUDP.get_available_packet_count() > 0:
		var points: PoolVector3Array = []
		var msg_raw = socketUDP.get_packet().get_string_from_utf8()
		var arr = msg_raw.split("\n")
		for msg in arr:
			var parts = msg.split(";")
			if parts.size() == 4:
				points.append(Vector3(parts[1], float(parts[2]) * -1, parts[3]))
		emit_signal("face_mesh_received", points)

func _exit_tree():
	socketUDP.close()

func start_client():
	if (socketUDP.listen(PORT_CLIENT) != OK):
		printt("An error occurred while attempting to listening on port: %s" % PORT_CLIENT)
	else:
		printt("Listening on port: %s" % PORT_CLIENT)

