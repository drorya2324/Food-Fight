extends KinematicBody

const PROJECTILE_SPEED = 50

enum CHARACTER_TYPES{player,npc}


var ending # 0 is gameover 1 is victory
var character_type
var ammo_types = {}
var can_fire = true

var lives = 3

func _enter_tree():
	ammo_types = FileGrabber.get_files("res://Scenes/Ammo/Ammo_Models/")
	randomize()


func fire():
	var random_bullet = ammo_types[randi() % ammo_types.size()]
	var bullet = load(random_bullet).instance()
	add_child(bullet)
	bullet.fired_by = character_type
	bullet.set_as_toplevel( true)
	bullet.global_transform = $Forward.global_transform
	var character_forward = get_global_transform().basis[2].normalized()
	bullet.set_linear_velocity(character_forward * PROJECTILE_SPEED)
	bullet.add_collision_exception_with(self)


func _on_CanFire_timeout():
	can_fire = true

# Being called by Projectile.gd
func hurt(hurt_by):
	if character_type != hurt_by:
		lives -= 1
		$Hurt_FSX.play()
		check_lives()
		update_lives()


func check_lives():
	if lives < 1:
		die()

func update_lives():
	if character_type == CHARACTER_TYPES.player:
		get_tree().call_group("GUI","update_lives", lives)
		

func die():
	queue_free()

