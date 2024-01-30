import megamu.mesh.*;

import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;

import jp.crestmuse.cmx.amusaj.sp.*;
import jp.crestmuse.cmx.processing.*;

import java.util.ArrayList;

CMXController cmx = CMXController.getInstance();
MidiEventSender midiSender;

boolean[] isNowOn = new boolean[65536];
int[] notenums = new int[65536];


String[] lines; // csvファイルの各行を格納するための文字列型配列

Game game;
Triangle tri;
Line line;
TreeNode root; // ルートノード


int shrink = 10;
float scale = 1.5;

int numRows; // csvファイルの行数
int numCols; // csvファイルの列数

color SAN_col = color(155, 114, 176);
color ANT_col = color(162, 32, 65);
color Ball_col = color(0, 0, 0);

boolean existBall = false;

int count = 0;

void setup() {
  //size(1150, 780);
  frameRate(25);
  //frameRate(15);
  size(1725, 1170);
  background(255);

  int octave =0;
  for (int i = 0; i < 6; i++) {
    notenums[1+7*i] = 60 + 12 * i - octave*12;
    notenums[2+7*i] = 62 + 12 * i - octave*12;
    notenums[3+7*i] = 64 + 12 * i - octave*12;
    notenums[4+7*i] = 65 + 12 * i - octave*12;
    notenums[5+7*i] = 67 + 12 * i - octave*12;
    notenums[6+7*i] = 69 + 12 * i - octave*12;
    notenums[7+7*i] = 71 + 12 * i - octave*12;
  }



  midiSender = new MidiEventSender();
  MidiOutputModule midiout = cmx.createMidiOut();
  cmx.addSPModule(midiSender);
  cmx.addSPModule(midiout);
  cmx.connect(midiSender, 0, midiout, 0);
  cmx.startSP();

  
   lines = loadStrings("ここにトラッキングデータを置く");


  // csvファイルの行数と列数を取得する
  numRows = lines.length;
  //numRows = 1048575;
  String[] colHeaders = split(lines[0], ',');
  numCols = colHeaders.length;

  //sc = new Soccer();
  game = new Game();
  tri = new Triangle();
  line = new Line();
  //tri = new Triangle();



  for (int i = 0; i < 11; i++) {
    game.team1.pl[i] = new Player(i);
    game.team2.pl[i] = new Player(i);
  }


  int time, team, number, x, y;
  int time_next;
  float speed;

  int H_count = 0;
  int A_count = 0;


  for (int i = 1; i < numRows-1; i++) {
    String[] values = split(lines[i], ','); 
    time = int(values[1]);
    team = int(values[2]);
    number = int(values[4]);
    x = int(values[5]);
    y = int(values[6]);
    speed = float(values[7]);

    String[] values_next = split(lines[i+1], ','); 
    time_next = int(values_next[1]);

    if (team == 1) {
      game.team1.pl[H_count].number = number;
      game.team1.pl[H_count].time[count] = time;
      game.team1.pl[H_count].x[count] = x/10;
      game.team1.pl[H_count].y[count] = -y/10;
      game.team1.pl[H_count].speed[count] = speed;

      H_count += 1;
    } else if (team == 2) {
      game.team2.pl[A_count].number = number;
      game.team2.pl[A_count].time[count] = time;
      game.team2.pl[A_count].x[count] = x/10;
      game.team2.pl[A_count].y[count] = -y/10;
      game.team2.pl[A_count].speed[count] = speed;
      A_count += 1;
    } else if (team == 0) {
      game.ball.time[count] = time;
      game.ball.x[count] = x/10;
      game.ball.y[count] = -y/10;
      game.ball.speed[count] = speed;
    }
    if (time != time_next) {
      count++; 
      A_count = 0;
      H_count = 0;
    }
  }
}


int i = 749;
//試合開始時刻

boolean ball;

void draw() {
  background(255);
  ball = false;


  if (keyPressed) {
    if (keyCode == UP) {
      i += 10;
    } else if (keyCode == DOWN) {
      i -=10;
    } else if (keyCode == RIGHT) {
      i += 25 * 60;
    } else if (keyCode == LEFT) {
      i -= 25 * 60;
    }
  }
  drawField(true);

  int time_count = i - 30*25;


  int minute = time_count/25/60;
  int second = time_count/25%60;
  textSize(20);
  text(minute+":"+ second, 50, 45);

  int[] timeHX = new int[11];
  int[] timeHY = new int[11];
  int[] timeAX = new int[11];
  int[] timeAY = new int[11];
  for (int t = 0; t < 11; t++) {

    //print(game.team1.pl[t].x[i]+" ");

    if (game.ball.x[i] == 0 && game.ball.y[i] == 0) {
      drawPlayer(game.team1.pl[t].x[i], game.team1.pl[t].y[i], SAN_col);
      drawPlayer(game.team2.pl[t].x[i], game.team2.pl[t].y[i], ANT_col);

      timeHX[t] = game.team1.pl[t].x[i];
      timeHY[t] = game.team1.pl[t].y[i];
      timeAX[t] = game.team2.pl[t].x[i];
      timeAY[t] = game.team2.pl[t].y[i];

      /*
      tri.points[t][0] = game.team1.pl[t].x[i];
       tri.points[t][1] = game.team1.pl[t].y[i];
       */

      game.ball.inPlay = false;
    } else {  
      drawPlayer(game.team1.pl[t].x[i], game.team1.pl[t].y[i], SAN_col);
      drawPlayer(game.team2.pl[t].x[i], game.team2.pl[t].y[i], ANT_col);
      drawBall(game.ball.x[i], game.ball.y[i], Ball_col);



      timeHX[t] = game.team1.pl[t].x[i];
      timeHY[t] = game.team1.pl[t].y[i];
      timeAX[t] = game.team2.pl[t].x[i];
      timeAY[t] = game.team2.pl[t].y[i];


      if (game.team1.pl[t].x[i] == game.ball.x[i] && game.team1.pl[t].x[i-1] != game.ball.x[i-1]) {
        ball = true;
      }


      game.ball.inPlay = true;
    }
  }
  int maxDepth =3; // 木の深さを指定


  //tri.draw(i, timeAX, timeAY, game.ball.x[i], game.ball.y[i]);


  if (game.ball.x[i] != 0 && game.ball.y[i] != 0) {
    Line(timeHX, timeHY);

    int num = getBallHolder(game.ball.x[i], game.ball.y[i], line.startX, line.startY);
    int Key = getStartNode(game.ball.x[i]);

    if (i%10 == 0 && game.ball.inPlay) {
      soundOn(Key, 0);
      soundOff(Key, 0);
    }
    if (num!=100) {
      // ルートノードを作成

      root = new TreeNode(line.startX[num], line.startY[num], Key, 0);

      // ツリーを再帰的に構築
      buildTree(root, game.ball.x[i], game.ball.y[i], line.startX, line.startY, line.endX, line.endY, timeAX, timeAY, maxDepth);
      drawTree(root);

      for(int t = 0; t < 11;t++){
        getFastPlayer(game.ball.x[i], game.ball.y[i],game.team1.pl[t].x[i],game.team1.pl[t].y[i],game.team1.pl[t].speed[i]); 
      }


      if (ball) {
        soundTreeDFS(root);
      }
    }
  }
  println("**********************************************");
  i++;
}
