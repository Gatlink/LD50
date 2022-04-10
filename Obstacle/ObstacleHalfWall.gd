extends Obstacle


export (float, 0, 1) var ad_probability : float = 0.5
export (Array, Texture) var ads : Array


onready var ad : MeshInstance = $"Graph/LD50-Obstacle-Wall-Half-01/Obstacle-Wall-Half-01-CM"


func _ready() -> void:
	if ads.size() > 0 and randf() < ad_probability:
		ad.material_override.albedo_texture = ads[randi() % ads.size()]
	else:
		ad.visible = false
