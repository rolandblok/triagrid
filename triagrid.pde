import java.util.*;

int X_PIXS = 1400;
int Y_PIXS = 1400;
int X_PITCH = 100;
int Y_PITCH = 87;
int X_OFFSET = X_PITCH/2;
Vector<MyPoint> grid;
Vector<MyElement> drawables;

MyElement closest_element = null;
MyElement possible_new_element = null;

void setup() {
  size(1400, 1400);
  grid = new Vector<MyPoint>();
  drawables = new Vector<MyElement>();

  int x = 0;
  int y = 0;
  int yi = 0;
  while (y < Y_PIXS) {
    int x_off = 0;
    if ((yi%2) == 1) {
      x_off = X_OFFSET;
      println("getal " + x_off);
    }
    while (x < X_PIXS) {
      MyPoint v = new MyPoint(new PVector(x+x_off, y));
      grid.add(v);
      x += X_PITCH;
    }
    y += Y_PITCH;
    yi++;
    x = 0;
  }
}

void draw() {
  background(255, 255, 255);
  noFill();
  stroke(0, 0, 0);
  for (MyElement gp : grid) {
    gp.draw();
  }
  for (MyElement e : drawables) {
    e.draw();
  }

  if (closest_element != null) {
      closest_element.draw(color(0, 255, 0));
  }

  if (possible_new_element != null) {
    possible_new_element.draw(color(0, 0, 255));
  }
}

void mouseMoved() {
  closest_element = closest(new PVector(mouseX, mouseY), true);
}

void mousePressed() {

}

void keyPressed() {
  println("key : " + key);
  if ((key == DELETE) || (key == 'q')) {
      println("delete");
      Enumeration<MyElement> elem_enum = drawables.elements();
      while (elem_enum.hasMoreElements()) {
         MyElement check_elem = elem_enum.nextElement();
         if (check_elem.equals(possible_new_element)) {
           drawables.remove(check_elem);
         }
      }
  } else if (key == 's') {
    println("save json");
    JSONArray drawables_json = new JSONArray();
    int i = 0;
    for (MyElement e : drawables) {
      drawables_json.setJSONObject(i, e.getJSON());
      i++;
    }
    saveJSONArray(drawables_json, "data/drawables.json");

  } else if (key == 'l') {
    println("loading");
    
    drawables = new Vector<MyElement>();
    JSONArray values = loadJSONArray("data/drawables.json");
    for (int i = 0; i < values.size(); i++) {
      println("elemeent " + i);
      JSONObject drawable_json = values.getJSONObject(i);
      if (drawable_json.getString("type").equals("triangle")) {
        drawables.add(new MyTriangle(drawable_json));
        println("elemeent " + "triangle");
      } else if (drawable_json.getString("type").equals("line")) {
        drawables.add(new MyLine(drawable_json));
        println("elemeent " + "line");
      } else if (drawable_json.getString("type").equals("point")) {
        drawables.add(new MyPoint(drawable_json));
        println("elemeent " + "point");
      } else {
        println("not : " + drawable_json.getString("type"));
      }
    }
  } else if ((key == '1') || (key == '2') || (key == '3')) {
    println("add");
    Enumeration<MyElement> drawa_enum = drawables.elements();
    while (drawa_enum.hasMoreElements()) {
      MyElement elem = drawa_enum.nextElement();
      if (elem.equals(possible_new_element)) {
        drawables.remove(elem);
      } 
    }
    drawables.add(possible_new_element);
    if (key == '2') {
      possible_new_element.c = color(100,100,100);
    } else if (key == '3') {
      possible_new_element.c = color(200,200,200);
    }
  } else if (key == 'n') {
    drawables = new Vector<MyElement>(); 
  }
}

MyElement closest (PVector p, boolean add) {
  
  Enumeration<MyPoint> elem_enum = grid.elements();
  MyElement closest1 = elem_enum.nextElement();
  MyElement closest2 = elem_enum.nextElement();
  MyElement closest3 = elem_enum.nextElement();
  float dist1 = closest1.dist(p);
  float dist2 = closest2.dist(p);
  float dist3 = closest3.dist(p);

  while (elem_enum.hasMoreElements()) {
    MyElement closest_check = elem_enum.nextElement();
    float dist_check = closest_check.dist(p);
    if (dist_check < dist1) {
      closest3 = closest2;
      closest2 = closest1;
      closest1 = closest_check;
      dist3 = dist2;
      dist2 = dist1; 
      dist1 = dist_check;
    } else if (dist_check < dist2) {
      closest3 = closest2;
      closest2 = closest_check;
      dist3 = dist2;
      dist2 = dist_check; 
    } else if (dist_check < dist3) {
      closest3 = closest_check;
      dist3 = dist_check;
    }
  }
  
  if (add) {
    MyTriangle t = new MyTriangle(closest1.p, closest2.p, closest3.p);
    float dist_t = t.dist(p);
    MyLine l = new MyLine(closest1.p, closest2.p);
    float dist_l = l.dist(p);    
    if (dist_t < dist_l) {
      possible_new_element = t;
    } else {
      possible_new_element = l; 
    }

  }

  return closest1;
}
