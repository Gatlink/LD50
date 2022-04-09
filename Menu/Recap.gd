extends VBoxContainer


onready var time_label : Label = $ElapsedTime
onready var speed_value : Label = $Speed/Value
onready var bonus_value : Label = $Bonuses/Value
onready var total_value : Label = $Total/Value
onready var best_value : Label = $Best/Value


func _ready() -> void:
	var save := File.new()
# warning-ignore:return_value_discarded
	save.open("user://user.save", File.READ)
	
	var infos : Array
	var best := 0
	var best_line : String
	while save.get_position() < save.get_len():
		var line := save.get_line()
		infos = line.split("|")
		if infos.size() != 4:
			continue
		
		var current := int(infos[3])
		if current > best:
			best = current
			best_line = line
	
	if infos.size() == 4:
		time_label.text = infos[0]
		speed_value.text = "+" + infos[1]
		bonus_value.text = "+" + infos[2]
		total_value.text = infos[3]
		best_value.text = str(best)
	
	save.close()
# warning-ignore:return_value_discarded
	save.open("user://user.save", File.WRITE)
	save.store_line(best_line)
	save.close()
