# RALT control
# 10/2018 by StuartC

setprop("/instrumentation/radar-altimeter/decision-height", 200);
 setprop("/instrumentation/radar-altimeter/decision-height-light", 0);
 
 if( getprop("/position/altitude-agl-ft") >= getprop("/instrumentation/radar-altimeter/decision-height") ){
			setprop("/instrumentation/radar-altimeter/decision-height-light", 0);
		}
		else{
			setprop("/instrumentation/radar-altimeter/decision-height-light", 1);
		}
