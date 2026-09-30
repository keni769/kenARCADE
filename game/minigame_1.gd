extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer

var garlic_collected = 0
var timer_end = false
var finished = false


func _ready() -> void:
	await themed_timer.Timer(15.0)

	if not finished:
		timer_end = true


func _process(_delta: float) -> void:

	# Successfully completed Minigame 1
	if garlic_collected >= 3 and not finished:
		finished = true

		print("MINIGAME 1 COMPLETE!")
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

		if Global.lives <= 0:
			get_tree().change_scene_to_file(
				"res://scenes/death.tscn"
			)
		else:
			get_tree().change_scene_to_file(
				"res://scenes/timer_screen.tscn"
			)


func garlic_collect() -> void:
	garlic_collected += 1
	print("Blueberries collected: ", garlic_collected)


func _on_node_2d_garlic_collected() -> void:
	garlic_collected += 1
	print("Blueberries collected: ", garlic_collected)


func _on_death_barrier_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.lives -= 1
		get_tree().change_scene_to_file(
			"res://scenes/timer_screen.tscn"
		)
