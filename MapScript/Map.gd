extends MeshInstance

var matrix = []
var Case = load("res://MapScript/Case.gd")
var CabaneClass = load("res://MapScript/Batiment/Cabane.gd")
var ScierieClass = load("res://MapScript/Batiment/Scierie.gd")
var UsineCharbonClass = load("res://MapScript/Batiment/UsineCharbon.gd")
var ready = false


# var pour la production de ressource pour le tour donnée
var retour
var nourriture = 0 
var charbon = 0
var bois = 0 

var noeudSpatial


var x

func genererGrid(n):
	for x in range(n):
		matrix.append([])
		matrix[x]=[]
		for y in range(n):
			matrix[x].append([])
			matrix[x][y]=Case.new()


func printEnsembleBatiment():
	for x in range(matrix.size()):
		for y in range(matrix.size()):
			if (matrix[x][y].getConstructible()==false):
				print(" CASE [",x, "]","[", y, "]: ", matrix[x][y].getBatiment())


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
#	
func jouer(xParam, memoireBatimentParam):
	print("----------------------------------- Lancement de la partie ------------------------------")
	noeudSpatial = xParam
	print("VALEUR DE test :", noeudSpatial)
	testBatiment()
	var ressourcesTour = jouerTour()
	printEnsembleBatiment()
	#printAllRessourcesFromTour()
	return ressourcesTour
	#removeBatiment(0,0)
	
#	
func jouerTour():
	for x in range(matrix.size()):
		for y in range(matrix.size()):
			if(matrix[x][y].getConstructible()==false):
					retour=matrix[x][y].jouer()
					checkTypeProduction()
	var tableau = [bois, charbon, nourriture ]
	return tableau


func testBatiment():
	var Cabane = CabaneClass.new()
	matrix[0][0].setBatiment(Cabane)
	matrix[0][1].setBatiment(UsineCharbonClass.new())
	matrix[0][2].setBatiment(ScierieClass.new())
	
func removeBatiment(x,y):
	matrix[x][y].removeBatiment()
	print("Batiment détruit")

func printAllRessourcesFromTour():
	print("------------------  AFFICHAGE DES RESSOURCES POUR LE TOUR: ------------------------- ")
	print("Nourriture: ",nourriture)
	print("Charbon: ",charbon)
	print("Bois: ",bois)


func checkTypeProduction():
	if(retour.get_class()=="Nourriture"):
		nourriture=retour.getQuantite()
	if(retour.get_class()=="Charbon"):
		charbon=retour.getQuantite()
	if(retour.get_class()=="Bois"):
		bois=retour.getQuantite()
	retour=0


func ajoutBatimentMemoire(batimentType):
	print("Ajout du batiment ", batimentType)
	for x in range(matrix.size()):
		for y in range(matrix.size()):
			if(matrix[x][y].getConstructible()==true):
				#print(matrix[x][y])
				#print(Cabane)
				matrix[x][y].setBatiment(Cabane)
				print("Batiment :", matrix[x][y].getBatiment())
				matrix[x][y].getBatiment().setCoordonnes(x,y)
				return
	pass 


	
func updateGrid():
	pass
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var ray_origin = get_viewport().get_camera().project_ray_origin(event.position)
		var ray_direct = get_viewport().get_camera().project_ray_normal(event.position)
		var from = ray_origin
		var to = ray_origin + ray_direct * 1000
		var dropPlane  = Plane(Vector3(0, 0, 1000), 0)
		var result = dropPlane.intersects_ray(from,to)
		print("POSITION 3D", result)
		#var hit = space_state.intersect_ray(from,to)
		creerBatiment(result.x,(-result.y))
		#print("Batiment placé")
	pass
	

func creerBatiment(xCoor,zCoor):
	
	var memoireTest = load("res://Models/Terrain/Arbre.dae").instance()
	memoireTest.transform.origin =Vector3(xCoor,0,zCoor)
	var NodeTest=self.get_parent_spatial()
	print("VALEUR DANS CREATION BATIMENT", NodeTest)
	NodeTest.add_child(memoireTest)
	#var batiment_mesh=memoireBatiment.get_bake_mesh_instance(0)
	#NodeTest.add_child(batiment_mesh)
pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
