extends Area2D

onready var audio_checkpoint = $Audio_Checkpoint

var current_checkpoint : bool = false

signal reached

func _on_Checkpoint_body_entered(body : PhysicsBody2D) -> void:
	if current_checkpoint: return
	if body is Player:
		audio_checkpoint.play()
		emit_signal("reached", self.global_position)
		get_tree().call_group("checkpoint", "maybe_deactivate", self.global_position)
		current_checkpoint = true

func maybe_deactivate(pos : Vector2) -> void:
	if self.global_position != pos:
		current_checkpoint = false
