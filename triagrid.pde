
import uibooster.*;

import java.util.*;
import java.nio.file.Path;
import java.nio.file.Paths;
 


//https://milchreis.github.io/uibooster-for-processing/reference/uibooster/UiBooster.html
UiBooster booster;


boolean draw_fill;
boolean draw_lines;
boolean draw_grid;


int X_GRID = 150;
int Y_GRID = 150;
Vector<MyPoint> grid;
Vector<MyElement> drawables;

String plot_name = "triagrid";

MyPoint closest_point = null;
MyElement possible_new_element = null;


MyPitch my_pitch;

void createGrid() {
  println("createGrid");
  grid = new Vector<MyPoint>();

  for (int y = 0;  y < Y_GRID; y++) {
    float offset = 0;
    if ((y%2) == 1) {
      offset = 0.5;
    } 
    for (int x =0;  x < X_GRID; x++) {
      MyPoint v = new MyPoint(x+offset, y);
      grid.add(v);
    }
  }

}


void setup() {
  size(1400, 1400);
  surface.setTitle(plot_name);
  
  Locale.setDefault(Locale.US);
  
  draw_fill = true;
  draw_lines = true;
  draw_grid = true;
  
  my_pitch = new MyPitch(30);
  createGrid();
  drawables = new Vector<MyElement>();

  booster = new UiBooster();
  
}

void draw() {
  background(255, 255, 255);
  noFill();
  stroke(0, 0, 0);
  if (draw_grid) {
    for (MyElement gp : grid) {
      gp.draw();
    }
  }
  
  for (MyElement e : drawables) {
    if ((e instanceof MyTriangle) && draw_fill) {
      e.draw();
    }
    if ((e instanceof MyLine) && draw_lines) {
      e.draw();
    }
  }

  
  if (closest_point != null) {
      closest_point.draw(color(0, 255, 0), 1);
  }

  if (possible_new_element != null) {
    possible_new_element.draw(color(200,0, 0), 0.5);
  }
}
