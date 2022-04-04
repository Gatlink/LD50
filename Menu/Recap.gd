extends VBoxContainer


onready var time_label : Label = $Time/Label
onready var score_label : Label = $Score/Label


func _ready() -> void:
	var save := File.new()
	save.open("user://user.save", File.READ)
	
	var lines := []
	while save.get_position() < save.get_len():
		lines.append(save.get_line())
	
	var infos : Array = lines[lines.size() - 1].split("|")
	time_label.text = infos[0]
	score_label.text = infos[1]
