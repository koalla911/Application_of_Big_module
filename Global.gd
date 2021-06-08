extends Node

signal update_purchase_ui

var current_item_animation = []

var player_item_animation = {
		"PeasantWood": ["Wood"], 
		"PeasantGrain": ["Grain"], 
		"PeasantCopper": ["Copper"],
	}

var buildings

var building_on

var build_number


var level

var background_white
var level3
var level2
var level1
var background_black

var world_map_texture = preload("res://RunnerTextures/Pixel/RegionUI/map icon.png")

var on_world_map
var on_main_scene

var SourceIcons = {
	"res://RunnerTextures/WorldMap/ForestIcon.png": ["Sawmill"],
	"res://RunnerTextures/WorldMap/FieldIcon.png": ["Mill"],
	"res://RunnerTextures/WorldMap/RiverIcon.png": ["Watermill"],
}

var forest = "res://RunnerTextures/WorldMap/ForestIcon.png"
var sawmill = "res://RunnerTextures/MillRegionIcon.png"
var sawmill_research1 = "res://RunnerTextures/WoodIcon.png"

var peasant_spawn_time = [6.0, 7.0]
var miller_spawn_time = [6.0, 7.0]
var lumberjack_spawn_time = [6.0, 7.0]
var stoneminer_spawn_time = [6.0, 7.0]
var shepherd_spawn_time = [6.0, 7.0]
var ironminer_spawn_time = [6.0, 7.0]
var goldminer_spawn_time = [6.0, 7.0]

var base_peasant_increase = 15.0
var base_field_increase = 12.5
var base_wood_increase = 10.0
var base_stone_increase = 7.5
var base_wool_increase = 5.0
var base_iron_increase = 2.5
var base_gold_increase = 0.5

#var peasant_increase = [base_peasant_increase*6.5, 9]
#var miller_increase = [base_field_increase*6.5, 6]
#var lumberjack_increase = [base_wood_increase*6.5, 6]
#var stoneminer_increase = [base_stone_increase*6.5, 3]
#var shepherd_increase = [base_wool_increase*6.5, 3]
#var ironminer_increase = [base_iron_increase*6.5, 1.5]
#var goldminer_increase = [base_gold_increase*6.5, 0.3]

var test_peasant_increase = [1]

var copper_score = 0
var grain_score = 0
var wood_score = 0
var stone_score = 0
var wool_score = 0
var iron_score = 0
var gold_score = 0

var cottage_upgrade1_level = 0
var cottage_upgrade2_level = 0
var cottage_upgrade3_level = 0
var mill_upgrade1_level = 0
var mill_upgrade2_level = 0
var mill_upgrade3_level = 0
var sawmill_upgrade1_level = 0
var sawmill_upgrade2_level = 0
var sawmill_upgrade3_level = 0
var stonemine_upgrade1_level = 0
var stonemine_upgrade2_level = 0
var stonemine_upgrade3_level = 0
var sheepfold_upgrade1_level = 0
var sheepfold_upgrade2_level = 0
var sheepfold_upgrade3_level = 0
var ironmine_upgrade1_level = 0
var ironmine_upgrade2_level = 0
var ironmine_upgrade3_level = 0
var goldmine_upgrade1_level = 0
var goldmine_upgrade2_level = 0
var goldmine_upgrade3_level = 0

var copper_church_point = 1
var grain_church_point = 1
var wood_church_point = 1
var stone_church_point = 1
var wool_church_point = 1
var iron_church_point = 1
var gold_church_point = 1

var copper_research_point : float
var grain_research_point : float
var wood_research_point : float
var stone_research_point : float
var wool_research_point : float
var iron_research_point : float
var gold_research_point : float

var copper_research_level = 0
var grain_research_level = 0
var wood_research_level = 0
var stone_research_level = 0
var wool_research_level = 0
var iron_research_level = 0
var gold_research_level = 0

var Items = {
	"Peasant" : [copper_score, cottage_upgrade1_level, cottage_upgrade2_level, miller_spawn_time, "Copper"], 
	"Field" : [grain_score, mill_upgrade1_level, mill_upgrade2_level, miller_spawn_time, "Grain"],
	"Forest" : [wood_score, sawmill_upgrade1_level, sawmill_upgrade2_level, lumberjack_spawn_time, "Wood"],
	"Stone" : [stone_score, stonemine_upgrade1_level, stonemine_upgrade2_level, stoneminer_spawn_time, "Stone"],
	"Wool" : [wool_score, sheepfold_upgrade1_level, sheepfold_upgrade2_level, shepherd_spawn_time, "Wool"],
	"Iron" : [iron_score, ironmine_upgrade1_level, ironmine_upgrade2_level, ironminer_spawn_time, "Iron Ore"],
	"Gold" : [gold_score, goldmine_upgrade1_level, goldmine_upgrade2_level, goldminer_spawn_time, "Golden Ore"],
}


var current_peasant_scene_name


var current_builds = []
var cottage_builds = 0
var mill_builds = 0
var sawmill_builds = 0
var quarry_builds = 0
var sheepfold_builds = 0
var ironmine_builds = 0
var goldmine_builds = 0

var cottage_build_pooler : Array
var mill_build_pooler : Array

#var Price = 0.0
#var price = 0.0
#var CurrentPrice

#var Price = 0.0
#var price = 0.0
var CurrentPrice = 0.0
var CurrentUpgradePrice : float


var pilgrimage_active : bool
var asceticism_active : bool
var temples_active : bool
var supremacy_active : bool

var toggles_name = {
	"Pilgrimage": pilgrimage_active, 
	"Asceticism": asceticism_active, 
	"Temples": temples_active, 
	"Supremacy": supremacy_active
	}

var church_point : Array

func set_price(base_increase, build_quantity, coefficient):
	var Price = base_increase * build_quantity * (1 + 0.05 * build_quantity)
	var wait_time = 10 + build_quantity
	var current = (Price + 0.1 * Price) * wait_time
	CurrentPrice = current + (current * pow(coefficient, build_quantity))

	return CurrentPrice

func set_upgrade_price(base_increase, upgrade_level, coefficient):
	var base_price = base_increase * 10 * 6.5
	var time = upgrade_level * 10
	CurrentUpgradePrice = base_price * (1+(time*upgrade_level))* pow(coefficient, 1+upgrade_level)

	return CurrentUpgradePrice

var quality : float
var active : float
var Passive : float
var PassiveIncome : float
var PassiveIncrease : float


func set_active_income(base_increase, build_quantity, upgrade_level, research_level):
	var U = base_increase * upgrade_level[0]
	var R = base_increase * research_level
	var A = 0
	var K = 0
	active = base_increase * build_quantity + ((U+R+A+K)*build_quantity)

	return active

func set_quality(build_quantity, upgrade_level, procent):
	var Up = float(float(upgrade_level[1] * 5)/100.0)
	quality = 1.0 + (float(float(build_quantity * 5)/100.0) + Up + procent[0] + procent[1] + procent[2] + procent[3])

	return quality

func set_base_increase(base_increase, build_quantity, upgrade_level, procent, ChurchPoint, research_level):
	set_active_income(base_increase, build_quantity, upgrade_level, research_level)
	set_quality(build_quantity, upgrade_level, procent)
	Passive = active*quality*ChurchPoint
	
	return Passive

func set_passive_income(base_increase, build_quantity, upgrade_level, procent, ChurchPoint, research_level):
	set_base_increase(base_increase, build_quantity, upgrade_level, procent, ChurchPoint, research_level)
	PassiveIncome = Passive/10

	return PassiveIncome

func set_peasant_increase(base_increase, build_quantity, upgrade_level, procent, ChurchPoint, research_level):
	set_base_increase(base_increase, build_quantity, upgrade_level, procent, ChurchPoint, research_level)
	PassiveIncrease = Passive*6.5
	
	return PassiveIncrease

var Builds = {
		"Peasant" : [
			[
				[base_peasant_increase, cottage_builds, 1.225],
				[base_field_increase, cottage_builds, 1.225],
				[base_wood_increase, cottage_builds, 1.225],
				],
			[
				base_peasant_increase,
				cottage_builds,
				[cottage_upgrade1_level, cottage_upgrade2_level, cottage_upgrade3_level],
				[copper_research_point, 0.0, 0.0, 0.0],
				copper_research_level,
				copper_church_point,
				], 
			cottage_builds,
			["Peasant", "Field", "Forest"],
			],
		"Field" : [
			[
				[base_peasant_increase, mill_builds, 1.275],
				[base_field_increase, mill_builds, 1.275],
				[base_wood_increase, mill_builds, 1.275],
				],
			[
				base_field_increase,
				mill_builds,
				[mill_upgrade1_level, mill_upgrade2_level, mill_upgrade3_level],
				[grain_research_point, 0.0, 0.0, 0.0],
				grain_research_level,
				grain_church_point,
				],
			mill_builds,
			["Peasant", "Field", "Forest"],
			directory_files("res://RunnerTextures/Field/Region/"),
			directory_files("res://RunnerTextures/Field/Price/"),
			],
		"Forest" : [
			[
				[base_peasant_increase, sawmill_builds, 1.325],
				[base_field_increase, sawmill_builds, 1.325],
				[base_wood_increase, sawmill_builds, 1.325],
				],
			[
				base_wood_increase,
				sawmill_builds,
				[sawmill_upgrade1_level, sawmill_upgrade2_level, sawmill_upgrade3_level],
				[wood_research_point, 0.0, 0.0, 0.0],
				wood_research_level,
				wood_church_point,
				],
			sawmill_builds,
			["Peasant", "Field", "Forest"],
			directory_files("res://RunnerTextures/Forest/Region/"),
			directory_files("res://RunnerTextures/Forest/Price/"),
			],
		"Stone" : [
			[
				[base_peasant_increase, quarry_builds, 1.375],
				[base_field_increase, quarry_builds, 1.375],
				[base_wood_increase, quarry_builds, 1.375],
				],
			[
				base_stone_increase,
				quarry_builds,
				[stonemine_upgrade1_level, stonemine_upgrade2_level, stonemine_upgrade3_level],
				[stone_research_point, 0.0, 0.0, 0.0],
				stone_research_level,
				stone_church_point,
				],
			quarry_builds,
			["Peasant", "Field", "Forest"],
			directory_files("res://RunnerTextures/Stone/Region/"),
			directory_files("res://RunnerTextures/Stone/Price/"),
			],
		"Wool" : [
			[
				[base_field_increase, sheepfold_builds, 1.425],
				[base_wood_increase, sheepfold_builds, 1.425],
				[base_stone_increase, sheepfold_builds, 1.425],
				],
			[
				base_wool_increase,
				sheepfold_builds,
				[sheepfold_upgrade1_level, sheepfold_upgrade2_level, sheepfold_upgrade3_level],
				[wood_research_point, 0.0, 0.0, 0.0],
				wool_research_level,
				wool_church_point,
				],
			sheepfold_builds,
			["Field", "Forest", "Stone"],
			directory_files("res://RunnerTextures/Wool/Region/"),
			directory_files("res://RunnerTextures/Wool/Price/"),
			],
		"Iron" : [
			[
				[base_wood_increase, ironmine_builds, 1.475],
				[base_stone_increase, ironmine_builds, 1.475],
				[base_wool_increase, ironmine_builds, 1.475],
				],
			[
				base_iron_increase,
				ironmine_builds,
				[ironmine_upgrade1_level, ironmine_upgrade2_level, ironmine_upgrade3_level],
				[iron_research_point, 0.0, 0.0, 0.0],
				iron_research_level,
				iron_church_point,
				],
			ironmine_builds,
			["Forest", "Stone", "Wool"],
			directory_files("res://RunnerTextures/Iron/Region/"),
			directory_files("res://RunnerTextures/Iron/Price/"),
			],
		"Gold" : [
			[
				[base_wool_increase, goldmine_builds, 1.525],
				[base_stone_increase, goldmine_builds, 1.525],
				[base_iron_increase, goldmine_builds, 1.525],
				],
			[
				base_gold_increase,
				goldmine_builds,
				[goldmine_upgrade1_level, goldmine_upgrade2_level, goldmine_upgrade3_level],
				[gold_research_point, 0.0, 0.0, 0.0],
				gold_research_level,
				gold_church_point,
				],
			goldmine_builds,
			["Wool", "Stone", "Iron"],
			directory_files("res://RunnerTextures/Gold/Region/"),
			directory_files("res://RunnerTextures/Gold/Price/"),
			],
	}


var selected_upgrade = []
var source_animations = []
var choosed_region = ["Wool", "Forest", "Stone"]
var choosed_tile : String
var changing_region

var choosed_research : String

func directory_files(path):
	var files = []
	var directory = Directory.new()
	directory.open(path)
	directory.list_dir_begin()
	
	while true:
		var file = directory.get_next()
		if file == "":
			break
		elif not file.begins_with(".") && not file.ends_with(".import"):
			files.append(str(path) + str(file))
	
	directory.list_dir_end()
	
	return files

var research_path = "res://Data/researches.csv"

func get_research_data():
	var MainData = {}
	var file = File.new()
	file.open(research_path, file.READ)
	while !file.eof_reached():
		var data_set = Array(file.get_csv_line())
		MainData[MainData.size()] = data_set
	file.close()
	#print(MainData)
	
	return MainData

var ResearchLevelData : Array

func research_data_reverse(Data):
	var ResearchData : Dictionary
	for i in Data.keys():
		ResearchData[Data[i][0]] = i
	for i in ResearchData.size():
		if ResearchLevelData.size() < 88:
			ResearchLevelData.append(0)

	return ResearchData

var DublicateData : Dictionary
