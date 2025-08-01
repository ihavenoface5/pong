extends Control

func _ready() -> void:
	%StartButton.pressed.connect(_on_start_pressed)
	%QuitButton.pressed.connect(_on_quit_pressed)
	%DifficultySelection.item_selected.connect(_on_difficulty_selected)
	%MaxScoreSelection.item_selected.connect(_on_max_score_selected)
	%Volume.value_changed.connect(_on_volume_changed)
	%Volume.value = GameSettings.volume * 100
	%DifficultySelection.select(GameSettings.difficulty)
	%MaxScoreSelection.select(0 if GameSettings.winScore == 3 else 1 if GameSettings.winScore == 5 else 2)
	%StartButton.grab_focus()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_difficulty_selected(index: int) -> void:
	match(index):
		0:
			GameSettings.difficulty = GameSettings.Difficulty.easy
		1:
			GameSettings.difficulty = GameSettings.Difficulty.medium
		_:
			GameSettings.difficulty = GameSettings.Difficulty.hard

func _on_max_score_selected(index: int) -> void:
	GameSettings.winScore = 3 if index == 0 else 5 if index == 1 else 10

func _on_volume_changed(volume: float) -> void:
	GameSettings.volume = volume / 100
