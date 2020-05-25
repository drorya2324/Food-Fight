extends CanvasLayer


func _enter_tree():
	pause_mode = Node.PAUSE_MODE_PROCESS


func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		tuggle_pause_menu()


func tuggle_pause_menu():
	if get_tree().paused:
		$Popup.popup_centered()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		$Popup.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_FullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Customise_pressed():
	get_tree().change_scene("res://Scenes/Customisation/CharacterCostumisaton.tscn")


func _on_Quit_pressed():
	get_tree().quit()
