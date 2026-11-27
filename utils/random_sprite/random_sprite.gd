## Shows one random frame of a horizontal sprite sheet of square frames.
@tool
class_name RandomSprite
extends Sprite2D

@export_tool_button("Refresh") var refresh_action = _choose_random_sprite

## Width and height of one frame, in pixels.
@export var size := 16.0
## Number of frames in the sheet.
@export var count := 1


func _ready() -> void:
	_choose_random_sprite()


func _choose_random_sprite() -> void:
	var index := randi_range(0, count - 1)
	region_enabled = true
	region_rect = Rect2(index * size, 0, size, size)
