extends Camera2D

export (NodePath) var path_player

onready var player = get_node(path_player)

func _physics_process(delta : float) -> void:
	if is_instance_valid(player):
		global_position.x = floor(player.global_position.x / 160.0) * 160.0
		global_position.y = max(floor(player.global_position.y / 88.0) * 88.0, 0.0)
	pass
