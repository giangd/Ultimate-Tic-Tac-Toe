//fix red tile and gui
//fix blue cant win


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
boolean debug = false; //for dumb bug that made tile in middle get marked after user pressed play again 
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
  game.winner = 1;

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
    bigTiles[i] = new BigTile(x,y);
  }

  // for (int i = 0; i < tiles.length; i++) {
  //   int j = i;
  //   if (i > 2) { //refer to diagram 1
  //     j = i-3;
  //     if (i > 5) {
  //       j = i-6;
  //     }
  //   }

  //   int x = j*200; //200 is width of "Tile" object

  //   int y = 0;
  //   if (i > 2) { //refer to diagram 1
  //     y = 200;
  //     if (i > 5) {
  //       y = 400;
  //     }
  //   }

  //   tiles[i] = new Tile(x, y);
  // }
}

void draw() {
  println(mouseX,mouseY);
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

// void draw() {
//   background(210);
//   if (game.numTurns == 9 && game.winner == 0) { //for tie
//     for (int i = 0; i < tiles.length; i++) {
//       tiles[i].display();
//     }
//     game.alert(0);
//   } else if (game.winner != 0) { //if there is a winner
//     for (int i = 0; i < tiles.length; i++) {
//       tiles[i].display();
//     }
//     game.alert(game.winner);
//   } else if (game.winner == 0 && frameCount > debugFrameCount+10) { //delays after every click but there is a better way, check commented draw(){} below
//     for (int i = 0; i < tiles.length; i++) {
//       tiles[i].display();
//       tiles[i].changeColor();
//     }
//     game.getValues();
//     game.determineWin();
//   }
// }

// void draw() {
//   background(210);
//   if (game.winner == 1) {
//     for (int i = 0; i < tiles.length; i++) {
//       tiles[i].display();
//     }
//     game.alert(game.winner);
//   } else if (game.winner == 2) {
//     for (int i = 0; i < tiles.length; i++) {
//       tiles[i].display();
//     }
//     game.alert(game.winner);
//   } else if (game.winner == 0 && debug) { //for debug info check debugFrameCount comment
//     if (frameCount > debugFrameCount+10) {
//       for (int i = 0; i < tiles.length; i++) {
//         tiles[i].display();
//         tiles[i].changeColor();
//       }
//       game.getValues();
//       game.determineWin();
//     }
//     debug = false;
//   } else if (game.winner == 0) {
//     for (int i = 0; i < tiles.length; i++) {
//       tiles[i].display();
//       tiles[i].changeColor();
//     }
//     game.getValues();
//     game.determineWin();
//   }

// }

class Tile {
  int x, y;
  int w = 100;
  int h = 100;
  int value = 0;
  boolean marked = false;
  color c = color(game.unmarkedColor);

  Tile(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    fill(c);
    // fill(random(256));
    rect(x, y, w, h);
  }

  void changeColor() {
    // println(frameCount);
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
  color player1PreviewColor = color(250, 50, 20, 135);

  color player2Color = color(20, 50, 250, 235);
  color player2PreviewColor = color(20, 50, 250, 135);

  color unmarkedColor = color(100);

  int playerTurn = 1;
  int player1Value = 1;
  int player2Value = -1;
  int winner = 0;

  int[] values = new int[8];

  Game() {}

  void getValues() {
    values[0] = bigTiles[0].winner + bigTiles[3].winner + bigTiles[6].winner; //refer to diagram 2
    values[1] = bigTiles[1].winner + bigTiles[4].winner + bigTiles[7].winner;
    values[2] = bigTiles[2].winner + bigTiles[5].winner + bigTiles[8].winner;
    values[3] = bigTiles[0].winner + bigTiles[1].winner + bigTiles[2].winner;
    values[4] = bigTiles[3].winner + bigTiles[4].winner + bigTiles[5].winner;
    values[5] = bigTiles[6].winner + bigTiles[7].winner + bigTiles[8].winner;
    values[6] = bigTiles[0].winner + bigTiles[4].winner + bigTiles[8].winner;
    values[7] = bigTiles[2].winner + bigTiles[4].winner + bigTiles[6].winner;
    // println(values);
    //values = {v1, v2, v3, h1, h2, h3, d1, d2};
  }

  void determineWin() { //determines winner
    for (int i = 0; i < values.length; i++) {
      if (values[i] == player1Value*3) {
        winner = 1;
        println("winner is red!!");
      } else if (values[i] == player2Value*3) {
        winner = 2;
        println("winner is blue!!");
      }
    }
  }

  void alert(int winner) { //gui for play again
    playerTurn = 0;
    fill(210);
    if (winner == 0) {
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
    } else if (winner == 1) {
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
    } else if (winner == 2) {
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
    }
  }

  void run() {
    if (winner != 0) {
      alert(winner);
    } else {
      getValues();
      determineWin();
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
    bigTiles[i] = new BigTile(x,y);
  }
  debug = true;
  debugFrameCount = frameCount;
}

class BigTile {
  int winner = 0;
  Tile[] tiles = new Tile[9];
  int[] values = new int[8];

  BigTile(int x, int y) {
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
  
      tiles[i] = new Tile(xPos, yPos);
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
      println("winner is red");
    } else if (winner == game.player2Value) {
      for (Tile tile : tiles) {
        tile.c = game.player2Color;
        tile.marked = true;
      }
      println("winner is blue");
    }
  }

  void run() {
    display();
    if (winner == 0) {
      if (debug && frameCount > debugFrameCount + 15) {
        changeColor();
      } else if (!debug) {
        changeColor();
      }
      getValues();
      determineWin();
    }
  }
}