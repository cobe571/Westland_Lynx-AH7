var wiper = func{
  var pos = getprop( "controls/wiper/pos" ) or 0;
  var ws = getprop( "controls/wiper/speed" );
  var side = getprop( "controls/wiper/side" );

  if( ws == 1 ){
    if( side >= 0 ) interpolate( "/controls/wiper/poscp", 90, 1, 0, 1 );
    if( side <= 0 ) interpolate( "/controls/wiper/posp",  90, 1, 0, 1 );
    settimer( wiper, 8.0 );
  }else if( ws == 2 ){
    if( side >= 0 ) interpolate( "/controls/wiper/poscp", 90, 1, 0, 1 );
    if( side <= 0 ) interpolate( "/controls/wiper/posp",  90, 1, 0, 1 );
    settimer( wiper, 2.5 );
  }else if( ws == 3 ){
    if( side >= 0 ) interpolate( "/controls/wiper/poscp", 90, 0.5, 0, 0.5 );
    if( side <= 0 ) interpolate( "/controls/wiper/posp",  90, 0.5, 0, 0.5 );
    settimer( wiper, 1.6 );
#  }else if( ws == -1 ){
 #   if( side >= 0 ) interpolate( "/controls/wiper/poscp", 90, 1 );
 #   if( side <= 0 ) interpolate( "/controls/wiper/posp",  90, 1 );
  #  settimer( wiper, 1 );
  }else{
    interpolate( "/controls/wiper/poscp", 0, 1 );
    interpolate( "/controls/wiper/psop",  0, 1 );
  }
} #wiper()


setlistener( "controls/wiper/speed", func{ bo105.wiper(); } );
