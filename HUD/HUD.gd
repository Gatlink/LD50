extends VBoxContainer


export (NodePath) var ship_path : NodePath


onready var ship : Ship = get_node(ship_path)
onready var score_label : Label = $Score/Label
onready var time_label : Label = $Time/Label


func _process(_delta: float) -> void:
	var seconds := int(ship.elapsed_time)
# warning-ignore:integer_division
	time_label.text = "%02d:%02d.%02d" % [seconds / 60, seconds % 60, (ship.elapsed_time - seconds) * 100]
	score_label.text = str(ship.score)
