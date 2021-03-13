function rotation(){}
function avrage(){}
var  on = false;
var Ruuvitag = require("Ruuvitag");

var previousWall = 0;
Ruuvitag.setAccelOn(true);
setInterval(function() {
  on = !on;
  rotation();
  LED1.write(on);
}, 500);



function rotation(){
var acc=Ruuvitag.getAccelData();

  
var x = acc.x;
var y = acc.y;
var z = acc.z;
var wall;


var xAbs = Math.abs(x);
var yAbs = Math.abs(y);
var zAbs = Math.abs(z);
  
var max = Math.max(xAbs, yAbs, zAbs);

if(max ==xAbs){
  if(x>0){
    wall = 6;
  }  else{
    wall = 5;
  }
}
else if(max ==yAbs){
  if(y>0){
    wall = 4;
  }  else{
    wall = 2;
  }
}
else if(max ==zAbs){
  if(z>0){
    wall = 1;
  }  else{
    wall = 3;
  }
}


  
if((previousWall != wall)){
  console.log('jestem na scianie ' + wall);
  previousWall = wall;
}


}
