extends Label

func _process(delta):
	
	#get pc clock time
	var system_time = OS.get_time()
	
	#format it and set to the text of the label
	text = var2str("%02d" % system_time["hour"] + ":" 
		 + "%02d" % system_time["minute"] + ":"
		 + "%02d" % system_time["second"]) 
