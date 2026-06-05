extends Node2D

# Mirrors view/Santa.as — drag horizontally; play "nice catch" animation +
# particles + sound when a present is caught.

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: CPUParticles2D = $CatchParticles

var paused: bool = false
var _dragging: bool = false

func _input(event: InputEvent) -> void:
	if paused:
		return
	if event is InputEventScreenTouch:
		_dragging = event.pressed
	elif event is InputEventScreenDrag and _dragging:
		scale.x = -1.0 if event.position.x < position.x else 1.0
		position.x = clamp(event.position.x, 0, Constants.STAGE_WIDTH)

func nice_catch() -> void:
	particles.emitting = false
	particles.emitting = true
	if sprite.sprite_frames:
		sprite.frame = 0
		sprite.play()
	MusicManager.play_coin()
