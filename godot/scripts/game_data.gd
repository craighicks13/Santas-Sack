extends Node

const SAVE_PATH := "user://savegame.cfg"
const MAX_SCORES := 5

var muted: bool = false
var high_scores: Array = []
var last_scores: Array = []

func _ready() -> void:
	load_data()

func load_data() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		muted = cfg.get_value("settings", "muted", false)
		high_scores = cfg.get_value("scores", "high", [])
		last_scores = cfg.get_value("scores", "last", [])
	_pad_scores()

func save_data() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("settings", "muted", muted)
	cfg.set_value("scores", "high", high_scores)
	cfg.set_value("scores", "last", last_scores)
	cfg.save(SAVE_PATH)

func record_score(value: int) -> void:
	var date := Time.get_date_string_from_system()
	last_scores.push_front({"score": value, "date": date})
	high_scores.append({"score": value, "date": date})
	high_scores.sort_custom(func(a, b): return int(a.score) > int(b.score))
	high_scores = high_scores.slice(0, MAX_SCORES)
	last_scores = last_scores.slice(0, MAX_SCORES)
	save_data()

func set_muted(value: bool) -> void:
	muted = value
	save_data()

func _pad_scores() -> void:
	while high_scores.size() < MAX_SCORES:
		high_scores.append({"score": 0, "date": ""})
	while last_scores.size() < MAX_SCORES:
		last_scores.append({"score": 0, "date": ""})
