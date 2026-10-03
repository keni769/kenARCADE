extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer
@onready var death_screen: TextureRect = $Fade/death_screen

var buttons_pressed := 0
var timer_end := false
var finished := false


func _ready() -> void:
	await themed_timer.Timer(8)

	if not finished:
		timer_end = true


func _process(_delta: float) -> void:

	if buttons_pressed >= 5 and not finished:
		finished = true

		Global.minigames_done += 1


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

		if Global.lives <= 0:
			var tween = create_tween()
			tween.tween_property(
				death_screen,
				"modulate:a",
				1,
				1
			)
		else:
			get_tree().change_scene_to_file(
				"res://scenes/timer_screen.tscn"
			)


func _on_button_1_pressed() -> void:
	buttons_pressed += 1
