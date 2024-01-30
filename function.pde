void drawField(boolean reset) {
  if (reset) {
    background(255, 255, 255);
  }
  float x = (width - 10500/shrink*scale)/2;
  float y = (height - 6800/shrink*scale)/2;
  fill(0);
  noFill();
  ellipse(width/2, height/2, 1830/shrink*scale, 1830/shrink*scale);
  rect(x, y, 10500/shrink*scale, 6800/shrink*scale);
  line(width/2, y, width/2, y+6800/shrink*scale);
}

void drawPlayer(int X, int Y, color col) {
  fill(col);
  push();
  translate(width/2, height/2);

  ellipse(int(X*scale), int(Y*scale), 30, 30);

  pop();
}

void drawBall(int X, int Y, color col) {
  fill(col);

  push();
  translate(width/2, height/2);
  ellipse(int(X*scale), int(Y*scale), 15, 15);

  pop();
}

void drawCircle(int x1, int y1, int x2, int y2) {
  //fill(col);

  float Dist = dist(x1, y1, x2, y2);
  int dia = int((Dist/2200)*400);
  noFill();

  push();
  translate(width/2, height/2);
  ellipse(x1*scale, y1*scale, dia*scale, dia*scale);
  pop();
}

int[][] getCombinations(int len) {
  int numCombinations = len * (len - 1) * (len -2) / 6; // 組み合わせの数を計算

  int[] data = new int[numCombinations];
  for (int i = 0; i < len; i++) {
    data[i] = i;
  }

  // 組み合わせを格納する配列を作成
  int[][] combinations = new int[numCombinations][3];

  int index = 0;
  for (int i = 0; i < len - 2; i++) {
    for (int j = i + 1; j < len - 1; j++) {
      for (int k = j + 1; k < len; k++) {
        combinations[index][0] = data[i];
        combinations[index][1] = data[j];
        combinations[index][2] = data[k];
        //println(data[i], data[j], data[k]);
        index++;
      }
    }
  }
  return combinations;
}
void Line(int[]x, int[]y) {
  float [][] points = new float[11][2];
  for (int i = 0; i < x.length; i++) {
    points[i][0] = x[i];
    points[i][1] = y[i];
  }

  Delaunay myDelaunay = new Delaunay(points);
  int[][] myLinks = myDelaunay.getLinks();
  for (int i=0; i<myLinks.length; i++) {
    int startIndex = myLinks[i][0];
    int endIndex = myLinks[i][1];

    float startX = points[startIndex][0];
    float startY = points[startIndex][1];
    float endX = points[endIndex][0];
    float endY = points[endIndex][1];

    if (startX != endX && startX != 0 && startY != 0 && endX != 0 && endY != 0) {
      line.startX[i] = int(startX);
      line.startY[i] = int(startY);
      line.endX[i] = int(endX);
      line.endY[i] = int(endY);
    }
    push();
    translate(width/2, height/2);
    stroke(125, 125, 125);
    //line( startX*scale, startY*scale, endX*scale, endY*scale );

    pop();
  }
}

void buildTree(TreeNode node, int x, int y, int sx[], int sy[], int ex[], int ey[], int[] enemyX, int[]enemyY, int maxDepth) {
  if (node.depth < maxDepth) {
    for (int i = 0; i < sx.length; i++) {

      if (x==sx[i]) {
        if (checkEnemy(sx[i],sy[i],ex[i], ey[i], enemyX, enemyY) == false) {

          //int Dist = int(dist(x, y, ex[i], ey[i]));
          int Dist = int(abs(x-ex[i]));
          int Key = getNode(x, ex[i], Dist, node.Key);

          TreeNode child = new TreeNode(ex[i], ey[i], Key, node.depth + 1);
          node.addChild(child);
          buildTree(child, ex[i], ey[i], sx, sy, ex, ey, enemyX, enemyY, maxDepth); // 子ノードに対して再帰的にツリーを構築
        }
      }
      if (x==ex[i]) {
        if (checkEnemy(ex[i], ey[i],sx[i], sy[i], enemyX, enemyY) == false) {

          //int Dist = int(dist(x, y, ex[i], ey[i]));
          int Dist = int(abs(x-sx[i]));
          int Key = getNode(x, sx[i], Dist, node.Key);

          TreeNode child = new TreeNode(sx[i], sy[i], Key, node.depth + 1);
          node.addChild(child);
          buildTree(child, sx[i], sy[i], sx, sy, ex, ey, enemyX, enemyY, maxDepth); // 子ノードに対して再帰的にツリーを構築
        }
      }
    }
  }
}

void drawTree(TreeNode node) {
  for (TreeNode child : node.children) {

    // 親ノードから子ノードへの線を描画
    push();
    translate(width/2, height/2);
    line(node.x*1.5, node.y*1.5, child.x*1.5, child.y*1.5);
    //println(node.Key+">>>>>"+child.Key);

    pop();

    //println(Dist+",");

    //println(node.x*1.5, node.y*1.5, child.x*1.5, child.y*1.5);
    // 再帰的に子ノードを描画
    drawTree(child);
  }
}

void soundTreeDFS(TreeNode node) {

  soundOn(node.Key, node.Key*50);
  println(node.Key);
  soundOff(node.Key, 0);


  for (TreeNode child : node.children) {
    soundTreeDFS(child);
  }
}


int getBallHolder(int x, int y, int X[], int Y[]) {
  boolean found = false;
  int count = 0;
  while (found == false && count < X.length) {
    if (x==X[count] && y==Y[count]) {
      found = true;
    }
    count++;
  }
  if (count < X.length) {
    return count-1;
  } else {
    return 100;
  }
}

int countDirectChildren(TreeNode parent) {
  if (parent == null) {
    return 0;
  }
  return parent.children.size(); // 直接の子ノードの数を返す
}


boolean checkEnemy(int bx,int by,int x, int y, int[]X, int[]Y) {
  boolean enemy = false;
  int count = 0;

  while (enemy == false && count < X.length) {
    float Dist = dist(x, y, X[count], Y[count]);
    float BallDist = dist(bx, by, X[count], Y[count]);
    int meter = int((BallDist/220)*40)*2;
    if (Dist < meter) {
      enemy = true;
    }
    count++;
  }
  return enemy;
}

void getFastPlayer(int bx, int by, int px, int py, float speed) {
  float Dist = dist(bx, by, px, py);
  int path = 100;
  int fast = 18;
  if (Dist > path && speed > fast) {
    color col= color(255, 255, 0);
    drawPlayer(px, py, col);
    
    push();
    translate(width/2, height/2);
    stroke(128);
    line(bx*scale, by*scale, px*scale, py*scale); 
    pop();
    int d;
    if (speed<20) {
      d = 5;
    } else if (speed<25) {
      d = 2;
    } else {
      d = 1;
    }
    if (i%d==0) {
      int Key = getStartNode(game.ball.x[i]) + int(Dist/20);
      soundOn(Key, 0);
      soundOff(Key, 0);
    }
  }
}
void keyPressed() {
  if (key == UP) {
    i++;
  } else if (key == DOWN) {
    i--;
  }
}

int getStartNode(int x) {
  int node = 0;
  int X = -525;

  while (x > X) {
    node += 1;
    X += 150;
  }

  return node;
}

int getNode(int start, int goal, int Dist, int baseKey) {
  int Key = baseKey;
  if (start < goal) {
    Key += Dist/50;
  }
  if (start > goal) {
    if (Key-Dist/50 < 0) {
      Key = 0;
    } else {
      Key -= Dist/50;
    }
  }
  return Key;
}



void soundOn(int key, int delay) {
  int sound[] = new int[60];
  for (int i = 0; i < 60; i++) {
    sound[i] = i+1;
  }
  println(key);
  midiSender.sendNoteOnDelayed(0, 0, notenums[sound[key]], 100, delay);
  isNowOn[sound[key]] = true;
}

void soundOff(int key, int delay) {
  midiSender.sendNoteOffDelayed(0, 0, notenums[key], 100, delay);
  isNowOn[key] = false;
}
