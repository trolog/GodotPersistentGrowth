extends Sprite
#Does this plot have a plant?
var planted = false

#When did we plant this seed?(used to work out growth stage)
var planted_time = 0

#How long till the plant is fully mature? 3600 = 1 hour
var plant_complete_time = 3600

#There are 6 stages(0,1,2,3,4,5) 0 = seeds 5 = fully mature
var current_stage = -1

#Called when we click on an empty plot, plants a seed(strname)
func plant(strname):
	planted_time = OS.get_unix_time()

	texture = load("res://farmplot1.png") #farmplot plot no hole
	
	#Gets our plant, sets the right texture,makes visible,frame=0 is seed texture
	$plant.animation = strname
	$plant.show()
	$plant.frame = 0
	
	planted = true
	
#Called when we load our plant, it sets the plot/plant up correctly
func do_load(is_planted,seed_name,time_planted):
	if(is_planted):
		planted = true
		$plant.animation = seed_name
		planted_time = time_planted
		texture = load("res://farmplot1.png")
		$plant.show()

#We check for left click, if inside the plots position,
#then we plant a seed, but only if there isn't one already planted
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			if(!planted):
				plant(Planter.plant_seed)

#Check if we have a plant, if we do, then workout growth of plant
func _physics_process(delta: float) -> void:
	if(planted):
		do_growth_logic()

#Using the time planted var and the current get_unix_time, we can workout how much time has
#passed since we planted this seed, we then increase the stages accordingly
func do_growth_logic():
	var time_passed = OS.get_unix_time() - planted_time # Work out time passed in Unix time
	var stages = (plant_complete_time / 5) # calculate how long the stages are by 5(excluding 0)

	if(current_stage == 0): # we excluded 0, so we do it here
		if(time_passed > stages): 
			current_stage += 1
			$plant.frame = current_stage
	else: # work out stage 1 to 5
		if(current_stage < 5): # only work out if we've not hit the final stage
			if(time_passed > ((current_stage + 1) * stages)): #increase stage, if time_pass is bigger than next stage
				current_stage += 1
				$plant.frame = current_stage # the frame of the animatedsprite repsersents stages
