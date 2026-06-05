extends Node2D

# Mirrors view/Present.as — a single falling present. Has no real physics;
# it just adds `speed` to y each frame, exactly like the AS3 original.

signal hit_ground(present: Node2D)
signal caught(present: Node2D)

@onready var sprite: Sprite2D = $Sprite2D
@onready var catch_area: Area2D = $CatchArea

var speed: float = 80.0
var present_type: int = 0

func _ready() -> void:
	catch_area.area_entered.connect(_on_catch_area_entered)

func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y >= Constants.GROUND_Y:
		hit_ground.emit(self)

func _on_catch_area_entered(_other: Area2D) -> void:
	caught.emit(self)
