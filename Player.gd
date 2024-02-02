extends RigidBody3D

## How much vertical force to apply when moving
@export_range(750.0, 3000.0) var thrust: float = 1000.0
@export var torqueThrust: float = 100.0

@onready var explosionSound := $ExplosionAudio
@onready var successAudio := $SuccessAudio
@onready var rocketAudio := $RocketAudio
@onready var boosterParticles = $BoosterParticles
@onready var rightBoosterParticles = $RightBoosterParticles
@onready var leftBoosterParticles = $LeftBoosterParticles

var isTransitioning := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		boosterParticles.emitting = true
		if !rocketAudio.playing:
			rocketAudio.play()
	else:
		boosterParticles.emitting = false
		rocketAudio.stop()

	if Input.is_action_pressed("rotateLeft"):
		apply_torque(Vector3(0.0, 0.0, torqueThrust * delta))
		rightBoosterParticles.emitting = true
	else:
		rightBoosterParticles.emitting = false

	if Input.is_action_pressed("rotateRight"):
		apply_torque(Vector3(0.0, 0.0, -torqueThrust * delta))
		leftBoosterParticles.emitting = true
	else:
		leftBoosterParticles.emitting = false


func _on_body_entered(body: Node) -> void:
	if !isTransitioning:
		if "Goal" in body.get_groups():
			completeLevel(body.file_path)
		if "Hazard" in body.get_groups():
			crashSequence()
		
func crashSequence() -> void:
	print("You lose")
	explosionSound.play()
	tweenTrans(get_tree().reload_current_scene)

func completeLevel(next_level_file: String) -> void:
	print("winner winner chicken dinner")
	successAudio.play()
	if next_level_file == "NA":
		tweenTrans(get_tree().quit)
	else:
		tweenTrans(get_tree().change_scene_to_file.bind(next_level_file))

func tweenTrans(callFunc: Callable) -> void:
	set_process(false)
	isTransitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(callFunc)
