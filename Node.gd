
extends Node

var root_Node = null

var myplayer = null
var playerCreate = false

var width = 960
var height = 640
var mapSizeX = width/32
var mapSizeY = height/32
var mapSize = mapSizeX*mapSizeY
var x = 16
var y = 16

var zLevel = null

var MAP = []
var objMAP = []
var phisicsBodyMap = []	

var floorMas = []

var floorCreate = false
var wallCreate = false

var open_space = preload("res://tiles/open_space.tscn")#0
var earth = preload("res://tiles/earthFloor.tscn")#1
var grass = preload("res://tiles/grassFloor.tscn")#2
var water = preload("res://tiles/waterFloor.tscn")#3
var tree = preload("res://objects/structures/tree.tscn")#4
var rock = preload("res://objects/structures/rock.tscn")#5
var bush = preload("res://objects/structures/bush.tscn")#6
var stone = preload("res://objects/items/stone.tscn")#7

var eventText = null
var event = null
var mytext = []
var page = 0
var wipe = false

func _ready():
	root_Node = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	randomize(true)
	#fillMap()
	#forestBiom(12, 20)
	#forestBiom(6, 12)
	#createRiver()
	_player_create()


func rand(a, b):
	return range(a, b)[randi()%range(a, b).size()]

func _player_create():
	if (!playerCreate):
		var player = preload("res://mobs/player.tscn").instance()
		root_Node.add_child(player)
		player.position = Vector2(x+450, 250)
		myplayer = player
		playerCreate = true

func fillMap():
	for i in mapSize:
		var o = open_space.instance()
		o.position = Vector2(x, y)
		#add_child(o)
		o.add_to_group("open_space")
		objMAP.append(o)
		MAP.append(0)
		
		var e = earth.instance()
		e.position = Vector2(x, y)
		root_Node.add_child(e)
		x += 32
		if x > mapSizeX*32:
			x = 16
			y += 32
		if i+1 == mapSize:
			x = 16
			y = 16


func forestBiom(minT, maxT):
	var biom = { tiles = { amountX = round(rand_range(minT, maxT)), amountY = round(rand_range(minT, maxT)), width = 32, height = 32 } }
	if (abs(biom.tiles.amountX - biom.tiles.amountY) >= 2):
		if(biom.tiles.amountX < biom.tiles.amountY):
			while biom.tiles.amountX < biom.tiles.amountY - 2:
				biom.tiles.amountX += 1
		else:
			while biom.tiles.amountY < biom.tiles.amountX - 2:
				biom.tiles.amountY += 1
	var biomSize = { size = biom.tiles.amountX*biom.tiles.amountY, x = biom.tiles.amountX*32, y = biom.tiles.amountY*32 }
	var biomDone = { grass = false, tree = false, glade = false, bush = false, stone = false}
	var biomMas = []
	
	var glade = { tiles = { amountX = round(rand_range(2, 6)), amountY = round(rand_range(2, 6)), width = 32, height = 32 } }
	if (abs(glade.tiles.amountX - glade.tiles.amountY) >= 2):
		if(glade.tiles.amountX < glade.tiles.amountY):
			while glade.tiles.amountX < glade.tiles.amountY - 2:
				glade.tiles.amountX += 1
		else:
			while glade.tiles.amountY < glade.tiles.amountX - 2:
				glade.tiles.amountY += 1
	var gladeSize = { size = glade.tiles.amountX*glade.tiles.amountY, x = glade.tiles.amountX*32, y = glade.tiles.amountY*32 }

	var mas = []
	var spawn = null
	var this = { x = rand(0, mapSizeX-biom.tiles.amountX)*32 + x, y = rand(0, mapSizeY-biom.tiles.amountY)*32 + y }
	var step = { x = this.x, y = this.y }
	var mpos = { n = 0, x = this.x/biom.tiles.width, y = this.y/biom.tiles.height } # MAP position
	#say(str("Biom size: ", biom.tiles.amountX, "x", biom.tiles.amountY))
	for i in biomSize.size:
		var g = grass.instance()
		g.position = Vector2(step.x, step.y)
		root_Node.add_child(g)
		objMAP.remove(step.x/32 + (step.y/32)*mapSizeY)
		objMAP.insert(step.x/32 + (step.y/32)*mapSizeY, g)
		MAP.remove(step.x/32 + (step.y/32)*mapSizeY)
		MAP.insert(step.x/32 + (step.y/32)*mapSizeY, 2)
		step.x += 32
		if(step.x >= this.x + biomSize.x):
			step.x = this.x
			step.y += 32
		if(i+1 == biomSize.size):
			step.x = this.x
			step.y = this.y
			biomDone.grass = true
			#say(str("Create grass: ", biomDone.grass))
	if(biomDone.grass):
		for i in biomSize.size:
			spawn = round(rand_range(1, 16))
			if(spawn > 8):
				#objMAP[step.x/32 + (step.y/32)*mapSizeY].killStone = true
				#say(objMAP[step.x/32 + (step.y/32)*mapSizeY].checkChild("tree"))
				var s = stone.instance()
				s.position = Vector2(step.x, step.y)
				root_Node.add_child(s)
			step.x += 32
			if step.x >= this.x + biomSize.x:
				step.x = this.x
				step.y += 32
			if(i+1 == biomSize.size):
				step.x = this.x
				step.y = this.y
				biomDone.stone = true
				#say(str("Create stones: ", biomDone.stone))
	if(biomDone.stone):
		for i in biomSize.size:
			spawn = round(rand_range(1, 16))
			if(spawn > 12):
				var b = bush.instance()
				b.position = Vector2(step.x, step.y)
				#objMAP[step.x/32 + (step.y/32)*mapSizeY].killStone = true
				#objMAP[step.x/32 + (step.y/32)*mapSizeY].visible = false
				#objMAP[step.x/32 + (step.y/32)*mapSizeY].visible = false
				b.killStone = true
				root_Node.add_child(b)
			step.x += 32
			if step.x >= this.x + biomSize.x:
				step.x = this.x
				step.y += 32
			if(i+1 == biomSize.size):
				step.x = this.x
				step.y = this.y
				biomDone.bush = true
				#say(str("Create bushes: ", biomDone.bush))
	if(biomDone.bush):
		#say(str("Glade size: ", glade.tiles.amountX, "x", glade.tiles.amountY))
		var thisG = { x = rand((this.x/32), this.x/32 + (biom.tiles.amountX-glade.tiles.amountX))*32 + x, y = rand((this.y/32), this.y/32 + (biom.tiles.amountY-glade.tiles.amountY))*32 + y }
		step.x = thisG.x
		step.y = thisG.y
		for i in gladeSize.size:
			var g = grass.instance()
			g.position = Vector2(step.x, step.y)
			root_Node.remove_child(objMAP[step.x/32 + (step.y/32)*mapSizeY])
			objMAP.remove(step.x/32 + (step.y/32)*mapSizeY)
			objMAP.insert(step.x/32 + (step.y/32)*mapSizeY, g)
			MAP.remove(step.x/32 + (step.y/32)*mapSizeY)
			MAP.insert(step.x/32 + (step.y/32)*mapSizeY, 2)
			root_Node.add_child(g)
			g.killTree = true
			step.x += 32
			if step.x >= thisG.x + gladeSize.x:
				step.x = thisG.x
				step.y += 32
			if i+1 >= gladeSize.size:
				step.x = this.x
				step.y = this.y
				biomDone.glade = true
				#say(str("Create glade: ", biomDone.glade))
		if(biomDone.glade):
			for i in biomSize.size/4:
				spawn = round(rand_range(1, 8))
				if(spawn > 1):
					var t = tree.instance()
					t.position = Vector2(step.x, step.y)
					objMAP[step.x/32 + (step.y/32)*mapSizeY].killStone = true
					root_Node.add_child(t)
				step.x += 64
				if step.x >= this.x + biomSize.x:
					step.x = this.x
					step.y += 64
				if(i+1 == biomSize.size/4):
					step.x = this.x
					step.y = this.y
					biomDone.tree = true
					#say(str("Create trees: ", biomDone.tree))
	#say("Forest biom generation: true")

func createRiver():
	var riverSize = mapSizeY*3
	var this = { x = rand(0, mapSizeX-2)*32, y = 0}
	var step = {x = this.x+16, y = this.y+16, way = 0, oldX = []}
	var stage = 0
	for i in riverSize:
		step.way = round(rand_range(-1, 1))*32
		var w = water.instance()
		w.position = Vector2(step.x, step.y)
		root_Node.add_child(w)
		if stage == 0:
			step.x = step.x + step.way
			step.oldX.append(step.x)
			step.y += 32
		else:
			step.x = stage*32 + step.oldX[step.y/32]
			step.y += 32
		if step.y >= mapSizeY*32:
			stage += 1
			step.y = this.y+16
			step.x = this.x+stage*32+16