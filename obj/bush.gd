extends RigidBody2D

var killStone = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_bush_body_entered( body ):
	if body.is_in_group("stone"):
		if killStone:
			body.queue_free()
