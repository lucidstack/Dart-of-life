#import('dart:dom');
#source('Life.dart');
#resource('dartoflife.css');

class dartoflife {
  Life life;
  static final int SIZE = 600;
  static final String ORANGE = "orange";
  static final String BLACK = "black";
  static final String WHITE = "white";
  static final LINE_WIDTH = 3;
  
  HTMLDocument doc;
  CanvasRenderingContext2D drawer;
  HTMLCanvasElement canvas;
  HTMLButtonElement playButton;
  HTMLInputElement slider;
  HTMLInputElement xCoordInput;
  HTMLInputElement yCoordInput;
  bool playing = false;
  
  int squareDim;
  var xCoord = 0;
  var yCoord = 0;
  
  dartoflife() {
    
    doc = window.document;
    canvas = doc.getElementById("canvas");
    drawer = canvas.getContext("2d");
    drawer.setStrokeColor(ORANGE);
    slider = doc.getElementById("cellDimSlider"); 
    squareDim = Math.parseInt(slider.value);
    this.drawTable();
    playButton = doc.getElementById("button");
    xCoordInput = doc.getElementById("xCoord");
    yCoordInput = doc.getElementById("yCoord");
    this.initializeActions();
    
    life = new Life((SIZE/squareDim).floor().toInt());
    window.setInterval(_animate,200);
  }
  
  void _animate() {
    if(playing) {
      life.nextStep();
      for(var i=0; i < life.matrix.length; ++i)
        for(var j=0; j < life.matrix.length; ++j) {
         xCoord = i;
         yCoord = j;
         if(life.matrix[i][j] == 0)
           eraseSquare();
         else
           drawSquare();
      }
    }    
  }
  
  void initializeActions() {
    xCoordInput.addEventListener('change', (Event e) {
      eraseSquare();
      xCoord = Math.parseInt(xCoordInput.value);
      drawSquare();
    }, true);
    yCoordInput.addEventListener('change', (Event e) {
      eraseSquare();
      yCoord = Math.parseInt(yCoordInput.value);
      drawSquare();
    }, true);
    canvas.addEventListener('mousedown',_onMouseDown,false);
    slider.addEventListener('change', (Event e) {
      doc.getElementById('sliderValue').innerHTML = slider.value;
      squareDim = Math.parseInt(slider.value);
      drawTable();
    },false);
    playButton.addEventListener('mousedown', (Event e) {
      if(playButton.innerHTML == "Play!") {
        print("da s");
        playing = true;
        playButton.innerHTML = "Pause";        
      }
      else {
        playing = false;
        playButton.innerHTML = "Play!";
      }
    },false);
  }
  
  void _onMouseDown(MouseEvent e) {
    xCoord = (e.offsetX/squareDim).floor().toInt();
    yCoord = (e.offsetY/squareDim).floor().toInt();
    if(life.matrix[xCoord][yCoord] == 0) {
      drawSquare();
      life.matrix[xCoord][yCoord]++;      
    } else {
      eraseSquare();
      life.matrix[xCoord][yCoord]--;
    }
    xCoordInput.value = xCoord.toString();
    yCoordInput.value = yCoord.toString();
    print('X : $xCoord');
    print('Y : $yCoord');
  }
  
  void drawSquare() {
    drawer.beginPath();
    drawer.setLineWidth(LINE_WIDTH);
    drawer.setFillColor(ORANGE);
    drawer.rect(xCoord*squareDim,yCoord*squareDim,squareDim,squareDim);
    drawer.fill();
    drawer.closePath();
    drawer.stroke();
  }
  
  void eraseSquare() {
    drawer.beginPath();
    drawer.setLineWidth(LINE_WIDTH);
    drawer.setFillColor(BLACK);
    drawer.rect(xCoord*squareDim,yCoord*squareDim,squareDim,squareDim);
    drawer.fill();
    drawer.closePath();
    drawer.stroke();
  }
  
  void drawTable() {
    drawer.beginPath();
    drawer.setLineWidth(LINE_WIDTH);
    drawer.setFillColor(BLACK);
    for(int y = 0; y < SIZE; y+=squareDim)
      for(int x = 0; x < SIZE; x+=squareDim)
      drawer.rect(x,y,squareDim,squareDim);
    drawer.fill();
    drawer.closePath();
    drawer.stroke();
  }
  
}

void main() {
  new dartoflife();
}
