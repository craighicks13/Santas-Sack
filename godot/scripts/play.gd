extends Node2D

# Mirrors state/Play.as — orchestrates the round.

@onready var elf: Node2D = $Elf
@onready var santa: Node2D = $Santa
@onready var spawner: Node2D = $PresentSpawner
@onready var presents: Node2D = $Presents
@onready var drops: Node2D = $DropCounter
@onready var score_label: Label = $UI/ScoreLabel

var score: int = 0
var paused: bool = false

func _ready() -> void:
	drops.max_drops_reached.connect(_on_game_over)
	presents.child_entered_tree.connect(_wire_present)
	elf.start()
	spawner.start()
	MusicManager.play_music()

func _wire_present(present: Node) -> void:
	if present.has_signal("hit_ground"):
		present.hit_ground.connect(_on_present_missed)
	if present.has_signal("caught"):
		present.caught.connect(_on_present_caught)

func _on_present_missed(p: Node2D) -> void:
	p.queue_free()
	MusicManager.play_smash()
	drops.add_drop()

func _on_present_caught(p: Node2D) -> void:
	p.queue_free()
	santa.nice_catch()
	score += 1
	score_label.text = str(score)
	if score % 10 == 0:
		elf.increase_speed()
		spawner.increase_level()

func _on_game_over() -> void:
	spawner.stop()
	elf.stop()
	santa.paused = true
	MusicManager.stop_music()
	MusicManager.play_game_over()
	GameData.record_score(score)
	# TODO: show game_over.tscn as a popup / call Game.change_state(Game.State.GAME_OVER)
