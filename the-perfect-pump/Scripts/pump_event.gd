extends CanvasLayer



enum State {IDLE, WAITING,ENGAGE, PUMP, SUCCESS, FAIL}

var current_state: State= State.IDLE 

var point_count: int = 0
@export var indicator_speed: float = 300.0
var indicator_direction: int= 1
var current_NPC: String = ""
var current_NPC_index:int=0
var current_NPC_difficulty:float=0.0

@export var NPC_names: Array[String]=[
	"easiest","easy","mediocre","hard","harder","hardest"
]
@export var NPC_difficulty:Array[int]=[60,20,10,7,2,1]
@export var NPC_difficulty_zone_widths: Array[int]=[130,100,80,65,50,35]

@onready var new_npc_timer: Timer = $NewNPCTimer
@onready var pump_timer: Timer = $PumpTimer
@onready var fuel_bar: Control = $FuelBar
@onready var indicator: ColorRect = $FuelBar/Indicator
@onready var points_label: Label = $UI/PointsLabel
@onready var status_label: Label = $UI/StatusLabel
@onready var target_zone: ColorRect = $FuelBar/TargetZone



func _ready()-> void:
	fuel_bar.visible=false
	#fuel_bar.visible= true
	new_npc_timer.timeout.connect(_on_new_npc_timer_timeout)
	pump_timer.timeout.connect(_on_pump_timer_timeout)
	_set_state(State.IDLE)


func _process(delta:float)->void:
	if current_state != State.PUMP:
		return
	elif current_state == State.PUMP:
		_move_indicator(delta)
#		print("moving indicator")



func _move_indicator(delta:float)->void:
	var max_x: float= fuel_bar.size.x-indicator.size.x
	indicator.position.x += indicator_speed * indicator_direction * delta
	if indicator.position.x >= max_x:
		indicator.position.x = max_x
		indicator_direction = -1
	elif indicator.position.x <= 0.0:
		indicator.position.x = 0.0
		indicator_direction = 1
	

func _reset_indicator()->void:
	var max_x: float = fuel_bar.size.x - indicator.size.x
	indicator.position.x=randf_range(0.0,max_x)
	indicator_direction =1 if randf()>0.5 else -1

func _set_state(new_state:State)->void:
	current_state = new_state
	match new_state:
		State.IDLE:
			status_label.text="press SPACE to summon customers"
			#print("Currently idle")
			fuel_bar.visible= false
			#fuel_bar.visible= true
		State.WAITING:
			status_label.text="waiting for customer"
			emit_signal("ready")
			#print("Currently Waiting")
		State.ENGAGE:
			status_label.text="THERES A CUSTOMER, PRESS AND HOLD SPACE TO START THE PUMP"
			#print("Currently Engaging")
		State.PUMP:
			status_label.text="STOP THE BAR IN THE GREEN ZONE"
			fuel_bar.visible=true
			target_zone.size.x= NPC_difficulty_zone_widths[current_NPC_index]
			var zone_max_x:float = fuel_bar.size.x - target_zone.size.x
			target_zone.position.x=randf_range(0.0, zone_max_x)
			#_reset_indicator()
			pump_timer.wait_time= randf_range(3.0,6.0)
			pump_timer.start()
			#print("Currently pumping")
		State.SUCCESS:
			status_label.text="PERFECT PUMP"
			fuel_bar.visible=false
			#print("Currently success")
		State.FAIL:
			status_label.text="BAD PUMP"
			fuel_bar.visible=false
			#print("Currently fail")



func _input(event:InputEvent)->void:
	if event.is_action_pressed("ui_accept"):
		match current_state:
			State.IDLE:
				_summon_customer()
			State.ENGAGE:
				_start_pump()
			State.PUMP:
				_stop_pump()
			

func _summon_customer()->void:
	_set_state(State.ENGAGE)
	new_npc_timer.wait_time=randf_range(1.5,3.5)
	new_npc_timer.start()
	_spawn_npc()
	_set_state(State.WAITING)

func _spawn_npc()->void:
	print("instance npc")
	#instance
	
func _start_pump()->void:
	new_npc_timer.stop()
	#_pick_NPC()
	_set_state(State.ENGAGE)

func _on_new_npc_timer_timeout()->void:
	_set_state(State.PUMP)
	pump_timer.wait_time=randf_range(1.5,2.5)
	pump_timer.start()

func _on_pump_timer_timeout()->void:
	_fail()
	

func _stop_pump()->void:
	pump_timer.stop()
	var ind_left:float=indicator.position.x
	var ind_right:float=ind_left +indicator.size.x
	var zone_left:float=target_zone.position.x
	var zone_right: float= zone_left +target_zone.size.x
	
	if ind_left>=zone_left and ind_right<=zone_right:
		_success()
	else:
		_fail()

func _success()->void:
	point_count+=1
	var npc:String=current_NPC
	points_label.text="Points %d" %point_count
	status_label.text="blood served"
	indicator_speed=min(indicator_speed+20.0,600.0)
	_set_state(State.SUCCESS)
	status_label.text="you served %s"%[NPC_names]
	await get_tree().create_timer(1.5).timeout
	_set_state(State.IDLE)

func _fail()->void:
	_set_state(State.FAIL)
	status_label.text="blood spilled"
 	#indicator_speed=min(indicator_speed)
	_set_state(State.IDLE)
