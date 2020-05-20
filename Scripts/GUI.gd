extends CanvasLayer


func refresh_AmmoCount(ammo):
	$Refill/CenterContainer/AmmoCount.text = str(ammo)

func Refill(amount):
	$Refill.value = amount * 100


func update_lives(lives):
	var heart = preload("res://gfx/heart.png")
	$Lives.clear()
	for i in lives:
		$Lives.add_icon_item(heart, false)

func game_over(ending):
	if ending == 0:
		get_tree().change_scene("res://Scenes/GUI/GameOver/GameOver.tscn")
	else:
		get_tree().change_scene("res://Scenes/GUI/GameOver/Victory.tscn")


