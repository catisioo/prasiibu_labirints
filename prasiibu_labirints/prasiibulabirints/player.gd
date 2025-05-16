extends CharacterBody2D

#$hitbox_collisions - characters hitbox
#$attack/attack_hitbox - characters attack hitbox
#$attack/attack_anim - animated sprite 2d, has a default attack animation

var can_dash := true

# --- stats ---
@export var speed = 150*3 # Normal speed
@export var dash_multiplier = 3.0
@export var hp = 50

# --- Internal State ---
var screen_size
@onready var animated_sprite = $AnimatedSprite2D

var dash_remaining = 0.0
var dash_direction = Vector2.ZERO

# --- Engine Callbacks ---
func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	handle_input()

	if dash_remaining > 0:
		self.velocity = dash_direction * speed * dash_multiplier
		var motion = self.velocity * delta
		move_and_slide()
		dash_remaining -= motion.length()
	else:
		if self.velocity.length() > 0:
			self.velocity = self.velocity.normalized() * speed
			move_and_slide()
			update_animation(self.velocity)
		else:
			self.velocity = Vector2.ZERO
			move_and_slide()
			animated_sprite.stop()

# --- Input & Animation ---
func handle_input():
	var input_vector = Vector2.ZERO
	if Input.is_action_just_pressed("press_space"):
		$attack_anim.play("default")
		$attack_anim/player_attack/attack_hitbox.disabled = false
		$AttackHitboxTimer.start()
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	elif Input.is_action_pressed("move_left"):
		input_vector.x -= 1

	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	elif Input.is_action_pressed("move_up"):
		input_vector.y -= 1

	if dash_remaining <= 0:
		self.velocity = input_vector

		if Input.is_action_just_pressed("press_shift") and input_vector.length() > 0 and can_dash:
			dash_direction = input_vector.normalized()
			dash_remaining = screen_size.x * 0.1
			can_dash = false
			$DashCooldownTimer.start()


	
func update_animation(vel: Vector2):
	if abs(vel.x) > abs(vel.y):
		if vel.x > 0:
			animated_sprite.play("walk_right")
		else:
			animated_sprite.play("walk_left")
	else:
		if vel.y > 0:
			animated_sprite.play("walk_down")
		else:
			animated_sprite.play("walk_up")

# --- stat setters --- 
func set_hp(value: int) -> void:
	hp = max(value, 0)

func change_hp(delta: int) -> void:
	hp = max(hp + delta, 0)


# --- Collision Handling ---



func _on_DashCooldownTimer_timeout() -> void:
	can_dash = true



func _on_attack_hitbox_timer_timeout() -> void:
	$attack_anim/player_attack/attack_hitbox.disabled = true
	$AttackHitboxTimer.stop()
