extends MicroGame

var timeout : float

#refs
@export var claude_sprite: Sprite2D

#stuff
@export var whip_count: int = 0
@export var game_array: Array[Claude_Progression]
@export var shake_curve: Curve



func _ready():
	default_game_duration = 5
	#get_tree().create_timer(timeout).timeout.connect(func(): done.emit(true))

func _unhandled_input(event: InputEvent) -> void:
	if timer.elasped_time() < 1.0/4:
		return
		
	if event.is_action("space"):
		trigger_game_won()
	elif event is InputEventKey and event.is_pressed():
		trigger_game_lost()
	
func on_win():
	print("game won")

func on_lose():
	audio_service.paused = true


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("detected input")
	if event.is_action("left"):
		whip_count += 1
		print("whip count: ", whip_count)
		
