extends Area2D
@export var enemy_hp = 15
@export var enemy_max_hp = 15

signal enemy_died

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack_timer = $AttackTimer

var can_take_dmg = true
var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.start()


func _on_AttackTimer_timeout() -> void:
	if not active:
		pass
	else:
		change_enemy_hp(4)
		animated_sprite.play("attack_anim")
		$AnimatedSprite2D2.play("attack_vfx_enemy")
	
		$delay.start()
	
func _on_delay_timeout() -> void:
	$delay.stop()
	# check if players hitbox is in enemies hurtbox, and if it is, reduce players hp
	pass
	

func change_enemy_hp(damage: int) -> void:
	enemy_hp = max(enemy_hp - damage, 0)
	$TextureProgressBar.value = round((float(enemy_hp) / float(enemy_max_hp)) * 100.0)
	print($TextureProgressBar.value)
	print("Enemy HP: ", enemy_hp)
	if enemy_hp <= 0:
		can_take_dmg = false
		emit_signal("enemy_died")
		queue_free()
		

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	active = true
	print("visible")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	active = false
	print("not_visible")
