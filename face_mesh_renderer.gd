extends Node

var debug_points = []

func _on_UDPClient_face_mesh_received(positions):
	if len(debug_points) != len(positions):
		init_points(len(positions))
	for i in range(len(debug_points)):
		debug_points[i].transform.origin = positions[i]

func init_points(count: int):
	for child in get_children():
		child.queue_free()
	var dot = load("res://debug_point.tscn")
	for i in range(count):
		var dot_instance = dot.instance()
		dot_instance.set_name(str(i))
		debug_points.append(dot_instance)
		add_child(dot_instance)
