//95 colorChanged boolean name change fixed webpage bug
//the original variable had the same name as a function in that class

//webpage doesnt work
//prints hi only once?

//maybe let user choose if they want to play freestyle or ultimate

//if you want to work on this bug go to normal tic tac toe
//still think theres another solution other than line 69
//i dont want to delay everytime after user pressed a tile
//the bug was that the middle tile was being activated after user pressed play again and the game restarted

// Diagram 1
// ---------
// |0|1|2|
// |3|4|5|
// |6|7|8|

// width of each tile is 200
// height of each tile is 200
// size of display is 600 by 600


// Diagram 2
// ---------
// int[] values = {v1, v2, v3, h1, h2, h3, d1, d2}; 
// v is vertical
// h is horizontal
// d is diagonal

double debugFrameCount;
boolean debug = false; //for bug that made tile in middle get marked after user pressed play again 
Game game = new Game();
BigTile bigTile;
BigTile bigTile2;
BigTile[] bigTiles = new BigTile[9];


Tile[] tiles = new Tile[9];
void setup() {
  size(900, 900);
  textAlign(CENTER, CENTER);
  textSize(100);
  noStroke();

  for (int i = 0; i < bigTiles.length; i++) {
    int j = i;
    if (i > 2) { //refer to diagram 1
      j = i-3;
      if (i > 5) {
        j = i-6;
      }
    }

    int x = j*300; //300 is width of a "BigTile" object (each are made out of three smaller 100x100 tiles)
    int y = 0; 

    if (i > 2) { //refer to diagram 1
      y = 300;
      if (i > 5) {
        y = 600;
      }
    }
    bigTiles[i] = new BigTile(x,y,i);
  }
}

void draw() {
  background(210);
  // bigTile.run();
  // bigTile2.run();
  for (BigTile biggie : bigTiles) {
      biggie.run();
  }

  stroke(80);
  strokeWeight(5);
  line(300,0,300,height);
  line(600,0,600,height);
  line(0,300,width,300);
  line(0,600,width,600);
  noStroke();

  game.run();
}

class Tile {
  int id; //for id to play on
  int id2;
  int x, y;
  int w = 100;
  int h = 100;
  int value = 0;
  boolean marked = false;
  boolean colorChanged = false;
  color c = color(game.unmarkedColor);

  Tile(int x, int y, int id, int id2) {
    this.x = x;
    this.y = y;
    this.id = id;
    this.id2 = id2;
  }

  void display() {
    fill(c);
    // fill(random(256));
    rect(x, y, w, h);
  }

  Boolean hasColorChanged() {
    if (colorChanged) {
      colorChanged = false;
      return true;
    } else {
      return false;
    }
  }

  void unavailableColor() {
    if (c == game.unmarkedColor) {
      c = game.unavailableColor;
    } else if (c == game.player1Color) {
      c = game.player1UnavailableColor;
    } else if (c == game.player2Color) {
      c = game.player2UnavailableColor;
    }
  }

  void availableColor() {
    if (c == game.unavailableColor) { //changes from unavailable color to regular color
      c = game.unmarkedColor;
    } else if (c == game.player1UnavailableColor) {
      c = game.player1Color;
    } else if (c == game.player2UnavailableColor) {
      c = game.player2Color;
    }
  }

  void changeColor() {
    availableColor();
    if (!marked && game.winner == 0) {
      c = game.unmarkedColor;
      if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) { //if cursor is inside tile
        if (game.playerTurn == 1) {
          if (mousePressed) {
            game.numTurns++;
            c = game.player1Color;
            marked = true;
            game.playerTurn = 2;
            value = game.player1Value;
            colorChanged = true;
            game.goAnywhere = false;
          } else {
            c = game.player1PreviewColor;
          }
        } else if (game.playerTurn == 2) {
          if (mousePressed) {
            game.numTurns++;
            c = game.player2Color;
            marked = true;
            game.playerTurn = 1;
            value = game.player2Value;
            colorChanged = true;
            game.goAnywhere = false;
            } else {
              c = game.player2PreviewColor;
            }
        } else {
          c = game.unmarkedColor;
        }
      }
    }
  }
}

class Game {
  int numTurns = 0;

  color player1Color = color(250, 50, 20, 235);
  color player1UnavailableColor = color(150, 50, 20, 235);
  color player1PreviewColor = color(250, 50, 20, 135);

  color player2Color = color(20, 50, 250, 235);
  color player2UnavailableColor = color(20, 50, 150, 235);
  color player2PreviewColor = color(20, 50, 250, 135);

  // color player1Color = color(255, 97, 56);
  // color player1UnavailableColor = color(155, 97, 56);
  // color player1PreviewColor = color(255, 197, 88);

  // color player2Color = color(0, 163, 136);
  // color player2UnavailableColor = color(0, 133, 106);
  // color player2PreviewColor = color(121, 189, 144);

  color unmarkedColor = color(100);
  color unavailableColor = color(50);

  int playerTurn = 1;
  int player1Value = 1;
  int player2Value = -1;
  int tieValue = -5;
  int winner = 0;
  int idToPlayOn;
  boolean goAnywhere = true;

  int[] values = new int[8];

  Game() {}


  void checkForGoAnywhere() {
    for (BigTile big : bigTiles) {
      if (big.numMarked == 9 || big.winner != 0 && idToPlayOn == big.id) {
        goAnywhere = true;
      }
    }
  }

  void getValues() {
    values[0] = bigTiles[0].winner + bigTiles[3].winner + bigTiles[6].winner; //refer to diagram 2
    values[1] = bigTiles[1].winner + bigTiles[4].winner + bigTiles[7].winner;
    values[2] = bigTiles[2].winner + bigTiles[5].winner + bigTiles[8].winner;
    values[3] = bigTiles[0].winner + bigTiles[1].winner + bigTiles[2].winner;
    values[4] = bigTiles[3].winner + bigTiles[4].winner + bigTiles[5].winner;
    values[5] = bigTiles[6].winner + bigTiles[7].winner + bigTiles[8].winner;
    values[6] = bigTiles[0].winner + bigTiles[4].winner + bigTiles[8].winner;
    values[7] = bigTiles[2].winner + bigTiles[4].winner + bigTiles[6].winner;
    //values = {v1, v2, v3, h1, h2, h3, d1, d2};
  }

  void determineWin() { //determines winner
    for (int i = 0; i < values.length; i++) {
      if (values[i] == player1Value*3) {
        winner = player1Value;
      } else if (values[i] == player2Value*3) {
        winner = player2Value;
      }
    }
    int markedTiles = 0;
    for (BigTile big : bigTiles) {
      for (Tile small : big.tiles) {
        if (small.marked) {
          markedTiles++;
        }
      }
    }
    if (markedTiles == 81) {
      winner = tieValue;
    }
  }

  void alert(int winner) { //gui for play again
    playerTurn = 0;
    fill(210);
    if (winner == player1Value) {
      textSize(100);
      text("Red Wins!", width/2, height/2-50);
      if (mouseX > 320 && mouseX < 575 && mouseY < 535 && mouseY > 480) {
        fill(150);
        if (mousePressed) {
          restartGame();
        }
      }
      textSize(50);
      text("Play Again", width/2, height/2+50);
    } else if (winner == player2Value) {
      textSize(100);
      text("Blue Wins!", width/2, height/2-50);
      if (mouseX > 320 && mouseX < 575 && mouseY < 535 && mouseY > 480) {
        fill(150);
        if (mousePressed) {
          restartGame();
        }
      }
      textSize(50);
      text("Play Again", width/2, height/2+50);
    } else if (winner == tieValue) {
      textSize(100);
      text("Tie!", width/2, height/2-50);
      if (mouseX > 320 && mouseX < 575 && mouseY < 535 && mouseY > 480) {
        fill(150);
        if (mousePressed) {
          restartGame();
        }
      }
      textSize(50);
      text("Play Again", width/2, height/2+50);
    }
    for (BigTile big : bigTiles) {
      for (Tile small : big.tiles) {
        small.availableColor();
      }
    }
  }

  void run() {
    if (winner != 0) {
      alert(winner);
    } else {
      getValues();
      determineWin();
      checkForGoAnywhere();
    }
  }
}

void restartGame() { //resets everything
  game = new Game();
  bigTiles = new BigTile[9];

  for (int i = 0; i < bigTiles.length; i++) {
    int j = i;
    if (i > 2) { //refer to diagram 1
      j = i-3;
      if (i > 5) {
        j = i-6;
      }
    }

    int x = j*300; //300 is width of a "BigTile" object (each are made out of three smaller 100x100 tiles)
    int y = 0; 

    if (i > 2) { //refer to diagram 1
      y = 300;
      if (i > 5) {
        y = 600;
      }
    }
    bigTiles[i] = new BigTile(x,y,i);
  }
  game.goAnywhere = true;
  debug = true;
  debugFrameCount = frameCount;
}

class BigTile {
  int numMarked;
  int id;
  int winner = 0;
  Tile[] tiles = new Tile[9];
  int[] values = new int[8];

  BigTile(int x, int y, int id) {
    this.id = id;
    for (int i = 0; i < tiles.length; i++) {
      int j = i;

      if (i > 2) { //refer to diagram 1
        j = i-3;
        if (i > 5) {
          j = i-6;
        }
      }
  
      int xPos = j*100+x; //100 is width of "Tile" object
      int yPos = 0+y;

      if (i > 2) { //refer to diagram 1
        yPos = 100+y;
        if (i > 5) {
          yPos = 200+y;
        }
      }
  
      tiles[i] = new Tile(xPos, yPos, i, id);
    }
  }

  void display() {
    for (Tile tile : tiles) {
      tile.display();
    }
  }

  void changeColor() {
    for (Tile tile : tiles) {
      tile.changeColor();
    }
  }

  void getValues() {
    values[0] = tiles[0].value + tiles[3].value + tiles[6].value; //refer to diagram 2
    values[1] = tiles[1].value + tiles[4].value + tiles[7].value;
    values[2] = tiles[2].value + tiles[5].value + tiles[8].value;

    values[3] = tiles[0].value + tiles[1].value + tiles[2].value;
    values[4] = tiles[3].value + tiles[4].value + tiles[5].value;
    values[5] = tiles[6].value + tiles[7].value + tiles[8].value;

    values[6] = tiles[0].value + tiles[4].value + tiles[8].value;
    values[7] = tiles[2].value + tiles[4].value + tiles[6].value;
  }

  void determineWin() { //determines winner of big tile
    for (int i = 0; i < values.length; i++) {
      if (values[i] == game.player1Value*3) {
        winner = game.player1Value;
      } else if (values[i] == game.player2Value*3) {
        winner = game.player2Value;
      }
    }
    if (winner == game.player1Value) {
      for (Tile tile : tiles) {
        tile.c = game.player1Color;
        tile.marked = true;
      }
    } else if (winner == game.player2Value) {
      for (Tile tile : tiles) {
        tile.c = game.player2Color;
        tile.marked = true;
      }
    }
  }

  void run() {
    display();
    if (winner == 0 && game.idToPlayOn == id) { //play on id
      if (debug && frameCount > debugFrameCount + 15) {
        changeColor();
      } else if (!debug) {
        changeColor();
      }
      for (Tile small : tiles) {
        if (small.hasColorChanged()) {
          game.idToPlayOn = small.id; //set id to play on to the small tile's id
          numMarked++;
        }
      }
      getValues();
      determineWin();
    } else if (game.goAnywhere) {
      if (debug && frameCount > debugFrameCount + 15) {
        changeColor();
      } else if (!debug) {
        changeColor();
      }
      for (Tile small : tiles) {
        if (small.hasColorChanged()) {
          game.idToPlayOn = small.id; //set id to play on to the small tile's id
          numMarked++;
        }
      }
      getValues();
      determineWin();
    } else if (game.idToPlayOn != id) {
      for (Tile small : tiles) {
        small.unavailableColor();
      }
    }
  }
}

void keyPressed() {
  if (key == 'r') {
    restartGame();
  }
}