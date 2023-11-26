extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	find_child("hole button").pressed.connect(self.hole_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func hole_button_pressed():
	get_tree().change_scene_to_file("res://hole.tscn")
