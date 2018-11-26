extends Area2D

#var open_space = preload("res://obj/open_space.tscn")#0
#var earth = preload("res://obj/earth.tscn")#1
#var grass = preload("res://obj/grass.tscn")#2
#var water = preload("res://obj/water.tscn")#3
var tree = preload("res://obj/tree.tscn")#4
var rock = preload("res://obj/rock.tscn")#5
var bush = preload("res://obj/bush.tscn")#6
var stone = preload("res://obj/stone.tscn")#7

var x = 0
var y = 0

var side = ""

var disabled = false

var killTree = false
var killStone = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_grass_body_entered( body ):
	if body.is_in_group("stone"):
		body.queue_free()
		get_parent().remove_child(body)
		var s = stone.instance()
		s.position = Vector2(x, y)
		add_child(s)
		
	if body.is_in_group("bush"):
		body.queue_free()
		get_parent().remove_child(body)
		var b = bush.instance()
		b.position = Vector2(x, y)
		add_child(b)
		var i = 0
		while i < get_children().size():
			if i > 1:
				if get_child(i).is_in_group("stone"):
					get_child(i).queue_free()
					remove_child(get_child(i))
					i-=1
			i+=1
		
	if body.is_in_group("tree"):
		if killTree:
			body.queue_free()
			get_parent().remove_child(body)
			killTree = false
		if killStone:
			var i = 0
			while i < get_children().size():
				if i > 1:
					#print(get_child(i))
					get_child(i).queue_free()
					remove_child(get_child(i))
					i-=1
				i+=1

func checkChild(type):
	var i = 0
	while i < get_children().size():
		if i > 1:
			if(type == "tree"):
				if get_child(i).is_in_group("tree"):
					return true
				else:
					return false
			if(type == "stone"):
				if get_child(i).is_in_group("stone"):
					return true
				else:
					return false
		i+=1
		
func getChild(type):
	var i = 0
	while i < get_children().size():
		if i > 1:
			if(type == "tree"):
				if get_child(i).is_in_group("tree"):
					return get_child(i)
				else:
					return null
			if(type == "stone"):
				if get_child(i).is_in_group("stone"):
					return get_child(i)
				else:
					return null
		i+=1


func _on_grass_input_event( viewport, event, shape_idx ):
	if Input.is_action_pressed("left_click"):
		self.queue_free()
		print("You deleted grass")


func _on_grass_area_entered( area ):
	if area.is_in_group("earth"):
		area.queue_free()
	if area.is_in_group("grassBottom"):
		area.queue_free()
