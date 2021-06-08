extends VBoxContainer

var BuildingIcons
var BuildingInformation
var instance_price_icon
var price_icon1
var price_icon2
var price_icon3

var player
var spawner


func _ready():
	self_modulate = Color(1, 1, 1, 0)
	instance_price_icon = [price_icon1, price_icon2, price_icon3]
	BuildingIcons = ["Build2", "Build3", "Build4"]
	get_icon_texture()


func _process(delta):
	set_price_info("Peasant", "Build1/Info/Price")
	for i in Global.choosed_region.size():
		set_price_info(str(Global.choosed_region[i]), BuildingIcons[i]+"/Info/Price")


func set_price_info(Build, PriceNode):
	for j in range(0,3):
		set_label_build_price(j, Build, get_node(PriceNode + str(j+1)))
		set_label_price_color(j, Build, get_node(PriceNode + str(j+1)))


func set_label_build_price(index, Build, PriceNode):
	PriceNode.text = str(int(Global.set_price(Global.Builds[Build][0][index][0], Global.Builds[Build][1][1], Global.Builds[Build][0][index][2])))


func set_label_price_color(index, Build, PriceNode):
	if Global.set_price(Global.Builds[Build][0][index][0], Global.Builds[Build][1][1], Global.Builds[Build][0][index][2]) > Global.Items[Global.Builds[Build][3][index]][0]:
		PriceNode.modulate = Color(0.741176, 0.290196, 0.047059)
	if Global.set_price(Global.Builds[Build][0][index][0], Global.Builds[Build][1][1], Global.Builds[Build][0][index][2]) <= Global.Items[Global.Builds[Build][3][index]][0]:
		PriceNode.modulate = Color(1,1,1,1)


func price_visible():
	for i in BuildingIcons.size():
		get_node(BuildingIcons[i]).visible = false
	if Global.choosed_region != []:
		for j in Global.choosed_region.size():
			get_node(BuildingIcons[j]).visible = true


func get_icon_texture():
	if Global.choosed_region != []:
		for i in Global.choosed_region.size():
			get_node(BuildingIcons[i]).get_node("Build").texture = load(Global.Builds[Global.choosed_region[i]][Global.Builds[Global.choosed_region[i]].size()-2][0])
		#print(Global.choosed_region)
		get_price_icon_texture()

func get_price_icon_texture():
	var loaded_price_icon = load("res://Scenes/UI/BuildPriceIcon.tscn")
	var instance_price_icon = [price_icon1, price_icon2, price_icon3]
	for i in Global.choosed_region.size():
		for j in BuildingIcons.size():
			instance_price_icon[j] = loaded_price_icon.instance()
			instance_price_icon[j].set_animation(str(Global.Builds[Global.choosed_region[i]][Global.Builds[Global.choosed_region[0]].size()-3][j]))
			instance_price_icon[j].show_behind_parent = true
			instance_price_icon[j].set_position(Vector2(-30, 28))
			get_node(BuildingIcons[i]+"/Info/Price" + str(j+1)).add_child(instance_price_icon[j])
