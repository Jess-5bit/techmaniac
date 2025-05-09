extends Control

onready var label_prompt : Label = $Label_Prompt
onready var audio_start : AudioStreamPlayer = $Audio_Start

var beginning : bool = false

func _on_Timer_Blink_timeout() -> void:
	label_prompt.visible = !label_prompt.visible

func _physics_process(delta : float) -> void:
	if beginning: return
	if Input.is_action_just_pressed("jump"):
		beginning = true
		audio_start.play()
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://scenes/Intro.tscn")
