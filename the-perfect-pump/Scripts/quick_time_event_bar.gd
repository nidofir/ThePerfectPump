extends Node2D

@onready var qteb_background: Sprite2D = $QTEB_Background
@onready var qteb_pointer: Sprite2D = $QTEB_Pointer
@onready var start: Marker2D = $start
@onready var safe_start_pos: Marker2D = $SafeStartPos
@onready var safe_end_pos: Marker2D = $SafeEndPos
@onready var crit_fail: Marker2D = $CritFail
@onready var end: Marker2D = $end

var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if qteb_pointer.position.x <=start.position.x:
		direction = 1
	elif qteb_pointer.position.x >= end.position.x:
		print("THE FUEL IS GOING EVERYWHERE!!")
	qteb_pointer.position.x+= direction
	if Input.is_action_just_pressed("ui_accept"):
		if qteb_pointer.position.x >= safe_start_pos.position.x and  qteb_pointer.position.x <= safe_end_pos.position.x:
			print("Perfect Pump!!") 
		if qteb_pointer.position.x >= start.position.x and  qteb_pointer.position.x <= safe_start_pos.position.x:
			print("Too early...") 
		if qteb_pointer.position.x >= safe_end_pos.position.x and  qteb_pointer.position.x <= crit_fail.position.x:
			print("Too late...") 
		if qteb_pointer.position.x >= crit_fail.position.x and  qteb_pointer.position.x <= end.position.x:
			print("WHAT ARE YOU DOING???") 
