extends Spatial

var enemy_count

func _ready():
	instance_PC()
	count_enemies()
	
	
func count_enemies():
	enemy_count = $Robots.get_child_count()

func remove_enemy():
	enemy_count -= 1
	if enemy_count < 1:
		get_tree().change_scene("res://Scenes/GUI/GameOver/Victory.tscn")




func instance_PC():
	var Player
	Player =  preload ("res://Scenes/characters/Players/PlayerM.tscn").instance()
	if Costumisation.Player_character == "Feale":
		Player = Costumisation.female.instance()
	else:
		Player = Costumisation.male.instance()

	add_child(Player)
	Player.transform = $PlayerStartPos.transform





