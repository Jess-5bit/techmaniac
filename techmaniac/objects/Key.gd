extends Area2D

const ANIM_SPEED : float = 8.0
const BOB_SPEED : float = 2.0
const BOB_AMOUNT : float = 2.0

onready var sprite : Sprite = $Sprite

onready var anim_index : float = 0.0

signal collected

func _physics_process(delta : float) -> void:
	anim_index += delta
	var offset : float = sin(anim_index * BOB_SPEED) * BOB_AMOUNT
	sprite.offset.y = offset

func _on_Powerup_body_entered(body : PhysicsBody2D) -> void:
	if body is Player:
		emit_signal("collected")
		queue_free()
