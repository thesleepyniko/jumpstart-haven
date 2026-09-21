extends CharacterBody2D


const SPEED = 900.0
const JUMP_VELOCITY = -600.0
var allow_movement = false
var stop_all_movement = false

@onready var sprite_node = get_node("Sprite2D")


func _physics_process(delta: float) -> void:
	# for end screen so player can't just go flying
	if not stop_all_movement:
		# exists to prevent user from moving during animations, even if the user is visible
		if not allow_movement and not is_on_floor():
				velocity += get_gravity() * delta
		if allow_movement:
			# Add the gravity.
			if not is_on_floor():
				velocity += get_gravity() * delta

			# Handle jump.
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction := Input.get_axis("left", "right")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.x > 0:
			sprite_node.flip_h = true
		elif velocity.x < 0:
			sprite_node.flip_h = false
			
		move_and_slide()


func _on_node_ready_for_movement() -> void:
	allow_movement = true
	stop_all_movement = false # for restart

func _on_node_stop_movement() -> void:
	allow_movement = false
	
func _on_node_stop_all_movement() -> void:
	stop_all_movement = true


func _on_area_2d_jump_pad_body_entered(body: Node2D) -> void:
	print("Detected: ", body.name)

	if body.name == "Player":
		self.velocity.y = -800
