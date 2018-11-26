extends Area2D

var root_Node = null

var mapNode = null

var width = 960
var height = 640
var mapSizeX = width/64
var mapSizeY = height/64
var mapSize = mapSizeX*mapSizeY
var x = 0
var y = 0

var size = { width = 0, height = 0 }

var zLevel = null

var checkMap = false

func _ready():
	mapNode = get_tree().get_root().get_node("/root/Node/graphics")
	randomize(true)
	#global_position = Vector2(0, 0)
	chekSize()
	checkPosition()
	checkMap = true
	#x = mapNode.global_position.x
	#y = mapNode.global_position.y

func _draw():
	#_createForestZone()
	if(checkMap):
		#var stepX = global_position.x - size.width/2
		#var stepY = global_position.y - size.height/2
		#print(stepX, " ", stepY)
		#print(x-stepX-32, " ", y-stepY-32)
		var areaSizeX = size.width/64
		var areaSizeY = size.height/64
		var areaSize = areaSizeX*areaSizeY
		var k = 0
		var j = 0
		print(global_position)
		print(size.width/64, " ", size.height/64)
		print(areaSizeX, " ", areaSizeY, " ", areaSize)
		while k < areaSize:
			k+=1
			if k < areaSizeX:
				grass(x-32, y-32)
				x+=16



#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func grass(x, y):
	# number 2
	draw_rect(Rect2(x, y, 64/scale.x, 64/scale.y), Color("112111"), true)
func earth(x, y):
	# number 1
	draw_rect(Rect2(x, y, 64, 64), Color("5f4732"), true)
func stone(x, y):
	# number 3
	draw_rect(Rect2(x, y, 64, 64), Color("333333"), true)
func tree(x, y):
	# number 4
	draw_rect(Rect2(x, y, 64, 64), Color("301a07"), true)
	# number 5
func rockWall(x, y):
	draw_rect(Rect2(x, y, 64, 64), Color("141211"), true)


func chekSize():
	size = { width = scale.x*64, height= scale.y*64 }
	var i = 0
	var sCal = { x = 0, y = 0 }
	while scale.x > 1:
		i += 1
		scale.x -= 1
		sCal.x = scale.x
	if(sCal.x >= 0.5):
		scale.x = i+1
	else:
		scale.x = i
	i = 0
	size.width = scale.x*64
	
	while scale.y > 1:
		i += 1
		scale.y -= 1
		sCal.y = scale.y
	if(sCal.y >= 0.5):
		scale.y = i+1
	else:
		scale.y = i
	i = 0
	size.height = scale.y*64

func checkPosition():
	#print(global_position)
	var i = 0
	var step = 0
	while global_position.x > 0:
		global_position.x -= 64
		step = global_position.x
		#print(step)
		i += 1
	if(step >= -32):
		global_position.x = i*64
	else:
		global_position.x = (i-1)*64
	i = 0
	step = 0
	while global_position.y > 0:
		global_position.y -= 64
		step = global_position.y
		i += 1
	if(step >= -32):
		global_position.y = i*64
	else:
		global_position.y = (i-1)*64
	i = 0
	step = 0
	
func _createForestZone():
	grass(0, 0)

