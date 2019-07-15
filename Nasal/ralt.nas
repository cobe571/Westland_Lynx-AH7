# RALT control
# 10/2018 by StuartC

setprop("/instrumentation/radar-altimeter/decision-height", 200);
setprop("/instrumentation/radar-altimeter/decision-height-light", 0);

var OurAlt            = props.globals.getNode("position/altitude-ft");
var DecisionHeight    = props.globals.getNode("/instrumentation/radar-altimeter/decision-height");

setprop("/instrumentation/radar-altimeter/decision-height-light", 0);

# Main loop ###############
var rdr_loop = func() {
	var alt = OurAlt.getValue();
	var decHeight = DecisionHeight.getValue();

	if( alt < decHeight ){
		setprop("/instrumentation/radar-altimeter/decision-height-light", 1);
	}else{
		setprop("/instrumentation/radar-altimeter/decision-height-light", 0);
	}   

	settimer(rdr_loop, 1.0);
}

settimer(rdr_loop, 1.0);
