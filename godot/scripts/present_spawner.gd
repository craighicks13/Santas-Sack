extends Node2D

# Mirrors controllers/PresentController.as — spawns presents from the elf's
# current position at a configurable rate, and ramps difficulty.

const PRESENT_SCENE: PackedScene = preload("res://scenes/present.tscn")

@export var elf_path: NodePath
@export var presents_container: NodePath

var rate: float = Constants.PRESENT_INIT_RATE
var speed: float = Constants.PRESENT_INIT_SPEED
var level: int = 1

var _elf: Node2D
var _container: Node2D
var _accum: float = 0.0
var _running: bool = false

func _ready() -> void:
	_elf = get_node(elf_path)
	_container = get_node(presents_container)

func start() -> void:
	_running = true

func stop() -> void:
	_running = false

func reset() -> void:
	for child in _container.get_children():
		child.queue_free()
	rate = Constants.PRESENT_INIT_RATE
	speed = Constants.PRESENT_INIT_SPEED
	level = 1

func increase_level() -> void:
	speed *= 1.1
	if rate > 0.25:
		rate -= 0.05
	level += 1

func _process(delta: float) -> void:
	if not _running:
		return
	_accum += delta
	if _accum >= rate:
		_accum = 0.0
		_spawn()

func _spawn() -> void:
	var p: Node2D = PRESENT_SCENE.instantiate()
	p.position = Vector2(_elf.position.x, _elf.position.y + 18)
	p.set("speed", speed)
	p.set("present_type", level - 1)
	_container.add_child(p)
