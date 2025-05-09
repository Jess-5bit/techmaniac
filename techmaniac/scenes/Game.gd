extends Node2D

const _Player : PackedScene = preload("res://objects/Player.tscn")

onready var player : KinematicBody2D = $Player
onready var camera : Camera2D = $Camera
onready var hud : CanvasLayer = $HUD

onready var label_ending : Label = $Label_Ending
onready var audio_get_item : AudioStreamPlayer = $Audio_GetItem
onready var audio_get_key : AudioStreamPlayer = $Audio_GetKey

var player_has_double_jump : bool = false
onready var player_checkpoint_pos : Vector2 = player.global_position

var game_time : float = 0.0
var deaths : int = 0
var items_collected : int = 0

var game_over : bool = false

func respawn_player() -> void:
	# Despawn the player that just died
	player.call_deferred("queue_free")
	# Spawn a new player
	player = _Player.instance()
	add_child(player)
	player.global_position = player_checkpoint_pos
	player.has_double_jump = player_has_double_jump
	player.connect("dead", self, "_on_Player_dead")
	# Set the camera to start following the new player instance
	camera.player = player
	deaths += 1

func _on_Player_dead() -> void:
	respawn_player()

func _on_Powerup_collected() -> void:
	player_has_double_jump = true
	hud.show_message("Double jump collected! You can now jump in midair.")

func _on_Checkpoint_reached(where : Vector2) -> void:
	player_checkpoint_pos = where
	
func _on_Collectible_collected(which : int) -> void:
	items_collected += 1
	hud.show_message(Collectibles.get_collectible_quip(which))
	audio_get_item.play()

func _on_Key_collected() -> void:
	hud.show_message("A door opens somewhere...")
	audio_get_key.play()

func _on_final_checkpoint_reached(stuff : Vector2) -> void:
	game_over = true
	label_ending.text = label_ending.text.replace("TVAL", Utilities.time_to_string(game_time))
	label_ending.text = label_ending.text.replace("IVAL", str(items_collected) + "/8")
	label_ending.text = label_ending.text.replace("DVAL", str(deaths))
	label_ending.show()

func _physics_process(delta : float) -> void:
	if not game_over:
		game_time += delta
