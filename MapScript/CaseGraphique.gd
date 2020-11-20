extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mapGraphique;
var spatial
var caseLogique setget setCaseLogique, getCaseLogique

var caseTopLeftX
var caseTopLeftZ
var caseBottomRightX
var caseBottomRightZ
var centerX
var centerZ
var caseTop

var casesVoisines = []
var caseVoisinHaut
var caseVoisinBas
var caseVoisinDroite
var caseVoisinGauche
var spacingZ
var spacingX
var booleanRoute=false
var constructible=true setget setConstructible, isConstructible



#le coutG (le cout pour aller du point de départ au nœud considéré) ;
#le coutH (le cout pour aller du nœud considéré au point de destination) ;
#le coutF (somme des précédents, mais mémorisé pour ne pas le recalculer à chaque fois) ;
#PATHFINDING VARS
var cout_g=0
var cout_h=0
var cout_f 
var pointeurNoeudParent


var typeRouteModel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setMap(mapParam):
	mapGraphique=mapParam

func getMap():
	return mapGraphique

func setCaseLogique(caseLogiqueParam):
	caseLogique=caseLogiqueParam
	pass

func getCaseLogique():
	return caseLogique

func getRandomPos():
	var tabPosRng = []
	var randomX = rand_range(caseTopLeftX, caseTopLeftX+spacingX)
	var randomZ = rand_range(caseTopLeftZ, caseTopLeftZ+spacingZ)
	tabPosRng.insert(0, randomX)
	tabPosRng.insert(1, randomZ)
	return tabPosRng


func setCaseTopLeft(x,z,spacingXParam,spacingZParam, node):
	spatial=node
	spacingX = spacingXParam
	spacingZ = spacingZParam
	caseTopLeftX=x
	caseTopLeftZ=z
	caseBottomRightX=caseTopLeftX+spacingXParam
	caseBottomRightZ=caseTopLeftZ+spacingZParam
	centerX = (caseTopLeftX + caseBottomRightX) / 2
	centerZ = (caseTopLeftZ + caseBottomRightZ) /2
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func trouverVoisinCase(var mapParam,spacingXParam,spacingZParam):
	caseVoisinDroite = mapParam.getClosestCaseMap(centerX+spacingXParam,centerZ)
	casesVoisines.insert(0,caseVoisinDroite)
	caseVoisinGauche = mapParam.getClosestCaseMap(centerX-spacingXParam,centerZ)
	casesVoisines.insert(1,caseVoisinGauche)
	caseVoisinHaut = mapParam.getClosestCaseMap(centerX,centerZ-spacingZParam)
	casesVoisines.insert(2,caseVoisinHaut)
	caseVoisinBas = mapParam.getClosestCaseMap(centerX,centerZ+spacingZParam)
	casesVoisines.insert(3,caseVoisinBas)
	pass

func ajouterBatiment(typeBatiment,angle):
	if(booleanRoute==true):
		print("Route déjà sur ce terrain : Croisement à update")
		changementModel()
	if typeBatiment == "Route" and booleanRoute==false:
		booleanRoute=true
		typeRouteModel = load("res://Models/Route.dae").instance()
		typeRouteModel.transform.origin =Vector3(centerX,1,centerZ)
		if(angle!=0):
			typeRouteModel.rotate_y(deg2rad(angle))
		print(spatial)
		spatial.add_child(typeRouteModel)
	refreshRouteAutour()
	changementModel()
pass 


func generateModel():
	var maCaseModel
	var rng = randi() % 100
	if(rng<10):
		maCaseModel = load("res://Models/TerrainV2/CaseGraphHerbe2.dae").instance()
	else:
		maCaseModel = load("res://Models/TerrainV2/CaseGraphHerbe.dae").instance()
	maCaseModel.transform.origin = Vector3(centerX,1,centerZ)
	spatial.add_child(maCaseModel)
pass

func changementModel():
	if(booleanRoute):
		if(caseVoisinGauche.booleanRoute==true and caseVoisinHaut.booleanRoute==true and caseVoisinDroite.booleanRoute==false and caseVoisinBas.booleanRoute==false):
			switchModelFromSpatial("res://Models/RouteGaucheVersHaut.dae")
		elif(caseVoisinGauche.booleanRoute and caseVoisinHaut.booleanRoute and caseVoisinDroite.booleanRoute and caseVoisinBas.booleanRoute==false):
			switchModelFromSpatial("res://Models/RouteHautDouble.dae")
		elif(caseVoisinGauche.booleanRoute==true and caseVoisinHaut.booleanRoute==true and caseVoisinDroite.booleanRoute==true and caseVoisinBas.booleanRoute==true):
			switchModelFromSpatial("res://Models/RouteCroix.dae")
		elif(caseVoisinGauche.booleanRoute and caseVoisinHaut.booleanRoute==false and caseVoisinDroite.booleanRoute and caseVoisinBas.booleanRoute):
			switchModelFromSpatial("res://Models/RouteBasDouble.dae")
		elif(caseVoisinGauche.booleanRoute==false and caseVoisinHaut.booleanRoute==false and caseVoisinDroite.booleanRoute==true and caseVoisinBas.booleanRoute==true):
			switchModelFromSpatial("res://Models/RouteDroiteBas.dae")
		elif(caseVoisinGauche.booleanRoute==true and caseVoisinHaut.booleanRoute==true and caseVoisinDroite.booleanRoute==false and caseVoisinBas.booleanRoute==false):
			switchModelFromSpatial("res://Models/RouteGaucheVersHaut.dae")
		elif(caseVoisinGauche.booleanRoute==true and caseVoisinHaut.booleanRoute==false and caseVoisinDroite.booleanRoute==false and caseVoisinBas.booleanRoute==true):
			switchModelFromSpatial("res://Models/RouteGaucheVersBas.dae")
		elif(caseVoisinGauche.booleanRoute==false and caseVoisinHaut.booleanRoute==true and caseVoisinDroite.booleanRoute==true and caseVoisinBas.booleanRoute==true):
			switchModelFromSpatial("res://Models/RouteDroiteVersHautBas.dae")
		elif(caseVoisinGauche.booleanRoute==true and caseVoisinHaut.booleanRoute==true and caseVoisinDroite.booleanRoute==false and caseVoisinBas.booleanRoute==true):
			switchModelFromSpatial("res://Models/RouteGaucheVersHautBas.dae")	
		elif(caseVoisinGauche.booleanRoute==false and caseVoisinHaut.booleanRoute==true and caseVoisinDroite.booleanRoute==true and caseVoisinBas.booleanRoute==false):
			switchModelFromSpatial("res://Models/RouteDroiteVersHaut.dae")	

	pass


func switchModelFromSpatial(chemin):
	spatial.remove_child(typeRouteModel)
	typeRouteModel= load(chemin).instance()
	typeRouteModel.transform.origin =Vector3(centerX,1,centerZ)
	spatial.add_child(typeRouteModel)
	pass

func refreshRouteAutour():
	if(caseVoisinDroite):
		caseVoisinDroite.changementModel()
	if(caseVoisinGauche):
		caseVoisinGauche.changementModel()
	if(caseVoisinBas):
		caseVoisinBas.changementModel()
	if(caseVoisinHaut):
		caseVoisinHaut.changementModel()
	pass

func isConstructible():
	return constructible
	
func setConstructible(boolean):
	constructible = boolean
