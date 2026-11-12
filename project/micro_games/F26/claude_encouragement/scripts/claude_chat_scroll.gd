extends Panel

@export var y_array: Array[float]
@export var claude_script: ClaudeEncourageScript
@export var move_speed: float
var stage: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var whipCount: int = claude_script.whip_count
	var total: int = claude_script.whips_required
	
	var divisor: float = 1
	if y_array.size() - 1 != 0: divisor = float(total) / (y_array.size() - 1)
	
	var indx: int = clampi(floori(whipCount / divisor), 0, y_array.size()-1)
	var lerpPos: Vector2 = Vector2(position.x, y_array[indx]) 
	
	position = self.position.lerp(lerpPos, delta*move_speed)
