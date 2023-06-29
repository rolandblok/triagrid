

import java.util.*;
import java.nio.file.Path;
import java.nio.file.Paths;
 



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

Vector<PVector> point_star_offsets = new Vector<PVector>();

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
  
  point_star_offsets.add(new PVector( 1,    0).mult(10));
  point_star_offsets.add(new PVector( 0.5,  1).mult(10));
  point_star_offsets.add(new PVector(-0.5,  1).mult(10));
  point_star_offsets.add(new PVector(-1,    0).mult(10));
  point_star_offsets.add(new PVector(-0.5, -1).mult(10));
  point_star_offsets.add(new PVector( 0.5, -1).mult(10));

}


void setup() {
  size(1800, 1200);
  surface.setTitle(plot_name);
  
  Locale.setDefault(Locale.US);
  
  draw_fill = true;
  draw_lines = true;
  draw_grid = true;
  
  my_pitch = new MyPitch(30);
  createGrid();
  drawables = new Vector<MyElement>();

  myInterFaceSetup();

  
}

void draw() {
  background(255, 255, 255);
  noFill();
  stroke(0, 0, 0);


  
  if (closest_point != null) {
      closest_point.draw(color(0, 255, 0), 1);
      stroke(color(155,255,155));
      PVector p = closest_point.p.copy();
      for (PVector pso : point_star_offsets){
        PVector p2 = PVector.add(p, pso);
        PVector ps = my_pitch.G2S(p);
        PVector p2s = my_pitch.G2S(p2);
        line(ps.x, ps.y, p2s.x, p2s.y);
      }
  }

  if (possible_new_element != null) {
    possible_new_element.draw(color(200,0, 0), 0.5);
  }
  
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
  
}
