extends Area2D


enum PlayerType {none, one, two_tm, two_hr, three, COUNT}


var cross: Sprite2D
var check: Sprite2D
var editor_icons: AnimatedSprite2D

var player_type: PlayerType : set = _set_player_type, get = _get_player_type
var editor_mode: bool : set = _set_editor_mode, get = _get_editor_mode


signal clicked


# Called when the node enters the scene tree for the first time.
func _ready():
	check = find_child("Check")
	check.hide()
	cross = find_child("Cross")
	cross.hide()
	
	editor_icons = find_child("Editor Player Icons")
	
	player_type = PlayerType.none
	editor_mode = false


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		clicked.emit()


func _set_player_type(type: PlayerType):
	match type:
		PlayerType.none:
			editor_icons.frame = 0
		PlayerType.one:
			editor_icons.frame = 1
		PlayerType.two_tm:
			editor_icons.frame = 2
		PlayerType.two_hr:
			editor_icons.frame = 3
		PlayerType.three:
			editor_icons.frame = 4


func _get_player_type() -> PlayerType:
	match editor_icons.frame:
		1: return PlayerType.one
		2: return PlayerType.two_tm
		3: return PlayerType.two_hr
		4: return PlayerType.three
	return PlayerType.none


func _set_editor_mode(new_mode: bool):
	editor_icons.visible = new_mode

func _get_editor_mode() -> bool:
	return editor_icons.visible
