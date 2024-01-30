class Game {
  Team team1 = new Team();
  Team team2 = new Team();
  Ball ball = new Ball();
}

class Team {
  Player[] pl = new Player[11];
}

class Player {
  int number;
  int[] time;
  int[] x;
  int[] y;
  float[] speed;
  Player( int number_) {
    number = number_;
    time = new int[numRows];
    x = new int[numRows];
    y = new int[numRows];
    speed = new float[numRows];
  }
}


class Ball {
  boolean inPlay;
  int[] time;
  int[] x;
  int[] y;
  float[] speed;

  Ball() {
    time = new int[numRows];
    x = new int[numRows];
    y = new int[numRows];
    speed = new float[numRows];
  }
}

class Line {
  int[] startX;
  int[] startY;
  int[] endX;
  int[] endY;
  
  Line() {
    startX = new int[30];
    startY = new int[30];
    endX = new int[30];
    endY = new int[30];
  }
}

class Triangle {
  int[] x1;
  int[] x2;
  int[] x3;
  int[] y1;
  int[] y2;
  int[] y3;
  
  Triangle() {
    x1 = new int[20];
    x2 = new int[20];
    x3 = new int[20];
    y1 = new int[20];
    y2 = new int[20];
    y3 = new int[20];
  }
}

class TreeNode {
    float x;
    float y;
    int Key;
    ArrayList<TreeNode> children;
    int depth; // ノードの深さを示す

    TreeNode(float x, float y,int Key, int depth) {
        this.x = x;
        this.y = y;
        this.Key = Key;
        this.children = new ArrayList<TreeNode>();
        this.depth = depth;
    }

    void addChild(TreeNode child) {
        children.add(child);
    }
}
