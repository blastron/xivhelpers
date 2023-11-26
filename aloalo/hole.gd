extends Node2D


var player: AnimatedSprite2D
var ring: AnimatedSprite2D
var debuff_hole: AnimatedSprite2D
var debuff_num: AnimatedSprite2D
var outcome: AnimatedSprite2D
var spinner: AnimatedSprite2D

var streak_label: Label
var time_label: Label

var clockwise: bool

var active: bool
var time_start
var streak: int = 0


func _ready():
	player = find_child("Player")
	ring = find_child("Ring")
	debuff_hole = find_child("Hole Debuff")
	debuff_num = find_child("Number Debuff")
	outcome = find_child("Outcome")
	spinner = find_child("Spinner")
	streak_label = find_child("Streak")
	time_label = find_child("Time")
	
	player.frame = 2
	player.show()
	
	ring.hide()
	debuff_hole.hide()
	debuff_num.hide()
	outcome.hide()
	spinner.hide()
	
	time_label.hide()
	streak_label.text = "streak: 0"
	
	active = false


func _input(event):
	if not event is InputEventKey or not event.pressed:
		return
	
	if active:
		if event.is_action("up"):
			set_player_facing(0)
		elif event.is_action("left"):
			set_player_facing(1)
		elif event.is_action("down"):
			set_player_facing(2)
		elif event.is_action("right"):
			set_player_facing(3)
		elif event.is_action("select"):
			evaluate_selection()
	else:
		if event.is_action("select"):
			init_next_run()


func init_next_run():
	clockwise = randi_range(0, 2) == 0
	
	player.show()
	ring.show()
	
	debuff_hole.frame = randi_range(0, 4)
	debuff_hole.show()
	
	debuff_num.frame = randi_range(0, 2)
	debuff_num.show()
	
	spinner.show()
	spinner.play("cw" if clockwise else "ccw")
	spinner.frame = 0
	
	outcome.hide()
	time_label.hide()
	
	active = true
	time_start = Time.get_ticks_msec()
	
	set_player_facing(player.frame)


func set_player_facing(index: int):
	player.frame = index
	ring.frame = (index + debuff_hole.frame) % 4


func evaluate_selection():
	if debuff_num.frame == 0:
		clockwise = not clockwise
	
	var directional_offset: int = (1 if clockwise else -1)
	debuff_hole.frame = posmod(debuff_hole.frame + directional_offset, 4)
	ring.frame = posmod(ring.frame + directional_offset, 4)
	
	spinner.hide()
	outcome.show()
	
	if ring.frame == 0:
		outcome.frame = 0
		streak += 1
	else:
		outcome.frame = 1
		streak = 0
	
	var elapsed_msec: float = Time.get_ticks_msec() - time_start
	streak_label.text = "streak: %d" % streak
	time_label.text = "time: %.1f sec" % (elapsed_msec / 1000)
	time_label.show()
	
	active = false
	
	
