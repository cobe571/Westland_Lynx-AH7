# flir camera control
# 12/2017 by G-EED

var sar_selected = 0;

var nodeFlir=nil;
var numWeight=0;
var options = std.Vector.new();
var numView = 0;

stringContainWords = func(s,words){
	var found = 0;
	foreach(var w; words.vector) {
		if( string.match(s,w) ){
			found=1;
			break;
		}
	}
	return found;
}

activate_flir_shader = func(a){
	if(getprop("sim/rendering/rembrandt/enabled")==0){
		setprop("sim/rendering/als-filters/use-filtering", a);
		setprop("sim/rendering/als-filters/use-IR-vision", a);
	}else{
		setprop("sim/rendering/rembrandt/night-vision", a);
	}
}

check_view_for_flir = func(n){
	print("check_view_for_flir",n,"");

	var viewnum = 0;
	foreach(var w; props.globals.getNode("sim").getChildren("view")) {
		if(n==viewnum){
        	var selected = w.getNode("flir");
	        if(selected != nil) {
	            print("view ",viewnum," has a FLIR");
	            activate_flir_shader(1);
	        }else{
	        	print("view ",viewnum," has no FLIR");
	        	activate_flir_shader(0);
	        }
        }
        viewnum=viewnum+1;
    }
}

setlistener("sim/signals/fdm-initialized", func {

	nodeFlir = props.globals.getNode("sim/flir");
	if(nodeFlir != nil){
		numWeight = nodeFlir.getValue("weight");
		if(numWeight!=nil){
			numView = nodeFlir.getValue("view");
			if(numWeight!=nil){

				foreach(var w; nodeFlir.getNode("options").getChildren("name")) {
					options.append(w.getValue());
			    }
			    
			    if(options.size() > 0){

					setlistener("sim/weight["~numWeight~"]/selected", func(s) {
						if( stringContainWords( getprop("sim/weight["~numWeight~"]/selected") , options ) == 1 ){
							print("SAR selected");
							setprop("sim/view["~numView~"]/enabled",1);
							#activate_flir_shader(1);
						}else{
							print("SAR deselected");
							setprop("sim/view["~numView~"]/enabled",0);
							#activate_flir_shader(0);
						}
					}, 1);

					setlistener("/sim/current-view/view-number", func(n) {
						check_view_for_flir(n.getValue());
					}, 1);

					print("Flir: SUCCESS! view control ......... Initialized");
			    }else{
			    	print("Flir: FAILED! Error: No options have been defined for the weight",numWeight);
			    }

			}else{
				print("Flir: FAILED! Error: No FLIR view has been defined");
			}
		}else{
			print("Flir: FAILED! Error: Could not find property node sim/flir/_attr_/weight");
		}
	}else{
		print("Flir: FAILED! Error: Could not find property node sim/flir");
	}
});
