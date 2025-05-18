extends CharacterBody2D
@onready var counter_label = $CanvasLayer/HBoxContainer/current_amount
var counter_value = 0
var can_dash := true

# --- stats ---
@export var speed = 150*5 # Normal speed
@export var dash_multiplier = 3.0
@export var hp = 50

# --- Internal State ---
var screen_size
var dash_remaining = 0.0
var dash_direction = Vector2.ZERO

# --- Engine Callbacks ---
func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	handle_input()

	if dash_remaining > 0:
		velocity = dash_direction * speed * dash_multiplier
		dash_remaining -= (velocity * delta).length()
	else:
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		else:
			velocity = Vector2.ZERO

	move_and_slide()  # FIXED below
			
# --- Input & Animation ---
func handle_input():
	var input_vector = Vector2.ZERO
	
	# Replace these with actual Input Map actions
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1

	if dash_remaining <= 0:
		velocity = input_vector

		if Input.is_action_just_pressed("press_shift") and input_vector.length() > 0 and can_dash:
			dash_direction = input_vector.normalized()
			dash_remaining = screen_size.x * 0.2
			can_dash = false
			$DashCooldownTimer.start()


func update_animation(vel: Vector2):
	if abs(vel.x) > abs(vel.y):
		if vel.x > 0:
			pass
		else:
			pass
	else:
		if vel.y > 0:
			pass
		else:
			pass

# --- stat setters --- 
func set_hp(value: int) -> void:
	hp = max(value, 0)

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	
func increment_label():
	var label = get_node("CanvasLayer/HBoxContainer/current_amount")
	if label:
		counter_value += 1
		label.text = str(counter_value)
		print("Current val updated to:", counter_value)
	else:
		print("Current Val not found!")
