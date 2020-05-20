extends Area



func _on_RefillArea_body_entered(body):
	if body.has_method("RefillArea_enterd"):
		body.RefillArea_enterd()


func _on_RefillArea_body_exited(body):
	if body.has_method("RefillArea_exited"):
		body.RefillArea_exited()
