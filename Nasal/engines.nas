# engine.nas by geed

var pi = 3.14159;
var PWR2TRQ = 60 / 2 / pi * 6.931;
var PWR2TRQPCT = PWR2TRQ / 986 * 100;

var max = func(a, b) a > b ? a : b;
var min = func(a, b) a < b ? a : b;

#set caution ranges for enigines oil temp and press gauges
setprop("/engines/oilt-caution-lo-degc",30);
setprop("/engines/oilt-caution-hi-degc",120);
setprop("/engines/oilp-caution-lo-bar",1.5);
setprop("/engines/oilp-caution-hi-bar",8);
setprop("/engines/oilp-ratio-bar-to-psi",21); # this is the ratio for the OIL PSI instrument to show the right value, not the real life ratio (which is 14.5038)

var oilpressure =  func(n){

  oilpres_low = props.globals.getNode("/engines/engine[" ~ n ~ "]/oil-pressure-low", 1);
  oilpres_norm = props.globals.getNode("/engines/engine[" ~ n ~ "]/oil-pressure-norm", 1);
  oilpres_bar = props.globals.getNode("/engines/engine[" ~ n ~ "]/oil-pressure-bar", 1);

  var rpm = props.globals.getValue("/engines/engine[" ~ n ~ "]/n2-rpm") or 0;

  if ( rpm > 0 ) oilpres_low.setDoubleValue((15-22000/rpm)*0.0689);
  if ( rpm > 0 ) oilpres_norm.setDoubleValue((60-22000/rpm)*0.0689);

  settimer(func { oilpressure(n) }, 0);
}

oilpressure(0);
oilpressure(1);

##############

var oilpressurebar = func(n){

  oilpres_bar = props.globals.getNode("/engines/engine[" ~ n ~ "]/oil-pressure-bar", 1);

  var rpm = props.globals.getValue("/engines/engine[" ~ n ~ "]/n2-rpm") or 0;
  var oilpres_low = props.globals.getValue("/engines/engine[" ~ n ~ "]/oil-pressure-low") or 0;
  var oilpres_norm = props.globals.getValue("/engines/engine[" ~ n ~ "]/oil-pressure-norm") or 0;

  # by litzi clamp oilpressure >= 0
  
  if ((rpm > 0) and (rpm < 23000)){
    interpolate ("/engines/engine[" ~ n ~ "]/oil-pressure-bar", max(oilpres_low, 0) , 1.5);
  }elsif (rpm > 23000) {
    interpolate ("/engines/engine[" ~ n ~ "]/oil-pressure-bar", max(oilpres_norm, 0) , 2);
  }

  settimer(func { oilpressurebar(n) }, 0.1);
}

oilpressurebar(0);
oilpressurebar(1);

##################

var oiltemp = func(n){

  var OAT = props.globals.getValue("/environment/temperature-degc") or 0;
  var oilpres_bar = props.globals.getValue("/engines/engine[" ~ n ~ "]/oil-pressure-bar") or 0;
  var rpm = props.globals.getValue("/engines/engine[" ~ n ~ "]/n2-rpm") or 0;
  ot = props.globals.getNode("/engines/engine[" ~ n ~ "]/oil-temperature-degc", 1);

  
  if (oilpres_bar >1){
    interpolate ("/engines/engine[" ~ n ~ "]/oil-temperature-degc", ((25-22000/rpm)*oilpres_bar)+OAT , 20);
  } else {
    interpolate ("/engines/engine[" ~ n ~ "]/oil-temperature-degc", OAT , 20);
  }

  settimer( func { oiltemp(n) }, 0);
}

oiltemp(0);
oiltemp(1);

#########################################

###main gear box oil pressure###
var mgbp =  func {

  #create oilpressure#
  mgb_oilpres_low = props.globals.getNode("/rotors/gear/mgb-oil-pressure-low", 1);
  mgb_oilpres_norm = props.globals.getNode("/rotors/gear/mgb-oil-pressure-norm", 1);
  mgb_oilpres_bar = props.globals.getNode("/rotors/gear/mgb-oil-pressure-bar", 1);

  var rpm = props.globals.getValue("/rotors/main/rpm") or 0;

  if ( rpm > 0 ) mgb_oilpres_low.setDoubleValue((15-230/rpm)*0.0689);
  if ( rpm > 0 ) mgb_oilpres_norm.setDoubleValue((60-230/rpm)*0.0689);

  settimer(mgbp, 0);
}

mgbp();

##############

var mgbp_bar = func{

  mgb_oilpres_bar = props.globals.getNode("/rotors/gear/mgb-oil-pressure-bar", 1);

  var rpm = props.globals.getValue("/rotors/main/rpm") or 0;
  mgb_oilpres_low = props.globals.getValue("/rotors/gear/mgb-oil-pressure-low") or 0;
  mgb_oilpres_norm = props.globals.getValue("/rotors/gear/mgb-oil-pressure-norm") or 0;

  if ((rpm > 0) and (rpm < 280)){
    interpolate ("/rotors/gear/mgb-oil-pressure-bar",max(mgb_oilpres_low,0), 1.5);
  }elsif (rpm > 280) {
    interpolate ("/rotors/gear/mgb-oil-pressure-bar",max(mgb_oilpres_norm,0), 2);
  }

  settimer(mgbp_bar, 0.1);
}

mgbp_bar();