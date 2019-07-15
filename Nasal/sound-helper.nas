var view_level_inside = props.globals.initNode("/sound/view-level-inside");
var view_level_outside = props.globals.initNode("/sound/view-level-outside");

setlistener("sim/current-view/internal", func{
		if(getprop("sim/current-view/internal")==1){
			view_level_inside.setValue(1.0);
			view_level_outside.setValue(0.0);
		}else{
			view_level_inside.setValue(0.0);
			view_level_outside.setValue(1.0);
		}
}, 1);
