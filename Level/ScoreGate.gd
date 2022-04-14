class_name ScoreGate
extends Area


export (float) var time_max_score := 1.0


onready var collider : CollisionShape = $CollisionShape


func activate() -> void:
	collider.disabled = false


func deactivate() -> void:
	collider.disabled = true
