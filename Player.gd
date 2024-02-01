extends RigidBody3D

## How much vertical force to apply when moving
@export_range(750.0, 3000.0) var thrust: float = 1000.0
@export var torqueThrust: float = 100.0

var isTransitioning := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)

	if Input.is_action_pressed("rotateLeft"):
		apply_torque(Vector3(0.0, 0.0, torqueThrust * delta))

	if Input.is_action_pressed("rotateRight"):
		apply_torque(Vector3(0.0, 0.0, -torqueThrust * delta))


func _on_body_entered(body: Node) -> void:
	if !isTransitioning:
		if "Goal" in body.get_groups():
			completeLevel(body.file_path)
		if "Hazard" in body.get_groups():
			crashSequence()
		
func crashSequence() -> void:
	print("You lose")
	tweenTrans(get_tree().reload_current_scene)

func completeLevel(next_level_file: String) -> void:
	print("winner winner chicken dinner")
	tweenTrans(get_tree().change_scene_to_file.bind(next_level_file))

func tweenTrans(callFunc: Callable) -> void:
	set_process(false)
	isTransitioning = true
	var tween = create_tween()
	tween.tween_interval(1.5)
	tween.tween_callback(callFunc)
