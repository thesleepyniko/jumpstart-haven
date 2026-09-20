extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_deferred("monitoring", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_node_ready_for_movement() -> void:
	set_deferred("monitoring", true)


func _on_node_stop_movement() -> void:
	set_deferred("monitoring", false)
