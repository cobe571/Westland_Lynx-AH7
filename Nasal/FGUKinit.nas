#Radio Power Logic
var radiopower = {
   update : func {
        var batswitch = getprop("/controls/electric/directbat-switch");
        var generator = getprop("/controls/electric/engine/generator");
        if (batswitch == 1 or generator == 1) {
            setprop("/controls/electric/radiopower", 1);
        } else {
            setprop("/controls/electric/radiopower", 0);
        }
    },
};

#Radio Power Logic
var hydraulic1 = {
   update : func {
        var alternator = getprop("/systems/electrical/serviceable");
        if (alternator == 1) {
            setprop("/controls/hydraulic/system/engine-pump", 1);
        } else {
            setprop("/controls/hydraulic/system/engine-pump", 0);
        }
    },
};

setlistener("/controls/electric/directbat-switch", func {radiopower.update();});
setlistener("/controls/electric/engine/generator", func {radiopower.update();});
setlistener("/systems/electrical/serviceable", func {hydraulic1.update();});
