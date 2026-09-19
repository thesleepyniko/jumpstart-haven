extends Node

@onready var player_node = get_node("./Player")
@onready var tile_map_node = get_node("./TileMapLayer")
@onready var command_label = get_node("./Label")
@onready var camera = get_node("./Player/Camera2D")
@onready var title_label = get_node("./Player/Camera2D/Label2")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_node.hide()
	tile_map_node.hide()
	camera.show() # make sure our camera shows so that some elements can remain visible
		
	var random_float = randf_range(0.2, 0.5) 
	await get_tree().create_timer(random_float).timeout
	
	command_label.text += "\n[INFO] Loading model from ./jumpstartAI\n"
	
	random_float = randf_range(0.1, 0.2) 
	await get_tree().create_timer(random_float).timeout
	
	command_label.text += "[INFO] Loaded model \"hack-v0.2-beta\"from ./jumpstartAI\n"
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
	
	
	
	
	
	command_label.hide()
	player_node.show()
	tile_map_node.show()
	
	title_label.text = " llmbenchmark start --platformer ./runnerAI"

	
	
#	
	
#	var random_float = randf_range(0.5, 5.5) 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
