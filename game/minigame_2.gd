extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer

var buttons_pressed := 0
var timer_end := false
var finished := false


func _ready() -> void:
	await themed_timer.Timer(8.0)

	if not finished:
		timer_end = true


func _process(_delta: float) -> void:

	# Successfully completed Minigame 2
	if buttons_pressed >= 5 and not finished:
		finished = true

		print("MINIGAME 2 COMPLETE!")
		print("Before: minigames_done = ", Global.minigames_done)

		Global.minigames_done += 1

		print("After: minigames_done = ", Global.minigames_done)

		if Global.minigames_done >= 3:
			get_tree().change_scene_to_file(
				"res://scenes/done_screen.tscn"
			)
		else:
			get_tree().change_scene_to_file(
				"res://scenes/timer_screen.tscn"
			)


	# Timer ran out
	if timer_end and not finished:
		finished = true

		Global.lives -= 1

		print("MINIGAME 2 FAILED")
		print("Lives remaining: ", Global.lives)
		print("Minigames done: ", Global.minigames_done)

		if Global.lives <= 0:
			get_tree().change_scene_to_file(
				"res://scenes/death.tscn"
			)
		else:
			get_tree().change_scene_to_file(
				"res://scenes/timer_screen.tscn"
			)


func _on_button_1_pressed() -> void:
	buttons_pressed += 1

	print("Buttons pressed: ", buttons_pressed)
