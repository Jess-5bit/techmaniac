extends Control

const MESSAGES : Array = [
	"",
	"FOUL HEATHEN",
	"NONE WHO\nOPPOSE THE\nETERNITY DUCK\nSHALL LIVE",
	"ALL PRAISE\nETERNITY DUCK",
	"PRAISE PRAISE PRAISE\nPRAISE PRAISE PRAISE\nPRAISE PRAISE PRAISE\nPRAISE PRAISE PRAISE\nPRAISE PRAISE PRAISE\nPRAISE PRAISE PRAISE\nPRAISE PRAISE PRAISE",
]

onready var texture_duck : TextureRect = $Texture_Duck
onready var label_message : Label = $Label_Message
onready var audio_rumble : AudioStreamPlayer = $Audio_Rumble
onready var tween : Tween = $Tween

var current_message : int = 0

func _physics_process(delta : float) -> void:
	texture_duck.rect_position = Vector2(randf() * 2.0, randf() * 2.0)
	label_message.rect_position = Vector2(randf() * 2.0, randf() * 2.0)

func _on_Timer_Flicker_timeout() -> void:
	texture_duck.material.set_shader_param("level", 0.4 + (randf() * 0.2))

func _on_Timer_Message_timeout() -> void:
	current_message += 1
	if current_message == 5:
		get_tree().quit()
	else:
		label_message.text = MESSAGES[current_message]
		if current_message == 1:
			texture_duck.show()
			audio_rumble.play()
			tween.interpolate_property(audio_rumble, "pitch_scale", null, 4.0, 16.0, Tween.TRANS_CIRC, Tween.EASE_IN)
			tween.start()
