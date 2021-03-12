var  on = false;
var Ruuvitag = require("Ruuvitag");
var x = [];
var y = [];
var z = [];
var i =0;
var wall = "bład";
 Ruuvitag.setAccelOn(true);
setInterval(function() {
  on = !on;
rotation();
  //console.log(Ruuvitag.getAccelData().x);
 //console.log(Ruuvitag.getAccelData());
  LED1.write(on);
}, 1000);



function rotation(){
x[i] = Ruuvitag.getAccelData().x;
y[i] = Ruuvitag.getAccelData().y;
z[i] = Ruuvitag.getAccelData().z;
//console.log(Ruuvitag.getAccelData());

  
var xAvg =0;
var yAvg =0;
var zAvg =0;
if(x.length>2){
  console.log(i);
 xAvg = avrage(x);
 yAvg = avrage(y);
 zAvg = avrage(z);
}

if(( 30 < xAvg < 90) && ( 45<yAvg<105) && (980<zAvg<1040) ){
  wall = 'jestem na scianie 1';
}
if(( (-670) <xAvg< (-610)) && ((-755)<yAvg<(-695)) && (55<zAvg<115) ){
  wall = 'jestem na scianie 2';
}
console.log(wall, xAvg, yAvg, zAvg);
  
if(i == 9){i=0;}
i++;
}

function avrage(arr){
// console.log(arr);
    var sum = 0;
  for (step =0; step< arr.length; step++){
   sum +=  arr[step];
//    console.log(sum);
      }
  sum -=  (Math.max.apply(null,arr)+ Math.min.apply(null,arr));
  return sum/(arr.length-2);
}