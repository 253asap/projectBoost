extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello World")
	print("Dont Panic")
	print(42)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		print("The spacebar is pressed")
