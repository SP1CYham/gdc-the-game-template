extends Label

@export var num_lines: int = 20
@export var all_chats: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var all_chats_copy: Array[String] = all_chats.duplicate()
	
	#pop until 20
	for i in range(all_chats_copy.size() - num_lines):
		var rand: int = randi_range(0, all_chats_copy.size() -1)
		all_chats_copy.pop_at(rand)
	
	all_chats_copy.shuffle()
	text = "\n".join(all_chats_copy)
