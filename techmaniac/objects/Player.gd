extends KinematicBody2D

class_name Player

const MAX_RUN_SPEED : float = 64.0
const RUN_ACCEL : float = 512.0
const JUMP_SPEED : float = 138.0
const FALL_ACCEL : float = 512.0
const MAX_FALL_SPEED : float = 256.0
const ANIM_SPEED : float = 10.0

const JUMP_SOUNDS : Array = [
	preload("res://sounds/jump1.wav"),
	preload("res://sounds/jump2.wav"),
	preload("res://sounds/jump3.wav"),
	preload("res://sounds/jump4.wav")
]

onready var sprite : Sprite = $Sprite
onready var audio_jump : AudioStreamPlayer = $Audio_Jump
onready var audio_powerup : AudioStreamPlayer = $Audio_Powerup
onready var audio_die : AudioStreamPlayer = $Audio_Die

enum State {STAND, JUMP, DYING}

var current_state : int = State.STAND
var can_double_jump : bool = false
var has_double_jump : bool = false
var run_speed : float = 0.0
var jump_speed : float = 0.0
var anim_index : float = 0.0
var death_fizzle : float = 0.0

signal dead

func try_to_run(delta : float, left : bool, run_sprite : bool) -> void:
	sprite.flip_h = left
	run_speed += (RUN_ACCEL * delta) * (-1.0 if left else 1.0)
	# If we're on the ground, update the sprite
	if run_sprite:
		anim_index += ANIM_SPEED * delta
		sprite.frame = int(fmod(anim_index, 2.0))

func run_stuff(delta : float, run_sprite : bool, slow_down_coeff : float = 1.0) -> void:
	var running : bool = false
	if Input.is_action_pressed("run_left"):
		try_to_run(delta, true, run_sprite)
		running = true
	if Input.is_action_pressed("run_right"):
		try_to_run(delta, false, run_sprite)
		running = true
	# Slow down if we aren't running
	if not running:
		if run_speed > 0.0:
			run_speed = clamp(run_speed - (RUN_ACCEL * delta * slow_down_coeff), 0.0, MAX_RUN_SPEED)
		elif run_speed < 0.0:
			run_speed = clamp(run_speed + (RUN_ACCEL * delta * slow_down_coeff), -MAX_RUN_SPEED, 0.0)
		# Change sprite back to standing
		if run_sprite:
			anim_index = 0.0
			sprite.frame = 0
	run_speed = clamp(run_speed, -MAX_RUN_SPEED, MAX_RUN_SPEED)
	# Check if we're smacking into something
	var collision : KinematicCollision2D = move_and_collide(Vector2.RIGHT * run_speed * delta)
	if collision != null:
		pass

func jump_stuff(delta : float) -> void:
	jump_speed = clamp(jump_speed + (FALL_ACCEL * delta), -MAX_FALL_SPEED, MAX_FALL_SPEED)
	var collision : KinematicCollision2D = move_and_collide(Vector2.DOWN * jump_speed * delta)
	if collision != null:
		if collision.normal == Vector2.UP:
			jump_speed = 0.0
			current_state = State.STAND
		elif collision.normal == Vector2.DOWN:
			jump_speed = clamp(jump_speed, 0.0, MAX_FALL_SPEED)

func jump() -> void:
	jump_speed = -JUMP_SPEED
	sprite.frame = 2
	current_state = State.JUMP
	audio_jump.stream = JUMP_SOUNDS[rand_range(0, 4)]
	audio_jump.play()

func state_stand(delta : float) -> void:
	run_stuff(delta, true)
	if test_move(transform, Vector2.DOWN) == false:
		current_state = State.JUMP
		sprite.frame = 2
	if has_double_jump:
		can_double_jump = true
	if Input.is_action_just_pressed("jump"):
		jump()

func state_jump(delta : float) -> void:
	run_stuff(delta, false, 0.25)
	jump_stuff(delta)
	if can_double_jump and Input.is_action_just_pressed("jump"):
		jump()
		can_double_jump = false

func state_dying(delta : float) -> void:
	death_fizzle += delta * 2.0
	sprite.material.set_shader_param("level", death_fizzle)
	if death_fizzle >= 1.0:
		emit_signal("dead")

func _physics_process(delta : float) -> void:
	match current_state:
		State.STAND:
			state_stand(delta)
		State.JUMP:
			state_jump(delta)
		State.DYING:
			state_dying(delta)

func get_hurt() -> void:
	current_state = State.DYING
	audio_die.play()

func _on_Area2D_Spike_body_entered(body) -> void:
	get_hurt()

func get_double_jump() -> void:
	audio_powerup.play()
	has_double_jump = true
	can_double_jump = true

func _ready() -> void:
	# Reset the shader parameter so we don't start out invisible
	sprite.material.set_shader_param("level", 0.0)
