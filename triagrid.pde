import uibooster.*;

import java.util.*;


//https://milchreis.github.io/uibooster-for-processing/reference/uibooster/UiBooster.html
UiBooster booster;

boolean draw_fill;
boolean draw_lines;
boolean draw_grid;


int X_GRID = 50;
int Y_GRID = 50;
Vector<MyPoint> grid;
Vector<MyElement> drawables;

MyElement closest_element = null;
MyElement possible_new_element = null;

MyPitch my_pitch;

void createGrid() {
  println("createGrid");
  grid = new Vector<MyPoint>();
  my_pitch = new MyPitch(50);

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
  

  draw_fill = true;
  draw_lines = true;
  draw_grid = true;
  
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
    String filename = booster.showTextInputDialog("Filename");
    filename = "data/" + filename + ".json";

    JSONObject main_json = new JSONObject();
    main_json.setJSONObject("my_pitch", my_pitch.getJSON());
    JSONArray drawables_json = new JSONArray();
    main_json.setJSONArray("drawables", drawables_json);
    int i = 0;
    for (MyElement e : drawables) {
      drawables_json.setJSONObject(i, e.getJSON());
      i++;
    }
    saveJSONObject(main_json, filename);

  } else if (key == 'l') {
    println("loading");
    
    File data_dir = new File(sketchPath() + "/data");
    File[] json_files = data_dir.listFiles();
    String[] json_array = Arrays.stream(json_files).map(Object::toString).toArray(String[]::new);
    List json_list = Arrays.asList(json_array);
    
    String selected_file = booster.showSelectionDialog("select a file", "Select a File", json_list);
    println ("selected : " + selected_file);
    
    drawables = new Vector<MyElement>();
    JSONObject main_json = loadJSONObject( selected_file);
    my_pitch = new MyPitch(main_json.getJSONObject("my_pitch"));
    
    JSONArray drawables_json = main_json.getJSONArray("drawables");
    println("loading " + drawables_json.size() + " drawables");
    for (int i = 0; i < drawables_json.size(); i++) {
      JSONObject drawable_json = drawables_json.getJSONObject(i);
      if (drawable_json.getString("type").equals(MyTriangle.my_type)) {
        drawables.add(new MyTriangle(drawable_json));
      } else if (drawable_json.getString("type").equals(MyLine.my_type)) {
        drawables.add(new MyLine(drawable_json));
      } else if (drawable_json.getString("type").equals(MyPoint.my_type)) {
        drawables.add(new MyPoint(drawable_json));
      } else {
      }
    }
    createGrid();
    
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
    createGrid();
    drawables = new Vector<MyElement>();
  } else if (key == 'z') {
      draw_grid = !draw_grid;
  } else if (key == 'x') {
      draw_lines = !draw_lines;
  } else if (key == 'c') {
      draw_fill = !draw_fill;
  }
}

MyElement closest (PVector p, boolean add) {
  
  Enumeration<MyPoint> elem_enum = grid.elements();
  MyPoint closest1 = elem_enum.nextElement();
  MyPoint closest2 = elem_enum.nextElement();
  MyPoint closest3 = elem_enum.nextElement();
  float dist1 = closest1.distS(p);
  float dist2 = closest2.distS(p);
  float dist3 = closest3.distS(p);

  while (elem_enum.hasMoreElements()) {
    MyPoint closest_check = elem_enum.nextElement();
    float dist_check = closest_check.distS(p);
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
    
    MyTriangle t = new MyTriangle(closest1, closest2, closest3);
    float dist_t = t.distS(p);
    MyLine l = new MyLine(closest1, closest2);
    float dist_l = l.distS(p);    
    if (dist_t < dist_l) {
      possible_new_element = t;
    } else {
      possible_new_element = l; 
    }

  }

  return closest1;
}
