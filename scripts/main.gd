extends Node2D

onready var seeds : OptionButton = $seeds

func _ready() -> void:
	do_load() # Load or game
	
	#Add the list of seeds we can plant
	seeds.add_item("corn")
	seeds.add_item("rose")
	seeds.add_item("sunflower")
	seeds.add_item("tomato")
	seeds.add_item("turnip")
	seeds.add_item("tulip")

func do_save():
	var save_data = {} # make new empty dictionary
	for i in get_tree().get_nodes_in_group("plots"): # loop through every splot in group plots
		#For this plot name, save an array of 3 values  (planted,animation name,timeplanted)
		save_data[i.name] = [i.planted,i.get_node("plant").animation,i.planted_time]
	
	#Write this into a file
	var f := File.new()
	f.open("res://data/data.json", File.WRITE)
	f.store_string(JSON.print(save_data))
	f.close()
	
func do_load():
	#Load our json, result.result will return null if file not found
	var f := File.new() #set f as new file
	if f.file_exists("res://data/data.json"): #If the file exists, then continue
		f.open("res://data/data.json", File.READ) # open the file
		var result := JSON.parse(f.get_as_text()) # parse into a dictionary(result)
		f.close() # finished with the file remove
		
		if(result.result !=null):#Check if the dictionary isn't null
			#loop through every plot (don't forget to apply the group now)
			for i in get_tree().get_nodes_in_group("plots"): 
				var data = result.result[i.name] #Pull the data for this plot
				i.do_load(data[0],data[1],data[2])#Update the plot with saved data

func _on_btnsave_pressed() -> void:
	do_save() # Saves the current game
	get_tree().quit() # ends game
