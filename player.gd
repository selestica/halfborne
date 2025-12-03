extends CharacterBody2D

const SPEED = 320.0
const JUMP_VELOCITY = -580.0
const GRAVITY = 1400.0

const DASH_SPEED = 900.0
const DASH_TIME = 0.12

var dash_timer := 0.0
var is_dashing := false
var dash_direction := 0.0

func _physics_process(delta):
	# Gravity (disabled during dash)
	if not is_dashing and not is_on_floor():
		velocity.y += GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_dashing:
		velocity.y = JUMP_VELOCITY

	# Start Dash
	if Input.is_action_just_pressed("dash") and not is_dashing:
		dash_direction = Input.get_axis("ui_left", "ui_right")
		if dash_direction == 0:
			dash_direction = 1  # default forward dash
		is_dashing = true
		dash_timer = DASH_TIME

	# Dash Movement
	if is_dashing:
		dash_timer -= delta
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0

		if dash_timer <= 0:
			is_dashing = false

	# Normal Movement (only if not dashing)
	if not is_dashing:
		var direction = Input.get_axis("ui_left", "ui_right")

		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
