extends Node

func _on_UDPClient_face_mesh_received(points):
	print(points)
#	for child in get_children():
#		child.queue_free()
#	var dot = load("res://DebugPoint.tscn")
#	var index = 0;
#	for point in points:
#		var dot_instance = dot.instance()
#		dot_instance.set_name(str(index))
#		dot_instance.transform.origin = point
#		# TODO bind signal for outputting landmarks
#		add_child(dot_instance)
#		index += 1
