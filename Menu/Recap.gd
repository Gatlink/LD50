extends VBoxContainer


onready var time_label : Label = $ElapsedTime
onready var time_value : Label = $Time/Value
onready var distance_value : Label = $Distance/Value
onready var bonus_value : Label = $Bonuses/Value
onready var total_value : Label = $Total/Value
onready var best_value : Label = $Best/Value


func _ready() -> void:
	var save := File.new()
# warning-ignore:return_value_discarded
	save.open("user://user.save", File.READ)
	
	var infos : Array
	var best := 0
	while save.get_position() < save.get_len():
		var line := save.get_line()
		infos = line.split("|")
		
		var current := int(infos[4])
		if current > best:
			best = current
	
	time_label.text = infos[0]
	time_value.text = "+" + infos[1]
	distance_value.text = "+" + infos[2]
	bonus_value.text = "+" + infos[3]
	total_value.text = infos[4]
	best_value.text = str(best)
	
