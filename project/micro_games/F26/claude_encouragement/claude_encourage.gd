extends MicroGame

var timeout : float

#refs
var gamelost: bool = false
var gamewon: bool = false
@export var claude_sprite: Sprite2D
var claude_init_pos: Vector2
@export var claude_anim: AnimationPlayer
@export var whip_part: CPUParticles2D

@export var whip_sprite: Sprite2D
@export var whip_sprite_rest: Texture2D
@export var whip_sprite_clicked: Texture2D
@export var whips_required: int = 1

@export var whip_sprite_time_appeared: float = 0.2
var whip_timer: Timer

#stuff
@export var whip_count: int = 0
@export var game_array: Array[Claude_Progression]
@export var shake_curve: Curve
@export var shake_intensity: float = 3
var extra_shake: float = 0

var on_claude: bool



func _ready():
	default_game_duration = 5
	#get_tree().create_timer(timeout).timeout.connect(func(): done.emit(true))
	claude_init_pos = claude_sprite.transform.get_origin()
	
	claude_anim.play("claude0")
	
	for arr in game_array:
		whips_required += arr.whips_needed

func _random_inside_unit_circle() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	whip_sprite.transform.origin = mouse_pos
	
	if extra_shake > 0: extra_shake -= delta * 2
	
	var shakepos: Vector2 = shake_intensity * (_random_inside_unit_circle() * shake_curve.sample(float(whip_count) / whips_required))
	claude_sprite.transform.origin = claude_init_pos + shakepos * extra_shake

func _unhandled_input(event: InputEvent) -> void:
	if timer.elasped_time() < 1.0/4 or gamelost:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_whip()
		else: _whip_end()
			
		
		

func _on_claude_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass

func on_win():
	gamewon = true
	claude_anim.clear_queue()
	claude_anim.play("claudeDead")

func on_lose():
	gamelost = true
	
	#audio_service.paused = true

func _whip():
	#print("whip called")
	
	whip_sprite.texture = whip_sprite_clicked
	whip_part.emitting = true
	
	if on_claude:
		whip_count += 1
		print("whip count: ", whip_count)
		
		if whip_count >= whips_required:
			if !gamewon: trigger_game_won()
			return
		
		extra_shake = 1
		
		var whip_sum: int = 0
		var indx: int = -1
		for arr in game_array:
			indx += 1
			whip_sum += arr.whips_needed
			if whip_count > whip_sum:
				#the phase that the whips are in
				claude_anim.clear_queue()
				claude_anim.speed_scale = arr.anim_speed
				claude_anim.play("claudeHurt")
				claude_anim.queue("claude" + str(indx))

func _whip_end():
	whip_sprite.texture = whip_sprite_rest


func _on_claude_mouse_entered() -> void:
	on_claude = true

func _on_claude_mouse_exited() -> void:
	on_claude = false
