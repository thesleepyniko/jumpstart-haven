extends Node

@onready var player_node = get_node("./Player")
@onready var tile_map_node = get_node("./TileMapLayer")
@onready var command_label = get_node("./TermInputLabel") # this technically also doubles as the death message
@onready var camera_node = get_node("./Player/Camera2D")
@onready var title_label = get_node("./Player/Camera2D/TermCameraLabel")
@onready var jump_pad_node = get_node("./Area2DJumpPad")

var time_elapsed = 0
var ready_for_time = false

var original_position: Vector2
var jump_trigger_able = true
var collected_data = 0
var monitor_for_restart = false
var pulse_tween: Tween

signal ready_for_movement
signal stop_movement
signal stop_all_movement

func restart_scene() -> void:
	stop_movement.emit()
	player_node.hide()
	tile_map_node.hide()
	camera_node.modulate.a = 0
	camera_node.show()
	title_label.text = ""

	jump_pad_node.hide()
	player_node.global_position = Vector2i(0, 0)

	
	#camera_node.hide() # keep the UI elements hidden until later
		
	var random_float = randf_range(0.2, 0.5) 
	await get_tree().create_timer(random_float).timeout
	
	command_label.text += "\n[INFO] Loading model from ./runnerAI\n"
	
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
	
	#camera.show()
	
	var tween_one = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween_one.parallel().tween_property(camera_node, "zoom", Vector2(0.25, 0.25), 2)
	tween_one.parallel().tween_property(camera_node, "global_position", Vector2(1500, -1000), 2)
	tile_map_node.show()
	player_node.show()
	
	await tween_one.finished
	tween_one.kill()
	
	var tween_two = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	
	tween_two.parallel().tween_property(camera_node, "global_position", player_node.global_position, 3)
	tween_two.parallel().tween_property(camera_node, "zoom", Vector2(1, 1), 3)
	
	tween_two.tween_property(camera_node, "modulate:a", 1, 1)
		
	await tween_two.finished

	tween_two.kill()
	
	command_label.text += "[INFO] Running...\n"
		
	camera_node.show()
	
	await typewriter_on_node(title_label, "Objective: Collect data and reach the end | 0/3")
	
	ready_for_movement.emit()
	
	ready_for_time = true
	
	camera_node.top_level = false
	camera_node.global_position = player_node.global_position
	
	pulse_tween = create_tween().set_loops()
	
	pulse_tween.tween_property(title_label, "modulate:a", 0.6, 2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
		
	pulse_tween.tween_property(title_label, "modulate:a", 1.0, 2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
		
		

func typewriter_on_node(node: Label, text: String):
	for letter in text:
		node.text += letter
		await get_tree().create_timer(0.1).timeout	
	node.text+="\n"
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart_scene()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ready_for_time:
		time_elapsed += delta
	if monitor_for_restart:
		if Input.is_action_just_pressed("jump"):
			ready_for_time = false
			time_elapsed = 0
			command_label.text = "bash-5.3$  llmbenchmark start --platformer ./runnerAI"
			monitor_for_restart = false
			collected_data = 0
			pulse_tween.kill()
			jump_pad_node.set_deferred("monitoring", false)
			
			restart_scene()
			
			


func format_time(seconds: float) -> String:
	var hours = int(seconds) / (60*60) # just in case
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	var msec = int((seconds - int(seconds)) * 100)
	return "%02d:%02d:%02d.%02d" % [hours, minutes, secs, msec]

func _on_area_2d_void_respawn_triggered() -> void:
	var respawn_label = get_node("RespawnLabel")
	respawn_label.modulate.a = 1 # set it back to fullly visible if already triggered once
	typewriter_on_node(respawn_label, "llmbenchmark respawn --currentsim")
	typewriter_on_node(respawn_label, "[DEBUG] Respawned hack-v0.2-beta")
	var respawn_tween = create_tween()
	
	respawn_tween.tween_property(respawn_label, "modulate:a", 0.0, 2)	

func _on_area_2d_jump_trigger_body_entered(body: Node2D) -> void:
	if not jump_trigger_able:
		return
	if body.name == "Player":

		jump_trigger_able = false
		stop_movement.emit()
		var jump_label = get_node("JumpLabel")
		var jump_area_2d = get_node("Area2DJumpPad")
		jump_area_2d.set_deferred("monitoring", false)
		jump_label.modulate.a = 1
		original_position = camera_node.global_position
		var jump_cam_tween = create_tween()
		jump_cam_tween.parallel().tween_property(camera_node, "global_position", jump_label.global_position, 2)
		jump_cam_tween.parallel().tween_property(camera_node, "zoom", Vector2(1.5, 1.5), 2)
		
		
		await jump_cam_tween.finished
		
		await typewriter_on_node(jump_label, "llmbenchmark spawn objects.JumpPad -x 1400 -y -1200")
		jump_pad_node.show()
		jump_label.text += "[DEBUG] Spawned objects.JumpPad at (1400, -1200)"
		

		var jump_tween = create_tween()
		
		jump_tween.tween_property(jump_label, "modulate:a", 0.0, 2)
		
		await jump_tween.finished
		
		camera_node.global_position = original_position
		camera_node.zoom = Vector2(1, 1)
		
		jump_pad_node.set_deferred("monitoring", true)
		
		ready_for_movement.emit()
			




func _on_area_2d_data_1_data_collected() -> void:
	collected_data += 1
	title_label.text = "Objective: Collect data and reach the end | %d/3" % collected_data


func _on_area_2d_data_2_data_collected() -> void:
	collected_data += 1
	title_label.text = "Objective: Collect data and reach the end | %d/3" % collected_data

func _on_area_2d_data_3_data_collected() -> void:
	collected_data += 1
	title_label.text = "Objective: Collect data and reach the end | %d/3" % collected_data


func _on_area_2d_end_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		ready_for_time = false
		stop_all_movement.emit()
		stop_movement.emit()
		camera_node.hide()
		player_node.hide()
		
		var camera_world_pos = camera_node.global_position   # read while still parented
		camera_node.top_level = true
		camera_node.global_position = camera_world_pos
		
		var end_tween = create_tween()
		
		end_tween.tween_property(camera_node, "global_position", Vector2(-92+(1277/2), -1980+(721/2)), 2)
		
		await end_tween.finished
		
		await typewriter_on_node(command_label, "[INFO] Model beat the game in %s" % format_time(time_elapsed))
		await typewriter_on_node(command_label, "[INFO] Press space to try again.")
		
		monitor_for_restart = true
		jump_trigger_able = true
			#end_tween.parallel().tween_property(camera_node, "zoom", Vector2(1.5, 1.5), 2)
