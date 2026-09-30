extends Node2D

const SNAKE = 0
const BLUEBERRY = 1

var bb_pos
var snake_body = [
	Vector2(11, 5),
	Vector2(10, 5),
	Vector2(9, 5)
]
var snake_direction = Vector2(1, 0)
var add_bb = false
var finished = false
var blueberries_eaten = 0

func _ready():
	bb_pos = place_bb()
	update_score()
	draw_bb()
	draw_snake()

func place_bb():
	randomize()
	var x = randi() % 20
	var y = randi() % 20
	return Vector2(x, y)

func draw_bb():
	$snapple.set_cell(0, Vector2i(bb_pos), BLUEBERRY, Vector2i(0, 0))

func draw_snake():
	for block in snake_body:
		$snapple.set_cell(0, Vector2i(block), SNAKE, Vector2i(0, 0))

func move_snake():
	delete_tiles(SNAKE)
	var new_head = snake_body[0] + snake_direction

	if new_head == bb_pos:
		add_bb = true
		blueberries_eaten += 1
		update_score()

		if blueberries_eaten >= 15:
			win_game()
			return

		bb_pos = place_bb()

	var body_copy = snake_body.duplicate()

	if not add_bb:
		body_copy.pop_back()

	body_copy.push_front(new_head)
	snake_body = body_copy
	add_bb = false

func delete_tiles(id: int):
	var cells = $snapple.get_used_cells_by_id(0, id)
	for cell in cells:
		$snapple.set_cell(0, Vector2i(cell), -1)

func update_score():
	$Score.text = "Score: " + str(blueberries_eaten) + "/15"

func _input(_event):
	if Input.is_action_just_pressed("ui_up"):
		if not snake_direction == Vector2(0,1):
			snake_direction = Vector2(0,-1)
	if Input.is_action_just_pressed("ui_right"):
		if not snake_direction == Vector2(-1,0):
			snake_direction = Vector2(1,0)
	if Input.is_action_just_pressed("ui_left"):
		if not snake_direction == Vector2(1,0):
			snake_direction = Vector2(-1,0)
	if Input.is_action_just_pressed("ui_down"):
		if not snake_direction == Vector2(0,-1):
			snake_direction = Vector2(0,1)

func check_wall():
	var head = snake_body[0]

	if head.x >= 20 or head.x < 0 or head.y >= 20 or head.y < 0:
		lose_game()

	for i in range(1, snake_body.size()):
		if snake_body[i] == head:
			lose_game()

func lose_game():
	if finished:
		return

	finished = true
	Global.lives -= 1

	if Global.lives <= 0:
		get_tree().change_scene_to_file("res://scenes/death.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/timer_screen.tscn")

func win_game():
	if finished:
		return

	finished = true
	Global.minigames_done += 1
	get_tree().change_scene_to_file("res://scenes/done_screen.tscn")

func _on_timer_timeout():
	move_snake()

	if finished:
		return

	check_wall()

	if finished:
		return

	draw_bb()
	draw_snake()
