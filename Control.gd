extends Control

var root_Node = null

var event = null


func _ready():
	root_Node = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	event = root_Node.get_node("Control/Panel/events")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass