extends Area2D

signal item_increased
signal ready_to_building
signal building_over
signal price_off
var CurrentItem
var building
var build_preload_scene = preload("res://Scenes/Build.tscn")

var added_in_counter

func _ready():
	for i in Global.choosed_region.size()+1:
		get_parent().connect("build" + str(i+1), self, "_on_Main_build" + str(i+1))
	$LocalScore.text = ""
	$Movement.play("Idle")


func _physics_process(delta):
	if Global.current_item_animation.size() >= 1:
		CurrentItem = Global.Builds[Global.current_item_animation[0]]
		$Item.set_animation(Global.current_item_animation[Global.current_item_animation.size()-1])


func _on_Player_area_entered(area):
	if area.is_in_group("Item"):
		area.get_parent().connect("pickup_animation", self, "_on_Peasant_pickup_animation")


func _on_Peasant_pickup_animation(current_animation):
	emit_signal("item_increased", current_animation)


func building_control(build_animation, Build, array):
	check_building_condition(build_animation, Build)
	increasing_build_quantity(array)
	building = false
	emit_signal("building_over", building)
	emit_signal("price_off")

func _on_Main_build1():
	building_control("Cottage", "Peasant", "Peasant")

func _on_Main_build2():
	building_control(str(Global.choosed_region[0]), Global.choosed_region[0], str(Global.choosed_region[0]))

func _on_Main_build3():
	building_control(str(Global.choosed_region[1]), Global.choosed_region[1], str(Global.choosed_region[1]))

func _on_Main_build4():
	building_control(str(Global.choosed_region[2]), Global.choosed_region[2], str(Global.choosed_region[2]))


#determine building condition
func check_building_condition(build_animation, Build):
	added_in_counter = false
	if Global.Items[Global.Builds[str(Build)][3][0]][0] >= Global.set_price(Global.Builds[str(Build)][0][0][0], Global.Builds[str(Build)][1][1], Global.Builds[str(Build)][0][0][2]):
		if Global.Items[Global.Builds[str(Build)][3][1]][0] >= Global.set_price(Global.Builds[str(Build)][0][1][0], Global.Builds[str(Build)][1][1], Global.Builds[str(Build)][0][1][2]):
			if Global.Items[Global.Builds[str(Build)][3][2]][0] >= Global.set_price(Global.Builds[str(Build)][0][2][0], Global.Builds[str(Build)][1][1], Global.Builds[str(Build)][0][2][2]):
				instancing_build(build_animation)
				decreasing_item_score(Build)


func instancing_build(build_animation):
	var instanced_build = build_preload_scene.instance()
	get_parent().get_node("BuildPosition").add_child(instanced_build)
	instanced_build.get_node("Texture").set_animation(build_animation)
	instanced_build.get_node("BuildOn").play("BuildOn")
	instanced_build.get_node("BuildOn").seek(0.0, true)
	added_in_counter = true


#increasing build counter
func increasing_build_quantity(array):
	if added_in_counter == true:
		Global.Builds[array][1][1] += 1


#decrease current score on build price
func decreasing_item_score(Build):
	for i in range(0, 3):
		Global.Items[Global.Builds[str(Build)][3][i]][0] -= Global.set_price(Global.Builds[str(Build)][0][i][0], Global.Builds[str(Build)][0][i][1], Global.Builds[str(Build)][0][i][2])


func _on_Player_mouse_entered():
	print("player")
