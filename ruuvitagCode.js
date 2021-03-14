var Ruuvitag = require("Ruuvitag");

var debug=false;
var currentWall=0;

function checkOrientation() {
  var acc = Ruuvitag.getAccelData();

  var x = acc.x;
  var y = acc.y;
  var z = acc.z;
  var wall;


  var xAbs = Math.abs(x);
  var yAbs = Math.abs(y);
  var zAbs = Math.abs(z);

  var max = Math.max(xAbs, yAbs, zAbs);

  if (max === xAbs) {
    if (x > 0) {
      wall = 6;
    } else {
      wall = 5;
    }
  } else if (max === yAbs) {
    if (y > 0) {
      wall = 4;
    } else {
      wall = 2;
    }
  } else if (max === zAbs) {
    if (z > 0) {
      wall = 1;
    } else {
      wall = 3;
    }
  }


  if ((currentWall != wall)) {
    currentWall = wall;
    sendUpdate();// wyślij notyfikację natychmiast gdy strona się zmieniła
  }


}


var calcInterval; // interwał w którym liczona jest strona kostki  - 100ms
function runCalcLoop() { //
  calcInterval = setInterval(function () {
    checkOrientation();
  }, 100);
}

function sendUpdate() { // update serwisu - notyfikacja
  console.log('Wysyłam notyfikację ' + currentWall);
  NRF.updateServices({
    "3e440001-f5bb-357d-719d-179272e4d4d9": {
      "3e440002-f5bb-357d-719d-179272e4d4d9": {
        value: [currentWall],
        notify: true,
      }
    }
  });
}

var updateInterval; // interwał w którym wysyłana jest notyfikacja - 1s
function runUpdateLoop() { // wysyłaj notyfikacje w pętli, nawet gdy strona sie nie zmieniła
  updateInterval = setInterval(function () {
    sendUpdate();
    digitalPulse(LED2, 1, 50); // mrugaj

  }, 1000);
}

function setService() { // tryb pracy
  NRF.setServices({
    "3e440001-f5bb-357d-719d-179272e4d4d9": { //serwis
      "3e440002-f5bb-357d-719d-179272e4d4d9": { //charakterystyka
        description: "KOSTKA",
        value: [currentWall],
        length: 1,
        readable: true,
        notify: true,  //notyfikacja
      }
    }
  }, {uart: true});
}


function onInit() { // wywoluje sie na starcie
  Ruuvitag.setAccelOn(true); // włącz akcelerometr
  Ruuvitag.setEnvOn(false); // wyłącz termometr, higrometr  etc
  setService(); // utwórz serwis
  runCalcLoop(); // sprawdzaj orientację w pętli
  runUpdateLoop(); // wysyłaj notyfikację w pętli, wolniej
}


// dioda mruga jeśli rozłączono
NRF.on('disconnect', function () {
  digitalPulse(LED1, 1, 100);
});

// dioda mruga jeśli połączono
NRF.on('connect', function (addr) {
  digitalPulse(LED2, 1, [100, 50, 100, 50, 100]);
});

