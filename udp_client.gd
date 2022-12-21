extends Node

signal face_mesh_received(points)

var PORT_CLIENT = 5052
var socketUDP = PacketPeerUDP.new()

func _ready():
	start_client()

func _process(_delta):
	if socketUDP.get_available_packet_count() > 0:
		var points: PoolVector3Array = []
		var stream = StreamPeerBuffer.new()
		stream.data_array = socketUDP.get_packet()
		var batch_size = stream.get_float()
		for _i in range(batch_size):
			var x = stream.get_float()
			var y = stream.get_float()
			var z = stream.get_float()
			points.append(Vector3(x, y, z))
		
		emit_signal("face_mesh_received", points)

func _exit_tree():
	socketUDP.close()

func start_client():
	if (socketUDP.listen(PORT_CLIENT) != OK):
		printt("An error occurred while attempting to listening on port: %s" % PORT_CLIENT)
	else:
		printt("Listening on port: %s" % PORT_CLIENT)

