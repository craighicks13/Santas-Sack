extends Node2D

# Mirrors ElfController.as — walks the elf back and forth across the top of the
# screen at an accelerating pace. Drops are emitted by PresentSpawner, which
# reads `position.x` directly.

const MARGIN: int = 15

var speed: float = Constants.ELF_INIT_SPEED
var _tween: Tween

func start() -> void:
	_next_destination()

func stop() -> void:
	if _tween and _tween.is_running():
		_tween.kill()

func reset() -> void:
	speed = Constants.ELF_INIT_SPEED

func increase_speed() -> void:
	speed += 1.0

func _next_destination() -> void:
	var destination: int = randi_range(MARGIN, Constants.STAGE_WIDTH - MARGIN)
	var distance_ratio: float = abs(destination - position.x) / float(Constants.STAGE_WIDTH - 30)
	var duration: float = (3.0 / speed) * distance_ratio
	scale.x = -1.0 if destination < position.x else 1.0

	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(self, "position:x", float(destination), duration)
	_tween.tween_callback(_next_destination)
