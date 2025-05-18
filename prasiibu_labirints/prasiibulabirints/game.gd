extends Node2D
var enemy_exist = true
var promptvisible = false
@onready var player = $player  # adjust this path to match your scene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bossenemy = $enemies/Area2Denemy7
	bossenemy.enemy_died.connect(_on_enemy_died)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var label = player.get_node("CanvasLayer/Label")
	if label:
		label.visible = promptvisible
	
	if Input.is_action_just_pressed("interact_f") and promptvisible:
		var amount_label = player.get_node("CanvasLayer/HBoxContainer/current_amount")
		if amount_label and amount_label.text == "6":
			get_tree().change_scene_to_file("res://puzzle.tscn")
	
	
func _on_enemy_died():
	
	$TileMapLayer_basedungeon2/TileMapLayer_basedungeon/TilemapLayer_extraobjects/TilemapLayer_doors_disappear.queue_free()


func _on_interactable_area_body_entered(body):
	print("area_entered")
	promptvisible = true

func _on_interactable_area_body_exited(body):
	print("area_exited")
	promptvisible = false
