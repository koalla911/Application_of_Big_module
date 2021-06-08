extends Node2D

var movement_speed = 205
var current_peasant
var current_item_peasant
var current_item
var current_animation

var current_quantity
var increased_quantity

var particle_movement = false

onready var player = get_parent().get_parent().get_node("Player")
var movement_animations = []
onready var source_particles = $SourceParticle

signal get_item
signal pickup_animation
signal item_increase

func _physics_process(delta):
	position.x -= movement_speed * delta
	if source_particles.emitting == true:
		source_particles.position.x += 200 * delta
		#source_particles.position.x = player.position.x

func _on_VisibilityNotifier2D_screen_entered():
	#source_particles = load("res://Scenes/SourceParticle.tscn")
	$Interact.add_to_group("Item")
	current_animation = $Texture.get_animation()
	movement_animations.append(current_animation)
	match current_animation:
		"Iron" : movement_speed -= 15
		"Stone" : movement_speed -= 15 
		"Forest" : movement_speed -= 20 
		"Peasant" : movement_speed += 5 
		"Field" : movement_speed -= 10 
	$Texture.playing = true
	#source_particles.get_node("Light2D").enabled = false
#	for i in movement_animations.size():
#		$Movement.play(str(current_animation))
#		$Movement.seek(0.0, true)
	#player = get_parent().get_parent().get_node("Player")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Interact_area_entered(area):
	#print(area.get_name())
	if area.get_name() == "Player":
		source_particles.texture = load("res://RunnerTextures/Pixel/Sources/"+str(current_animation)+".png")
		Global.current_item_animation.append(current_animation)
		#print(Global.current_item_animation)
		var Peasant = Global.Builds[current_animation]
		#var PeasantIncrease = funcref(Global, "set_base_increase")#set_peasant_increase(Peasant[1][0], Peasant[1][1], Peasant[1][2], Peasant[1][3], Peasant[1][Peasant[1].size()-1], Peasant[1][Peasant[1].size()-2])
		var PeasantIncrease = Global.set_peasant_increase(Peasant[1][0], Peasant[1][1], Peasant[1][2], Peasant[1][3], Peasant[1][Peasant[1].size()-1], Peasant[1][Peasant[1].size()-2])
		#Global.indentify_string(Global.Items[current_animation][0], Global.test_peasant_increase)
		
		for i in Global.current_item_animation.size():
			#Global.Number = Global.set_aa_notation()
			#Global.get_current_score()
			#get_current_score(current_animation, Global.test_peasant_increase)
			#print(Global.Items[current_animation][0])
	#		print("start_number : "+str(Global.start_number))
	#		print("finish_number : "+str(Global.finish_number))
			
			Global.Items[current_animation][0] += PeasantIncrease
		if PeasantIncrease > 0:
			#print(Global.set_peasant_increase(Peasant[1][0], Peasant[1][1], Peasant[1][2], Peasant[1][3], Peasant[1][Peasant[1].size()-1], Peasant[1][Peasant[1].size()-2]).toAA())
			$Texture.set_animation(current_animation + "Free")
			#emit_signal("item_increase")
			source_particles.emitting = true
			particle_movement = true
			#source_particles.position.x = player.position.x
			#source_particles.get_node("Light2D").enabled = true
			#print(source_particles.texture)
	#		match current_animation:
	#			"Iron" : source_particles.tangential_accel = 45.93
	#			"Stone" : source_particles.tangential_accel = -3.91
	#			"Forest" : source_particles.tangential_accel = -27.44
	#			"Peasant" : source_particles.tangential_accel = -64
	#			"Field" : source_particles.tangential_accel = -47
	#			"Wool" : source_particles.tangential_accel = 20.93
	#			"Gold" : source_particles.tangential_accel = 57.29
			#var peasant_name = get_name()
			emit_signal("pickup_animation", current_animation)
	#print(Global.set_peasant_increase(Global.Builds[current_animation][1][0], Global.Builds[current_animation][1][1], Global.Builds[current_animation][1][2][0], Global.Builds[current_animation][1][2][1], Global.Builds[current_animation][1][3], Global.Builds[current_animation][1][Global.Builds[current_animation][1].size()-1]))

#func get_current_score(Score, Income):
#	Global.Items[Score][0] = Global.get_max_length()
#	#print(copper_score)
#	Global.indentify_string(Global.Items[Score][0], Income)
#	Global.reverse_c = []
#	return Global.Items[Score][0]

func _on_Interact_area_exited(area):
	if area.get_name() == "Player":
		Global.current_item_animation.remove(current_animation)
