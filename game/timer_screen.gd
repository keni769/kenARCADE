extends Node2D

@onready var garlic_container: HBoxContainer = $GarlicContainer
@onready var garlic: TextureRect = $GarlicContainer/Garlic
@onready var garlic_2: TextureRect = $GarlicContainer/Garlic2
@onready var garlic_3: TextureRect = $GarlicContainer/Garlic3
@onready var garlic_4: TextureRect = $GarlicContainer/Garlic4
@onready var garlic_5: TextureRect = $GarlicContainer/Garlic5

@onready var level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $timer

var time: float = 0.0


func _ready() -> void:
	level.text = "Level " + str(Global.minigames_done + 1)

	garlic.visible = Global.lives >= 1
	garlic_2.visible = Global.lives >= 2
	garlic_3.visible = Global.lives >= 3

	garlic_4.visible = false
	garlic_5.visible = false

	await Timer(3.0)

	if Global.lives <= 0:
		get_tree().change_scene_to_file(
			"res://scenes/death.tscn"
		)
		return

	if Global.minigames_done >= 3:
		get_tree().change_scene_to_file(
			"res://scenes/done_screen.tscn"
		)
		return

	var next_minigame = "res://scenes/minigame_" + str(Global.minigames_done + 1) + ".tscn"
	get_tree().change_scene_to_file(next_minigame) 
func _process(_delta: float) -> void:
	level.text = "Level " + str(Global.minigames_done + 1)

	garlic.visible = Global.lives >= 1
	garlic_2.visible = Global.lives >= 2
	garlic_3.visible = Global.lives >= 3

	garlic_4.visible = false
	garlic_5.visible = false

	# Update timer display.
	timer.text = "%.1f" % time


func Timer(start_time: float) -> void:
	time = start_time

	while time > 0.0:
		await wait(0.1)
		time -= 0.1

	time = 0.0
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
