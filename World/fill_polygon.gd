extends Node2D

var pairing=["12","01","02"]
var filled:bool=false

func _ready():
	scale=Vector2(0,0)
	get_child(0).color=Game.World_node.lineColorChecked
	get_child(0).color.a=0.3
	
func setup(point0,point1,point2):
	var line0=str(point1)+str(point2)
	var line1=str(point0)+str(point1)
	var line2=str(point0)+str(point2)
	pairing=[line0,line1,line2]
	
	var offset=get_child(0).offset
	get_child(0).polygon=[Game.World_node.pointpositions[point0]-offset,Game.World_node.pointpositions[point1]-offset,Game.World_node.pointpositions[point2]-offset]
	
func _process(delta):
	var size=clamp($DecayTimer.time_left/$DecayTimer.wait_time,0.0,1.0)
	scale=Vector2(size,size)

func set_filled():
	if(!filled):
		var tweenScale=get_tree().create_tween()
		tweenScale.tween_property(self,"scale",Vector2(1,1),0.05)
	$DecayTimer.wait_time=Game.World_node.linefill_decayTimerMax
	$DecayTimer.start()
	filled=true

func reset_filled():
	print("reset_filled() | "+str(pairing))
	filled=false
	$DecayTimer.stop()

func finish_diamond_reset():
	var tweenScale=get_tree().create_tween()
	tweenScale.tween_property(self,"scale",Vector2(1,1),0.025)
	tweenScale.tween_property(self,"scale",Vector2(0,0),0.05)
	
	filled=false
	$DecayTimer.stop()

func _on_decay_timer_timeout():
	if(filled):
		for lineid in pairing:
			Game.World_node.uncheck_line_fill(lineid,self)
		filled=false
