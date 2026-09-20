extends Area2D

signal data_collected

var starting_position 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_position = self.global_position
	var move_tween = create_tween().set_loops()
	move_tween.tween_property(self, "global_position", Vector2(starting_position.x, starting_position.y+20), 2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
		
	move_tween.tween_property(self, "global_position", Vector2(starting_position.x, starting_position.y-10), 2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		self.hide()
		self.set_deferred("monitoring", false)
		data_collected.emit()
