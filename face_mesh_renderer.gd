extends Node

@onready var udp_client: UDPClient = %UDPClient
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	udp_client.connect("face_mesh_received", _on_UDPClient_face_mesh_received)

func _on_UDPClient_face_mesh_received(points: PackedVector3Array) -> void:
	var face_mesh := ArrayMesh.new()
	var vertices := PackedVector3Array()
	for triangle: Array in FaceMeshConnections.TRIANGLES:
		vertices.push_back(points[triangle[0]])
		vertices.push_back(points[triangle[1]])
		vertices.push_back(points[triangle[2]])

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	face_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh.mesh = face_mesh

## save landmarks into scene for debugging
func save_points(points: PackedVector3Array) -> void:
	var parent := Node3D.new()
	var dot := load("res://sphere_mesh.tres")
	for i in range(points.size()):
		var dot_instance := MeshInstance3D.new()
		dot_instance.mesh = dot
		dot_instance.set_name(str(i))
		dot_instance.global_position = points[i]
		parent.add_child(dot_instance)
		dot_instance.owner = parent
	
	add_child(parent)
	var packed := PackedScene.new()
	packed.pack(parent)
	ResourceSaver.save(packed, "res://points.tscn")
	get_tree().quit()
