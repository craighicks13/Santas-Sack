extends Node

var music: AudioStreamPlayer
var sfx_coin: AudioStreamPlayer
var sfx_smash: AudioStreamPlayer
var sfx_game_over: AudioStreamPlayer

func _ready() -> void:
	music = _make_player("Music", "res://assets/audio/music.mp3", true)
	sfx_coin = _make_player("Coin", "res://assets/audio/coin.mp3", false)
	sfx_smash = _make_player("Smash", "res://assets/audio/smash.mp3", false)
	sfx_game_over = _make_player("GameOver", "res://assets/audio/game-over.mp3", false)

func _make_player(name: String, path: String, loop: bool) -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.name = name
	var stream = load(path)
	if stream:
		if "loop" in stream:
			stream.loop = loop
		p.stream = stream
	add_child(p)
	return p

func play_music() -> void:
	if not GameData.muted and music.stream:
		music.play()

func pause_music() -> void:
	music.stream_paused = true

func resume_music() -> void:
	music.stream_paused = false

func stop_music() -> void:
	music.stop()

func play_coin() -> void:
	if not GameData.muted and sfx_coin.stream:
		sfx_coin.play()

func play_smash() -> void:
	if not GameData.muted and sfx_smash.stream:
		sfx_smash.play()

func play_game_over() -> void:
	if not GameData.muted and sfx_game_over.stream:
		sfx_game_over.play()
