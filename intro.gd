extends Node

@onready var player_node = get_node("./Player")
@onready var tile_map_node = get_node("./TileMapLayer")
@onready var command_label = get_node("./Label") # this technically also doubles as the death message
@onready var camera_node = get_node("./Player/Camera2D")
@onready var title_label = get_node("./Player/Camera2D/Label2")


func handle_tween_done() -> void:
	pass
	#camera_node.show()

signal ready_for_game
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_node.hide()
	tile_map_node.hide()
	camera_node.modulate.a = 0
	#camera_node.hide() # keep the UI elements hidden until later
		
	var random_float = randf_range(0.2, 0.5) 
	await get_tree().create_timer(random_float).timeout
	
	command_label.text += "\n[INFO] Loading model from ./jumpstartAI\n"
	
	random_float = randf_range(0.1, 0.2) 
	await get_tree().create_timer(random_float).timeout
	
	command_label.text += "[INFO] Loaded model \"hack-v0.2-beta\" from ./runnerAI\n"
	command_label.text += "[WARNING] You are benchmarking an internal Jumpstart AI model. Exit now if you are not the intended user.\n"
	
	await get_tree().create_timer(3.0).timeout
	
	command_label.text += "[INFO] Loading benchmark \"platformer3\" from list \"platformers\"\n"
	await get_tree().create_timer(0.7).timeout
	
	command_label.text += "[INFO] Progress: %s%%\n" % int(randf_range(0, 15))
	random_float = randf_range(0.2, 0.5) 
	await get_tree().create_timer(random_float).timeout	
	command_label.text += "[INFO] Progress: %s%%\n" % int(randf_range(40, 65))
	random_float = randf_range(0.2, 0.5) 
	await get_tree().create_timer(random_float).timeout
	command_label.text += "[INFO] Progress: %s%%\n" % int(randf_range(65, 99) )
	random_float = randf_range(0.2, 0.5) 
	await get_tree().create_timer(random_float).timeout	
	command_label.text += "[INFO] Progress: 100%\n"


	
	command_label.text += "[INFO] Beginning benchmark...\n"
	await get_tree().create_timer(2.0).timeout
	
	
	#command_label.hide()
	
	#title_label.text = " llmbenchmark start --platformer ./runnerAI"

	#camera.show()
	
	var tween_one = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween_one.parallel().tween_property(camera_node, "zoom", Vector2(0.25, 0.25), 2)
	tween_one.parallel().tween_property(camera_node, "position", Vector2(1500, -1000), 2)
	tile_map_node.show()
	player_node.show()
	
	await tween_one.finished
	tween_one.kill()
	
	var tween_two = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	
	tween_two.parallel().tween_property(camera_node, "position", player_node.global_position, 3)
	tween_two.parallel().tween_property(camera_node, "zoom", Vector2(1, 1), 3)
	
	tween_two.tween_property(camera_node, "modulate:a", 1, 1)
	
	tween_two.tween_callback(handle_tween_done) 	
	#await tween_two.finished
	
	await tween_two.finished

	tween_two.kill()
	
	command_label.text += "[INFO] Running...\n"
	
	title_label.text = ""
	
	for letter in "Objective: Break out":
		title_label.text += letter
		await get_tree().create_timer(0.1).timeout	
	
	var group_nodes = get_tree().get_nodes_in_group("terminal_non_objective")
	var tween_remove_term = create_tween().set_parallel(true)

	for node in group_nodes:
		tween_remove_term.tween_property(node, "modulate:a", 0, 1.0)
	
	
	ready_for_game.emit()
	
	

	#tween.kill()
	
#	var random_float = randf_range(0.5, 5.5) 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
