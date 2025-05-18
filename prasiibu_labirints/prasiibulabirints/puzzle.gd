extends Control

@onready var texture_rects := [
	$TextureRect1,
	$TextureRect2,
	$TextureRect3,
	$TextureRect4,
	$TextureRect5,
]

@onready var result_label := $ResultLabel
@onready var check_button := $CheckButton
@onready var new_game_button := $NewGameButton

func _ready():
	check_button.pressed.connect(check_order)
	new_game_button.visible = false
	new_game_button.pressed.connect(start_new_game)
	
func check_order():
	# Create a list of the rects sorted by their x position
	var sorted = texture_rects.duplicate()
	sorted.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)

	# Now check if the sorted list is in the correct order (TextureRect1 should be first, etc.)
	var correct = true
	for i in range(texture_rects.size()):
		if sorted[i] != texture_rects[i]:
			correct = false
			break

	if correct:
		result_label.text = "✅ Pareiza kārtība!"
		new_game_button.visible = true
	else:
		result_label.text = "❌ Nepareiza kārtība."

func start_new_game():
	get_tree().change_scene_to_file("res://main.tscn")
