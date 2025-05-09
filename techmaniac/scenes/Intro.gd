extends Control

onready var label_story : Label = $Label_Story
onready var label_loading : Label = $Label_Loading
onready var audio_bgm : AudioStreamPlayer = $Audio_BGM
onready var audio_loading : AudioStreamPlayer = $Audio_Loading
onready var timer_next : Timer = $Timer_Next

var loading : bool = false

func _on_Timer_Next_timeout() -> void:
	label_story.visible = true
	label_story.max_lines_visible += 1

func _physics_process(delta : float) -> void:
	if loading: return
	if Input.is_action_just_pressed("jump"):
		loading = true
		label_story.hide()
		audio_bgm.stop()
		timer_next.stop()
		yield(get_tree().create_timer(1.0), "timeout")
		label_loading.show()
		audio_loading.play()
		yield(audio_loading, "finished")
		label_loading.hide()
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene("res://scenes/Game.tscn")
