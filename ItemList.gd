extends TextureRect

onready var player = get_parent().get_parent().get_node("Player")

var item_name = []
var item_list = []
var item_texture = []
var resourse_name = Global.Items.keys()
var mouse_enter
var item_list_name = []

var current_font = preload("res://Fonts/BitPotion.ttf")
var dynamic_font
var dynamic_font_less

var Item
var Dict
#var item_list2 = []

func _ready():
	#print(get_parent().get_parent().get_name())
	if get_parent().get_parent().get_name() == "Main":
		player.connect("item_increased", self, "_on_Player_item_increased")
#	if get_parent().get_parent().get_name() == "Main":
#		self_modulate = Color(1, 1, 1, 0)
	global_items_score()
	item_list = get_children()
	Item = item_list_name
	Dict = Global.Builds
	for i in item_list.size():
		if get_parent().get_parent().get_name() == "Main":
			item_list[i].modulate = Color(1, 1, 1, 0.352941)
#		item_list[i].get_node("ItemIcon").connect("mouse_entered", self, "_on_ItemIcon_mouse_entered")
#		item_list[i].get_node("ItemIcon").connect("mouse_exited", self, "_on_ItemIcon_mouse_exited")
		item_list[i].get_node("ItemBoost").text = ""
		item_list[i].get_node("BoostTimer").autostart = true
		item_list[i].get_node("BoostTimer").paused = true
		item_list[i].get_node("BoostTimer").connect("timeout", self, "_on_BoostTimer_timeout")
		item_list_name.append(item_list[i].get_name())
	dynamic_font = DynamicFont.new()
	dynamic_font_less = DynamicFont.new()
	dynamic_font.font_data = current_font
	dynamic_font_less.font_data = current_font
	dynamic_font.size = 70
	dynamic_font_less.size = 40
	for i in item_list.size():
		item_list[i].set("custom_fonts/font", dynamic_font)
		item_list[i].get_node("ItemBoost").set("custom_fonts/font", dynamic_font_less)
	#print(item_list_name)
	global_items_score()
#	if Global.choosed_region != []:
#		for i in Global.choosed_region:
#			get_node(str(item_list_name)).get_node("BoostTimer").connect("timeout", self, "_on_BoostTimer_timeout")
	#get_parent().get_node("ItemName").visible = false
	#print(counter[Counter+3])

func _physics_process(_delta):
	global_items_score()
	item_passive_income()

func global_items_score():
	for i in item_list.size():
		item_list[i].text = str(int(Global.Items[resourse_name[i]][0]))#Global.set_aa_notation(Global.Items[resourse_name[i]][0])#str(Global.Items[resourse_name[i]][0])
		#Global.set_aa_notation(Global.Items[resourse_name[i]][0])

func item_passive_income():
	for i in Item.size():
		if Global.set_passive_income(Dict[Item[i]][1][0], Dict[Item[i]][1][1], Dict[Item[i]][1][2], Dict[Item[i]][1][3], Dict[Item[i]][1][Dict[Item[i]][1].size()-1], Dict[Item[i]][1][Dict[Item[i]][1].size()-2]) > 0.0:
			get_node(str(Item[i])).get_node("ItemBoost").text = "+" + str(Global.set_passive_income(Dict[Item[i]][1][0], Dict[Item[i]][1][1], Dict[Item[i]][1][2], Dict[Item[i]][1][3], Dict[Item[i]][1][Dict[Item[i]][1].size()-1], Dict[Item[i]][1][Dict[Item[i]][1].size()-2]))
			get_node(str(Item[i])).get_node("BoostTimer").paused = false

func _on_BoostTimer_timeout():
	for i in Item.size():
		Global.Items[Item[i]][0] += Global.set_passive_income(Dict[Item[i]][1][0], Dict[Item[i]][1][1], Dict[Item[i]][1][2], Dict[Item[i]][1][3], Dict[Item[i]][1][Dict[Item[i]][1].size()-1], Dict[Item[i]][1][Dict[Item[i]][1].size()-2])/100
		#Global.Items[Item[i]][0].plus(Global.set_passive_income(Dict[Item[i]][1][0], Dict[Item[i]][1][1], Dict[Item[i]][1][2], Dict[Item[i]][1][3], Dict[Item[i]][1][Dict[Item[i]][1].size()-1], Dict[Item[i]][1][Dict[Item[i]][1].size()-2])).divide(100)
#	Global.Items["Peasant"][0] += Global.set_passive_income(Global.Builds["Peasant"][1][0], Global.Builds["Peasant"][1][1], Global.Builds["Peasant"][1][2][0], Global.Builds["Peasant"][1][2][1], Global.Builds["Peasant"][1][3], Global.Builds["Peasant"][1][Global.Builds["Peasant"][1].size()-1])/100
#	if Global.choosed_region != []:
#		for i in Global.choosed_region.size():
#			Global.Items[Global.choosed_region[i]][0] += Global.set_passive_income(Global.Builds[Global.choosed_region[i]][1][0], Global.Builds[Global.choosed_region[i]][1][1], Global.Builds[Global.choosed_region[i]][1][2][0], Global.Builds[Global.choosed_region[i]][1][2][1], Global.Builds[Global.choosed_region[i]][1][3], Global.Builds[Global.choosed_region[i]][1][Global.Builds[Global.choosed_region[i]][1].size()-1])/100

func _on_Player_item_increased(current_animation):
	#print(get_name())
	get_node(str(current_animation)).modulate = Color(1, 1, 1, 1)
#	get_node(str(current_animation)).material.set_shader_param("color", Color(0.168627, 0.509804, 0.843137))
#	get_node(str(current_animation)).material.set_shader_param("width", 1.1)
	#get_node(str(current_animation)).custom_fonts.font.outline_size = 1
	get_node(str(current_animation)+"/ItemIcon/Tween").interpolate_property(get_node(str(current_animation)+"/ItemIcon"), "rect_scale", Vector2(0.9, 0.6), Vector2(0.7, 0.7), 0.3, get_node(str(current_animation)+"/ItemIcon/Tween").TRANS_BOUNCE, get_node(str(current_animation)+"/ItemIcon/Tween").EASE_IN_OUT)
	get_node(str(current_animation)+"/ItemIcon/Tween").start()
	yield(get_tree().create_timer(1.0), "timeout")
	#get_node(str(current_animation)+"/Tween").interpolate_property(get_node(str(current_animation)).get_material(), "shader_param/width", 1.1, 0, 0.3, get_node(str(current_animation)+"/Tween").TRANS_LINEAR, get_node(str(current_animation)+"/Tween").EASE_IN_OUT)
	get_node(str(current_animation)+"/Tween").interpolate_property(get_node(str(current_animation)), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0.352941), 0.4, get_node(str(current_animation)+"/Tween").TRANS_LINEAR, get_node(str(current_animation)+"/Tween").EASE_OUT)
	get_node(str(current_animation)+"/Tween").start()
