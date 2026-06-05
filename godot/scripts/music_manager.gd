extends Node

# Wire AudioStreamPlayer children up in the editor once .mp3 assets are imported.
# These nodes are created at runtime so the autoload works before assets exist.

var music: AudioStreamPlayer
var sfx_coin: AudioStreamPlayer
var sfx_smash: AudioStreamPlayer
var sfx_game_over: AudioStreamPlayer

func _ready() -> void:
	music = _make_player("Music")
	sfx_coin = _make_player("Coin")
	sfx_smash = _make_player("Smash")
	sfx_game_over = _make_player("GameOver")

func _make_player(name: String) -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.name = name
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
