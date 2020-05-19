extends "res://Scripts/character.gd"


func _physics_process(delta):
	if $RayCast.is_colliding() and can_fire:
		fire()
		can_fire = false
		$CanFire.start()
		


func hurt():
	pass
