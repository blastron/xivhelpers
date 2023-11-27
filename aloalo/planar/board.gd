extends Sprite2D

const Tile = preload("res://planar/tile.gd")


var edge_tiles = {}
var center_tiles = {}

var editor_mode: bool : set = _set_editor_mode, get = _get_editor_mode
var _editor_mode: bool


func _ready():
	for child in get_children():
		if child.name.find("edge") != -1:
			# This is a container for tiles. It should only contain tiles.
			var containerName = child.name.substr(5,1) + child.name.substr(7,1)
			for tile in child.get_children():
				var tileName = containerName + tile.name
				edge_tiles[tileName] = tile
				tile.clicked.connect(func(): edge_clicked(tileName))
		elif child.name.find("center") != -1:
			# This is a center tile. It may contain a collision shape.
			var tileName = child.name.substr(7,1) + child.name.substr(9,1)
			center_tiles[tileName] = child
			
			var collision: CollisionObject2D = child.find_child("collision")
			if collision:
				collision.input_event.connect(func(viewport, event, shape_idx):
					if event is InputEventMouseButton and event.is_pressed():
						center_clicked(tileName))
	
	editor_mode = true
	
	center_clicked("22")


func _process(delta):
	pass


func edge_clicked(tileName: String):
	if editor_mode:
		var tile = edge_tiles[tileName]
		
		# Get the next free tile type.
		var testType: Tile.PlayerType = (tile.player_type + 1) % Tile.PlayerType.COUNT
		while testType != Tile.PlayerType.none:
			if get_tile_of_type(testType).is_empty():
				break
			testType = (testType + 1) % Tile.PlayerType.COUNT
		
		if testType != tile.player_type:
			tile.player_type = testType
		else:
			tile.player_type = Tile.PlayerType.none


func center_clicked(tileName: String):
	if editor_mode:
		center_tiles["22"].visible = tileName != "22"
		center_tiles["24"].visible = tileName != "24"
		center_tiles["42"].visible = tileName != "42"
		center_tiles["44"].visible = tileName != "44"


func _set_editor_mode(new_mode: bool):
	if new_mode != _editor_mode:
		_editor_mode = new_mode
		for tile_name in edge_tiles:
			var tile: Tile = edge_tiles[tile_name]
			tile.editor_mode = new_mode


func _get_editor_mode() -> bool:
	return _editor_mode


func get_tile_of_type(type: Tile.PlayerType) -> String:
	for tile_name in edge_tiles:
		var tile: Tile = edge_tiles[tile_name]
		if tile.player_type == type:
			return tile_name
	return ""
