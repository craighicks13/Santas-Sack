extends Node2D

# Mirrors controllers/DropController.as — visual counter for missed presents.

signal max_drops_reached

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var drops: int = 0

func add_drop() -> void:
	drops += 1
	if sprite.sprite_frames:
		sprite.frame = min(drops, sprite.sprite_frames.get_frame_count(sprite.animation) - 1)
	if drops >= Constants.MAX_DROPS:
		max_drops_reached.emit()

func reset() -> void:
	drops = 0
	if sprite.sprite_frames:
		sprite.frame = 0
