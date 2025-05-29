extends Node
class_name UDPClient

signal face_mesh_received(points: PackedVector3Array)

@export var PORT_CLIENT: int = 5052

var socketUDP: PacketPeerUDP

func _ready() -> void:
	start_client()

func _exit_tree() -> void:
	socketUDP.close()

func _process(_delta: float) -> void:
	if socketUDP.get_available_packet_count() > 0:
		var stream := StreamPeerBuffer.new()
		stream.data_array = socketUDP.get_packet()
		var points := get_points(stream)
		emit_signal("face_mesh_received", points)

func start_client() -> void:
	socketUDP = PacketPeerUDP.new()
	if (socketUDP.bind(PORT_CLIENT) != OK):
		printt("An error occurred while attempting to listening on port: %s" % PORT_CLIENT)
	else:
		printt("Listening on port: %s" % PORT_CLIENT)

func get_points(stream: StreamPeerBuffer) -> PackedVector3Array:
	var points: PackedVector3Array = []
	var batch_size := stream.get_float()
	for _i in range(batch_size):
		var x := stream.get_float()
		var y := -stream.get_float()  # negate, else upside-down
		var z := stream.get_float()
		points.append(Vector3(x, y, z))
	return points
