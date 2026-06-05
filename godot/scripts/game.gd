extends Node

enum State { MAIN, PLAY, GAME_OVER }

const SCENES := {
	State.MAIN: "res://scenes/main_menu.tscn",
	State.PLAY: "res://scenes/play.tscn",
	State.GAME_OVER: "res://scenes/game_over.tscn",
}

func change_state(state: State) -> void:
	get_tree().change_scene_to_file(SCENES[state])
