class_name Bezier


var points : Array


func _init(_points : Array) -> void:
	points = _points


func evaluate(t : float) -> Vector3:
	var count := points.size()
	if count == 0:
		return Vector3.ZERO
	
	if count == 1:
		return points[0]
	
	var next_points : Array = []
	for i in count - 1:
		next_points.append(points[i].linear_interpolate(points[i + 1], t))
	
	return get_script().new(next_points).evaluate(t)
