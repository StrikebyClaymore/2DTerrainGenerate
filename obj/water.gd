extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_water_body_entered( body ):
	body.queue_free()
	get_parent().remove_child(body)


func _on_water_area_entered( area ):
	area.queue_free()
	#get_parent().remove_child(area)
