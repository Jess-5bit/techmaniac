extends Area2D

export (NodePath) var path_label
onready var label : Label = get_node(path_label)

var phase : int = 0

func got_touched() -> void:
	match phase:
		0:
			label.text = "DO NOT TOUCH\nTHE ETERNITY DUCK"
			yield(get_tree().create_timer(1.0), "timeout")
			label.text = "THE ETERNITY DUCK\nFORGIVES YOUR\nTRANSGRESSIONS"
		1:
			label.text = "YOU ARE ANGERING\nTHE ETERNITY DUCK"
			yield(get_tree().create_timer(1.0), "timeout")
			label.text = "BEGONE FROM\nETERNITY DUCK"
		2:
			label.text = "THE ETERNITY DUCK'S\nPATIENCE WEARS THIN"
			yield(get_tree().create_timer(1.0), "timeout")
			label.text = "NO MORE CHANCES\nLEAVE NOW"
		3:
			get_tree().change_scene("res://scenes/BadEnding.tscn")
	phase += 1

func _on_Duck_body_entered(body : PhysicsBody2D) -> void:
	if body is Player:
		body.get_hurt()
		got_touched()
