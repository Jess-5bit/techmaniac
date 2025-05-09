extends CanvasLayer

onready var label_message : Label = $StatusBar/Label_Message
onready var anim_player : AnimationPlayer = $AnimationPlayer

func show_message(message : String) -> void:
	if anim_player.is_playing():
		anim_player.stop()
	label_message.text = message.to_upper()
	anim_player.play("message")
