extends Node2D

var root_Node = null

var eventText = null
var event = null
var mytext = []
var page = 0
var wipe = false
var mylabel = null

var width = 960
var height = 640
var mapSizeX = width/32
var mapSizeY = height/32
var mapSize = mapSizeX*mapSizeY
var x = 0
var y = 0
var linetype = 0

var zLevel = null

var MAP = []

var floorMas = []

var floorCreate = false
var wallCreate = false

var checkImage = load("res://checkImg.png")

var open_space = preload("res://obj/open_space.tscn")#0
var earth = preload("res://obj/earth.tscn")#1
var grass = preload("res://obj/grass.tscn")#2
var water = preload("res://obj/water.tscn")#3
var tree = preload("res://obj/tree.tscn")#4
var rock = preload("res://obj/rock.tscn")#5
var bush = preload("res://obj/bush.tscn")#6
var stone = preload("res://obj/stone.tscn")#7

func _ready():
	root_Node = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	randomize(true)
	fillMAP()
	eventText = root_Node.get_node("CanvasLayer")
	event = eventText.get_node("Panel/events")
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _draw():
	generate()
	#cell_environs()
	#new_biom(12, 16)
	#grass(0, 0)
	#_floor_lvl1_create()
	#grassBiom(2, 6)
	#grassBiom(2, 6)
	#stone(256, 256)
	#draw_zone()

func rand(a, b):
	return range(a, b)[randi()%range(a, b).size()]

func say(text):
	if(mytext.size()>0):
		event.clear()
	mytext.append(text)
	for i in mytext.size():
		event.add_text(str(mytext[i], "\n"))
	#event.set_bbcode(str(mytext[page]))

func _on_Timer_timeout():
	if(mytext.size()>1):
		mytext.pop_front()
		event.clear()
		for i in mytext.size():
			event.add_text(str(mytext[i], "\n"))

func fillMAP():
	var k = 0
	var mas = []
	while (k < mapSize):
			mas.append(0)
			x += 32
			k += 1
			if (x >= width):
				x = 0
				y += 32
				MAP.append(mas)
				mas = []
			if (k >= mapSize):
				x = 16
				y = 16
	print(MAP)

#func draw_zone():
	#draw_texture_rect(Area2D, Rect2(300, 300, 32, 32), true)
func earth(x, y):
	# number 1
	draw_rect(Rect2(x, y, 32, 32), Color("5f4732"), true)
func grass(x, y):
	# number 2
	draw_rect(Rect2(x, y, 32, 32), Color("112111"), true)
func stone(x, y):
	# number 3
	draw_rect(Rect2(x, y, 64, 64), Color("333333"), true)
func tree(x, y):
	# number 4
	draw_rect(Rect2(x, y, 64, 64), Color("301a07"), true)
	# number 5
func rockWall(x, y):
	draw_rect(Rect2(x, y, 64, 64), Color("141211"), true)

func createLabel(num, x, y):
	mylabel = Label.new()
	mylabel.rect_position = Vector2(x, y)
	mylabel.set_text(str(num))
	add_child(mylabel)

func _floor_lvl1_create():
	var k = 0
	if (!floorCreate):
		while (k < mapSize):
			earth(x, y)
			#floorMas.append(1)
			x += 64
			k += 1
			if (x >= width):
				x = 0
				y += 64
			if (k >= mapSize):
				floorCreate = true
				x = 0
				y = 0
				#print(floorMas.size())

func generate():
	var this = { x = round(rand(96, 256)), y = round(rand(96, 256))}
	var sc = 0
	var k = 0
	while this.x > 0:
		this.x -= 32
		sc = this.x
		k += 1
	this.x -= sc
	while k >= 0:
		k -= 1
		this.x += 32
	while this.y > 0:
		this.y -= 32
		sc = this.y
		k += 1
	this.y -= sc
	while k >= 0:
		k -= 1
		this.y += 32
	print(this.x, " ", this.y)
	var step = { x = this.x, y = this.y }
	var size = { x = 20, y = 20, _xy = 20*20 }
	var side = "top"
	var wallMas = []
	var mas = []
	var dist = 0
	var turn = "Null"
	var znak = 0
	var flag = false
	var status = "buildWalls"
	var i = 1
	var j = 0
	
	while step.x >= this.x or step.y >= this.y:
		while side == "top":
			if i > 3 and step.x < size.x*32-96:
				dist = round(rand_range(-2, 2))
				if turn == "top":
					dist = round(rand_range(-2, 0))
				elif turn == "bottom":
					dist = round(rand_range(0, 2))
				flag = true
				while j < abs(dist):
					if dist < 0:
						znak = -1
						turn = "bottom"
					else:
						znak = 1
						turn = "top"
					var g = grass.instance()
					g.position = Vector2(step.x, step.y+znak*j*32)
					g.side = "top"
					add_child(g)
					MAP[step.y/32+znak*j].remove(step.x/32)
					MAP[step.y/32+znak*j].insert(step.x/32, 1.1)
					wallMas.append(g)
					j += 1
				step.y += dist*32
				i = 0
				j = 0
			var g = grass.instance()
			g.position = Vector2(step.x, step.y)
			g.side = "top"
			add_child(g)
			MAP[step.y/32].remove(step.x/32)
			MAP[step.y/32].insert(step.x/32, 1.1)
			wallMas.append(g)
			step.x += 32
			i += 1
			if step.x >= size.x*32:
				i = 0
				side = "right"
		while side == "right":
			if i > 3 and step.y< size.y*32-96:
				dist = round(rand_range(-2, 2))
				if turn == "left":
					dist = round(rand_range(-2, 0))
				elif turn == "right":
					dist = round(rand_range(0, 2))
				flag = true
				while j < abs(dist):
					if dist < 0:
						znak = -1
						turn = "right"
					else:
						znak = 1
						turn = "left"
					var g = grass.instance()
					g.position = Vector2(step.x+znak*j*32, step.y)
					g.side = "right"
					add_child(g)
					MAP[step.y/32].remove(step.x/32+znak*j)
					MAP[step.y/32].insert(step.x/32+znak*j, 1)
					wallMas.append(g)
					j += 1
				step.x += dist*32
				i = 0
				j = 0
			var g = grass.instance()
			g.position = Vector2(step.x, step.y)
			g.side = "right"
			add_child(g)
			MAP[step.y/32].remove(step.x/32)
			MAP[step.y/32].insert(step.x/32, 1)
			wallMas.append(g)
			step.y += 32
			i += 1
			if step.y >= size.y*32-96:
				i = 0
				side = "bottom"
		while side == "bottom":
			if i > 3 and step.x > this.x:
				dist = round(rand_range(-2, 2))
				if turn == "top":
					dist = round(rand_range(-2, 0))
				elif turn == "bottom":
					dist = round(rand_range(0, 2))
				flag = true
				while j < abs(dist):
					if dist < 0:
						znak = -1
						turn = "bottom"
					else:
						znak = 1
						turn = "top"
					var g = grass.instance()
					g.position = Vector2(step.x, step.y+znak*j*32)
					g.side = "bottom"
					add_child(g)
					MAP[step.y/32+znak*j].remove(step.x/32)
					MAP[step.y/32+znak*j].insert(step.x/32, 1.3)
					wallMas.append(g)
					j += 1
				step.y += dist*32
				i = 0
				j = 0
			var g = grass.instance()
			g.position = Vector2(step.x, step.y)
			g.side = "bottom"
			add_child(g)
			MAP[step.y/32].remove(step.x/32)
			MAP[step.y/32].insert(step.x/32, 1.3)
			wallMas.append(g)
			step.x -= 32
			i += 1
			if step.x <= this.x-32:
				i = 0
				side = "left"
		while side == "left":
			if i > 3 and step.y > this.y+96:
				dist = round(rand_range(-2, 2))
				if turn == "left":
					dist = round(rand_range(-2, 0))
				elif turn == "right":
					dist = round(rand_range(0, 2))
				flag = true
				while j < abs(dist):
					if dist < 0:
						znak = -1
						turn = "right"
					else:
						znak = 1
						turn = "left"
					var g = grass.instance()
					g.position = Vector2(step.x+znak*j*32, step.y)
					g.side = "left"
					add_child(g)
					MAP[step.y/32].remove(step.x/32+znak*j)
					MAP[step.y/32].insert(step.x/32+znak*j, 1.4)
					wallMas.append(g)
					j += 1
				step.x += dist*32
				i = 0
				j = 0
			var g = grass.instance()
			g.position = Vector2(step.x, step.y)
			g.side = "left"
			add_child(g)
			MAP[step.y/32].remove(step.x/32)
			MAP[step.y/32].insert(step.x/32, 1.4)
			wallMas.append(g)
			step.y -= 32
			i += 1
			if step.y <= this.y:
				i = 0
				side = "Null"
				#status = "filling"
		for i in wallMas.size():
			step.x = wallMas[i].position.x
			step.y = wallMas[i].position.y
			var work = true
			var start = true
			var cords = null
			mas = []
			if wallMas[i].side == "top":
				step.y += 32
				if MAP[step.y/32][step.x/32] == 0:
					while MAP[step.y/32][step.x/32] == 0:
						var g = grass.instance()
						g.position = Vector2(step.x , step.y)
						MAP[step.y/32].remove(step.x/32)
						MAP[step.y/32].insert(step.x/32, 2)
						add_child(g)
						step.y += 32
			if wallMas[i].side == "right":
				step.x -= 32
				if MAP[step.y/32][step.x/32] == 0:
					while MAP[step.y/32][step.x/32] == 0:
						var g = grass.instance()
						g.position = Vector2(step.x , step.y)
						MAP[step.y/32].remove(step.x/32)
						MAP[step.y/32].insert(step.x/32, 2)
						add_child(g)
						step.x -= 32
			if wallMas[i].side == "left":
				step.x += 32
				if MAP[step.y/32][step.x/32] == 0:
					while MAP[step.y/32][step.x/32] == 0:
						var g = grass.instance()
						g.position = Vector2(step.x , step.y)
						MAP[step.y/32].remove(step.x/32)
						MAP[step.y/32].insert(step.x/32, 2)
						add_child(g)
						step.x += 32
		step.x = 10
		step.y = 10


func new_biom(_min, _max):
	var biom = { sizeX = round(rand_range(_min, _max)), sizeY = round(rand_range(_min, _max)), size = 0, width = 0, height = 0, tilesize = 32 }
	biom.size = biom.sizeX*biom.sizeY
	biom.width = biom.sizeX*biom.tilesize
	biom.height = biom.sizeY*biom.tilesize
	if (abs(biom.sizeX - biom.sizeY) >= 2):
		if(biom.sizeX < biom.sizeY):
			while biom.sizeX < biom.sizeY - 2:
				biom.sizeX += 1
		else:
			while biom.sizeY < biom.sizeX- 2:
				biom.sizeY += 1
	var this = { x = rand(0, mapSizeX-biom.sizeX)*32, y = rand(0, mapSizeY-biom.sizeY)*32 }
	var step = { x = this.x, y = this.y }
	var top = { n = 0, mas = [], distY = 0, distX = 0, flag = true }
	var spawn = round(rand_range(0, 1))
	var side = "top"
	var j = 0
	if side == "top":
		while step.x < this.x + biom.width:
			if top.flag:
				top.flag = false
				top.distX = round(rand_range(0, 2))
				top.distY = round(rand_range(0, 2))
				step.x += top.distX
				step.y += top.distY
				grass(step.x, step.y)
				top.n += 1
				top.mas.append(["grass", step.x, step.y, side])
				createLabel(top.n, step.x+11, step.y+10)
				step.y -= top.distY
			else:
				top.distX = round(rand_range(2, 5))*biom.tilesize
				top.distY = round(rand_range(-2, 2))*biom.tilesize
				step.x += top.distX
				step.y += top.distY
				if step.y < 32:
					step.y = 32
				grass(step.x, step.y)
				top.n += 1
				top.mas.append(["grass", step.x, step.y, side])
				createLabel(top.n, step.x+11, step.y+10)
				step.y -= top.distY
		side = "right"
		top.flag = true
	if side == "right":
		while step.y < this.y + biom.height:
			if top.flag:
				top.flag = false
				top.distX = round(rand_range(1, 2))*biom.tilesize
				top.distY = round(rand_range(0, 1))*biom.tilesize
				step.x += top.distX
				step.y += top.distY
				grass(step.x, step.y)
				top.n += 1
				top.mas.append(["grass", step.x, step.y, side])
				createLabel(top.n, step.x+11, step.y+10)
				step.x -= top.distX
			else:
				top.distX = round(rand_range(-2, 2))*biom.tilesize
				top.distY = round(rand_range(2, 5))*biom.tilesize
				step.x += top.distX
				step.y += top.distY
				grass(step.x, step.y)
				top.n += 1
				top.mas.append(["grass", step.x, step.y, side])
				createLabel(top.n, step.x+11, step.y+10)
				step.x -= top.distX
				step.y += top.distY
		side = "bottom"
		top.flag = true
	if side == "bottom":
		while step.x > this.x+96:
			if top.flag:
				top.flag = false
				top.distX = round(rand_range(1, 2))
				top.distY = round(rand_range(1, 2))
				step.x -= top.distX
				step.y += top.distY
				grass(step.x, step.y)
				top.n += 1
				top.mas.append(["grass", step.x, step.y, side])
				createLabel(top.n, step.x+11, step.y+10)
				step.y -= top.distY
			else:
				top.distX = round(rand_range(2, 5))*biom.tilesize
				top.distY = round(rand_range(-2, 2))*biom.tilesize
				step.x -= top.distX
				step.y += top.distY
				if step.y > height-32:
					step.y = height-32
				grass(step.x, step.y)
				top.n += 1
				top.mas.append(["grass", step.x, step.y, side])
				createLabel(top.n, step.x+11, step.y+10)
				step.y -= top.distY
		side = "left"
		top.flag = true
	if side == "left":
		while step.y > this.y + 32:
			if top.flag:
				top.flag = false
				top.distX = round(rand_range(1, 2))*biom.tilesize
				top.distY = round(rand_range(1, 2))*biom.tilesize
				step.x += top.distX
				step.y -= top.distY
				if step.y > height-32:
					step.y = height-32
				grass(step.x, step.y)
				top.n += 1
				top.mas.append(["grass", step.x, step.y, side])
				createLabel(top.n, step.x+11, step.y+10)
				step.x -= top.distX
			else:
				top.distX = round(rand_range(-2, 2))*biom.tilesize
				top.distY = round(rand_range(2, 4))*biom.tilesize
				step.x += top.distX
				step.y -= top.distY
				if step.y > height-32:
					step.y = height-32
				if step.y < top.mas[0][2]+128:
					step.y = top.mas[0][2]+32
					step.x = top.mas[0][1]
				grass(step.x, step.y)
				top.n += 1
				top.mas.append(["grass", step.x, step.y, side])
				createLabel(top.n, step.x+11, step.y+10)
				step.x -= top.distX
				step.y -= top.distY
		side = "top"
		top.flag = true
	for i in top.mas.size()-1:
		step.x = top.mas[0][1]+32
		step.y = top.mas[i][2]
		if top.mas[i][3] == "top":
			if top.mas[i][2] == top.mas[i+1][2]:
				step.x = top.mas[i][1]+32
				while step.x < top.mas[i+1][1]:
					grass(step.x, step.y)
					step.x += 32
			elif top.mas[i][2] < top.mas[i+1][2]:
				step.x = top.mas[i][1]
				while step.y < top.mas[i+1][2]:
					step.y += 32
					grass(step.x, step.y)
				while step.x < top.mas[i+1][1]:
					grass(step.x, step.y)
					step.x += 32
				grass(step.x, step.y)
			elif top.mas[i][2] > top.mas[i+1][2]:
				step.x = top.mas[i][1]
				while step.y > top.mas[i+1][2]:
					step.y -= 32
					grass(step.x, step.y)
				while step.x < top.mas[i+1][1]:
					grass(step.x, step.y)
					step.x += 32
				grass(step.x, step.y)
		side = "right"
		if top.mas[i][3] == "right":
			step.x = top.mas[i][1]
			step.y = top.mas[i][2]+32
			if top.mas[i][1] == top.mas[i+1][1]:
				while step.y < top.mas[i+1][2]:
					grass(step.x, step.y)
					step.y += 32
			elif top.mas[i][1] > top.mas[i+1][1]:
				while step.y < top.mas[i+1][2]:
					grass(step.x, step.y)
					step.y += 32
				grass(step.x, step.y)
				while step.x > top.mas[i+1][1]:
					step.x -= 32
					grass(step.x, step.y)
			elif top.mas[i][1] < top.mas[i+1][1]:
				while step.y < top.mas[i+1][2]:
					grass(step.x, step.y)
					step.y += 32
				grass(step.x, step.y)
				while step.x < top.mas[i+1][1]:
					step.x += 32
					grass(step.x, step.y)
		side = "bottom"
		step.x = top.mas[i][1]-32
		step.y = top.mas[i][2]
		if top.mas[i][3] == "bottom":
			if top.mas[i][2] == top.mas[i+1][2]:
				step.x = top.mas[i][1]+32
				while step.x > top.mas[i+1][1]:
					grass(step.x, step.y)
					step.x -= 32
			elif top.mas[i][2] < top.mas[i+1][2]:
				step.x = top.mas[i][1]
				while step.y < top.mas[i+1][2]:
					step.y += 32
					grass(step.x, step.y)
				while step.x > top.mas[i+1][1]:
					grass(step.x, step.y)
					step.x -= 32
				grass(step.x, step.y)
			elif top.mas[i][2] > top.mas[i+1][2]:
				step.x = top.mas[i][1]
				while step.y > top.mas[i+1][2]:
					step.y -= 32
					grass(step.x, step.y)
				while step.x > top.mas[i+1][1]:
					grass(step.x, step.y)
					step.x -= 32
				grass(step.x, step.y)
		side = "left"
		step.x = top.mas[i][1]
		step.y = top.mas[i][2]-32
		if top.mas[i][3] == "left":
			step.x = top.mas[i][1]
			step.y = top.mas[i][2]-32
			if top.mas[i][1] == top.mas[i+1][1]:
				while step.y > top.mas[i+1][2]:
					grass(step.x, step.y)
					step.y -= 32
			elif top.mas[i][1] > top.mas[i+1][1]:
				while step.y > top.mas[i+1][2]:
					grass(step.x, step.y)
					step.y -= 32
				grass(step.x, step.y)
				while step.x > top.mas[i+1][1]:
					step.x -= 32
					grass(step.x, step.y)
			elif top.mas[i][1] < top.mas[i+1][1]:
				while step.y > top.mas[i+1][2]:
					grass(step.x, step.y)
					step.y -= 32
				grass(step.x, step.y)
				while step.x < top.mas[i+1][1]:
					step.x += 32
					grass(step.x, step.y)
		side = "top"
		step.x = top.mas[i][1]
		step.y = top.mas[i][2]

func cell_environs():
	var c = 0
	var env = { sizeX = 10, sizeY = 10, size = 10*10, width = 10*32, height = 10*32 }
	env.size = env.sizeX*env.sizeY
	var side = 0
	var this = { x = rand(0, mapSizeX-env.sizeX)*32, y = rand(0, mapSizeY-env.sizeY)*32 }
	var step = { x = this.x, y = this.y }
	var top = { n = 0, mas = [], distY = 0, distX = 0 }
	var spawn = round(rand_range(0, 1))
	var j = 0
	if side == 0:
		side = 1
		while j < env.sizeX and step.x < this.x + env.width and step.x < width-96:
			if top.n == 0:
				top.distX = round(rand_range(0, 2))
				top.distY = round(rand_range(0, 2))
				step.x += top.distX*32
				step.y += top.distY*32
				grass(step.x, step.y)
				top.n += 1
				top.mas.append(["grass", step.x, step.y])
				createLabel(top.n, step.x+11, step.y+10)
			else:
				top.distX = round(rand_range(2, 4))
				top.distY = round(rand_range(-2, 2))
				step.x += top.distX*32
				step.y += top.distY*32
				if step.y > env.height or step.y <= 0:
					step.y -= top.distY
				grass(step.x, step.y)
				top.n += 1
				top.mas.append(["grass", step.x, step.y])
				createLabel(top.n, step.x+11, step.y+10)
			j += 1
	
	if side == 1:
		side = 2
		while j < env.sizeY and step.y < this.y + env.height and step.y < height-96:
			top.distX = round(rand_range(-2, 2))
			top.distY = round(rand_range(2, 4))
			step.x += top.distX*32
			step.y += top.distY*32
			if step.y > env.height:
				step.y -= top.distY
			grass(step.x, step.y)
			top.n += 1
			top.mas.append(["grass", step.x, step.y])
			createLabel(top.n, step.x+11, step.y+10)
			j += 1
	j = 0
	
	if side == 2:
		side = 3
		while j < env.sizeX and step.x > this.x and step.x > this.x:
			top.distX = round(rand_range(2, 4))
			top.distY = round(rand_range(-2, 2))
			step.x -= top.distX*32
			step.y -= top.distY*32
			if step.x < this.x:
				step.x -= top.distX
			if step.y+32 > height:
				step.y += top.distY
			grass(step.x, step.y)
			top.n += 1
			top.mas.append(["grass", step.x, step.y])
			createLabel(top.n, step.x+11, step.y+10)
			j += 1
	j = 0
	if side == 3:
		side = 0

		while j < env.sizeY and step.y > top.mas[0][2]+96 and step.y > 96:
			top.distX = round(rand_range(-2, 2))
			top.distY = round(rand_range(2, 4))
			step.x -= top.distX*32
			step.y -= top.distY*32
			if step.y > env.height:
				step.y += top.distY
			grass(step.x, step.y)
			top.n += 1
			top.mas.append(["grass", step.x, step.y])
			createLabel(top.n, step.x+11, step.y+10)
			j += 1
	j = 0
	step.x = top.mas[0][1]+32
	step.y = top.mas[0][2]
	for i in top.mas.size()-1:
		if top.mas[i][1] < top.mas[i+1][1] and top.mas[i][2] == top.mas[i+1][2]:
			while step.x < top.mas[i+1][1]:
				grass(step.x, step.y)
				step.x += 32
		if top.mas[i][1] < top.mas[i+1][1] and top.mas[i][2] > top.mas[i+1][2]:
			while step.x < top.mas[i+1][1]:
				grass(step.x, step.y)
				step.x += 32
			while step.y > top.mas[i+1][2]:
				grass(step.x, step.y)
				step.y -= 32
		if top.mas[i][1] < top.mas[i+1][1] and top.mas[i][2] < top.mas[i+1][2]:
			while step.x < top.mas[i+1][1]:
				grass(step.x, step.y)
				step.x += 32
			while step.y < top.mas[i+1][2]:
				grass(step.x, step.y)
				step.y += 32

func get_linetype():
	if linetype == 0:
		linetype = 1
		return linetype
	else:
		linetype = 0
		return linetype

func grassBiom(minT, maxT):
	var biomTiles = { a = rand_range(minT, maxT), b = rand_range(minT, maxT) }
	if (abs(biomTiles.a - biomTiles.b) >= 2):
		if(biomTiles.a>biomTiles.b):
			while biomTiles.a < biomTiles.b - 2:
				biomTiles.a += 1
		else:
			while biomTiles.b < biomTiles.a - 2:
				biomTiles.b += 1
	var biomTileSize = {width = 64, height = 64}
	var biomWidth = biomTiles.a*biomTileSize.width 
	var bionHeight = biomTiles.b*biomTileSize.height
	var biomSize = biomTiles.a*biomTiles.b
	var biomFloorCreated = false
	var biomTreesCreated = false
	var this = { x = rand(0, mapSizeX-biomTiles.a)*64, y = rand(0, mapSizeY-biomTiles.b)*64 }
	var step = { x = this.x, y = this.y }
	var grassMas = []
	var treeMas = []
	var mpos = { n = 0, x = this.x/biomTileSize.width, y = this.y/biomTileSize.height } # MAP position
	if(!biomFloorCreated):
		var k = 0
		while(k < biomSize):
			grass(step.x, step.y)
			mpos.n = mapSizeY*mpos.y + mpos.x
			MAP[mpos.y].remove(mpos.x)
			MAP[mpos.y].insert(mpos.x, 2)
			step.x += 64
			mpos.x += 1 # next MAP step
			k += 1
			if (step.x >= this.x+biomWidth):
				step.x = this.x
				mpos.x = this.x/biomTileSize.width 
				step.y += 64
				mpos.y += 1 # next MAP lvl
			if (k >= biomSize):
				biomFloorCreated = true
				this.x = 0
				this.y = 0
	if(biomFloorCreated):
		var i = 0
		var j = 0
		var mas = []
		while i < MAP.size():
			while j < MAP[i].size():
				if MAP[i][j] == 2:
					mas.append(2)
					if(MAP[i][j-1] == 2 and MAP[i][j+1] == 2 and MAP[i-1][j] == 2 and MAP[i+1][j] == 2):
						if(MAP[i][j-1] != 4 and MAP[i][j+1] != 4 and MAP[i-1][j] != 4 and MAP[i+1][j] != 4):
							MAP[i].remove(j)
							MAP[i].insert(j, 4)
							mas.pop_back()
							mas.append(4)
							tree(j*biomTileSize.width, i*biomTileSize.height)
				j += 1
			if(mas.has(2)):
				grassMas.append(mas)
			mas = []
			j = 0
			i += 1
		biomTreesCreated = true
		#print(grassMas)
		#print(MAP)
	
	
	
	
	