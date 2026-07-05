extends CanvasLayer


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_replay_button_pressed() -> void:
	Globals.reset_game()
