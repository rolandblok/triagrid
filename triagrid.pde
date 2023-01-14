
import uibooster.*;

import java.util.*;
import java.nio.file.Path;
import java.nio.file.Paths;
 

//https://milchreis.github.io/uibooster-for-processing/reference/uibooster/UiBooster.html
UiBooster booster;


boolean draw_fill;
boolean draw_lines;
boolean draw_grid;


int X_GRID = 50;
int Y_GRID = 60;
Vector<MyPoint> grid;
Vector<MyElement> drawables;

String plot_name = "triagrid";

MyPoint closest_point = null;
MyElement possible_new_element = null;
boolean triangle_fill_mode_on = false;
color active_color = color(0);

MyPitch my_pitch;

void createGrid() {
  println("createGrid");
  grid = new Vector<MyPoint>();
  my_pitch = new MyPitch(30);
  

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
  
  if (closest_point != null) {
      closest_point.draw(color(0, 255, 0), 1);
  }

  if (possible_new_element != null) {
    possible_new_element.draw(color(200,0, 0), 0.5);
  }
}

void mouseMoved() {
  PVector mouse_p = new PVector(mouseX, mouseY);
  closest_point = closest(my_pitch.S2G(mouse_p), true);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    MyElement e = exists( drawables, possible_new_element) ;
    if (e == null) {
      drawables.add(possible_new_element);
    }
  } else if (mouseButton == RIGHT) {
    MyElement e = exists( drawables, possible_new_element) ;
    if (e != null) {
      drawables.remove(possible_new_element);
    }
  } 
}
private void add_rem_elem(MyElement element) {
    MyElement e = exists( drawables, element) ;
    if (e == null) {
      drawables.add(element);
    } else {
      drawables.remove(element);
    }
}

void keyPressed() {
  println("key : " + key);
  if ((key == DELETE) || (key == 'q')) {
    MyElement check_elem = exists(drawables, possible_new_element);
    if (check_elem != null) {
      drawables.remove(check_elem);
    }

  } else if (key == 's') {
    println("save json");
    String select_name = booster.showTextInputDialog("Filename");
    if (!select_name.equals("")) {
      plot_name = select_name;
    }
    surface.setTitle(plot_name);
    String filename = "data/" + plot_name + ".json";

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
    if (selected_file != null) {
      plot_name = Paths.get(selected_file).getFileName().toString();
      int lastPeriodPos = plot_name.lastIndexOf('.');
      if (lastPeriodPos > 0) {
        plot_name = plot_name.substring(0, lastPeriodPos);
      }
      println ("selected : " + selected_file +" --> plotname " + plot_name);
      surface.setTitle(plot_name);
      drawables = new Vector<MyElement>();
      JSONObject main_json = loadJSONObject(selected_file);
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
        } 
      }
      createGrid();
    }
    
  } else if (key == 'f') {
    if (MyTriangle.class == possible_new_element.getClass()) {
      println("add0");
      floodFill((MyTriangle)possible_new_element);
    }
    
  } else if (key == 'g') {
    if (MyTriangle.class == possible_new_element.getClass()) {
      println("remove");
      floodClear((MyTriangle)possible_new_element);
    }
    
  } else if ((triangle_fill_mode_on) && ((key == '1') || (key == '2') || (key == '3'))) {
    if (key == '1') {
      active_color = color(50,50,50);
    } else if (key == '2') {
      active_color = color(125,125,125);
    } else if (key == '3') {
      active_color = color(200,200,200);
    }
  } else if (!triangle_fill_mode_on && (key == '1')) {
    MyPoint np = new MyPoint(closest_point.p.x-0.5, closest_point.p.y+1.0);
    MyLine l = new MyLine(closest_point, np);
    add_rem_elem(l);
    closest_point = closest(np.p, false);
    
  } else if (!triangle_fill_mode_on && (key == '3')) {
    MyPoint np = new MyPoint(closest_point.p.x+0.5, closest_point.p.y+1.0);
    MyLine l = new MyLine(closest_point, np);
    add_rem_elem(l);
    closest_point = closest(np.p, false);
    
  } else if (!triangle_fill_mode_on && (key == '6')) {
    MyPoint np = new MyPoint(closest_point.p.x+1.0, closest_point.p.y);
    MyLine l = new MyLine(closest_point, np);
    add_rem_elem(l);
    closest_point = closest(np.p, false);
    
  } else if (!triangle_fill_mode_on && (key == '9')) {
    MyPoint np = new MyPoint(closest_point.p.x+0.5, closest_point.p.y-1.0);
    MyLine l = new MyLine(closest_point, np);
    add_rem_elem(l);
    closest_point = closest(np.p, false);
    
  } else if (!triangle_fill_mode_on && (key == '7')) {
    MyPoint np = new MyPoint(closest_point.p.x-0.5, closest_point.p.y-1.0);
    MyLine l = new MyLine(closest_point, np);
    add_rem_elem(l);
    closest_point = closest(np.p, false);
    
  } else if (!triangle_fill_mode_on && (key == '4')) {
    MyPoint np = new MyPoint(closest_point.p.x-1.0, closest_point.p.y);
    MyLine l = new MyLine(closest_point, np);
    add_rem_elem(l);
    closest_point = closest(np.p, false);
    
  } else if (key == 'n') {
    createGrid();
    plot_name = "triagrid";
    surface.setTitle(plot_name);
    drawables = new Vector<MyElement>();
  } else if (key == 'z') {
      draw_grid = !draw_grid;
  } else if (key == 'x') {
      draw_lines = !draw_lines;
  } else if (key == 'c') {
      draw_fill = !draw_fill;
  } else if (key == 'C') {
    Iterator<MyElement> el_it = drawables.iterator();
    while (el_it.hasNext()) {
      MyElement e = el_it.next();
      if ((e instanceof MyTriangle) && draw_fill) {
        el_it.remove();
      }
    }
    
  } else if (key == '=') {
      my_pitch.screen_scale = 1.1*my_pitch.screen_scale;
      my_pitch.recalc_grid();
  } else if (key == '-') {
      my_pitch.screen_scale = 0.9*my_pitch.screen_scale;
      my_pitch.recalc_grid();
  } else if (key == '[') {
      my_pitch.Y_GROUND_PITCH = 0.9*my_pitch.Y_GROUND_PITCH;
      my_pitch.recalc_grid();
  }  else if (key == ']') {
      my_pitch.Y_GROUND_PITCH = 1.1*my_pitch.Y_GROUND_PITCH;
      my_pitch.recalc_grid();
  } else if (key == 't') {
      triangle_fill_mode_on = !triangle_fill_mode_on;
  } else if (key == 'p') {
    MyPaths paths = new MyPaths(drawables);
    
    MySvg svg = new MySvg(width, height);
    paths.draw(svg);
    svg.finalize();
    String filename = sketchPath() + "/svg/" + plot_name + ".svg";
    println("saving to : "+filename); 
    svg.save(filename + ".svg");

    filename = sketchPath() + "/png/" + plot_name + ".png";
    save(filename);
  } else if (key == 'q') {
    exit();
  }
  
}

MyPoint closest (PVector grid_p, boolean add) {
  
  Enumeration<MyPoint> elem_enum = grid.elements();
  MyPoint closest1 = elem_enum.nextElement();
  MyPoint closest2 = elem_enum.nextElement();
  MyPoint closest3 = elem_enum.nextElement();
  float dist1 = closest1.distG(grid_p);
  float dist2 = closest2.distG(grid_p);
  float dist3 = closest3.distG(grid_p);
  // find the 3 closest points
  while (elem_enum.hasMoreElements()) {
    MyPoint closest_check = elem_enum.nextElement();
    float dist_check = closest_check.distG(grid_p);
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

  
  // adapt possible new element with closest line or triangle (if triangle mode is on);
  if (add) {
    MyTriangle t = new MyTriangle(closest1, closest2, closest3, active_color);
    float dist_t = t.distG(grid_p);
    MyLine l = new MyLine(closest1, closest2);
    float dist_l = l.distG(grid_p);    
    possible_new_element = l; 
    if (triangle_fill_mode_on) {
      possible_new_element = t;
    } else {
      possible_new_element = l;
    }

  }

  return closest1;
}

void floodClear(MyTriangle t) {
  drawables.remove(possible_new_element);
  floodFill(t, 0, true);
}

void floodFill(MyTriangle t){
  possible_new_element.c = active_color;
  addElem(drawables, possible_new_element);

  floodFill(t, 0, false);
}

void floodFill(MyTriangle t, int depth, boolean remove){
  if (depth < 100) {
    List<TSide> other_sides = Arrays.asList(TSide.values());
    for (int side_in_1 = 0; side_in_1 < 3; side_in_1 ++) {
      int side_in_2 = (side_in_1+1)%3;
      int side_in_3 = (side_in_1+2)%3;
      
      TSide side = other_sides.get(side_in_1);
      TSide side2 = other_sides.get(side_in_2);
      TSide side3 = other_sides.get(side_in_3);
      
      MyLine l = new MyLine(t.ps.get(side), t.ps.get(side2));
      MyElement e = exists(drawables, l);
      if (e == null) {
        PVector av = PVector.add(t.ps.get(side).p, t.ps.get(side2).p).mult(0.5);
        float x     = 2*av.x - t.ps.get(side3).p.x; 
        float y     = 2*av.y - t.ps.get(side3).p.y;
        if ((x >= 0) && ( y >= 0) && (x < X_GRID) && (Y < Y_GRID)){
          MyTriangle tn = new MyTriangle(new MyPoint(x,y), t.ps.get(side), t.ps.get(side2), active_color);
          MyElement et = exists(drawables, tn);
          if (remove) {
            if (et != null) {
              drawables.remove(tn);
              depth++;
              floodFill(tn, depth, true);
            } 
          } else {
            if (et == null) {
              drawables.add(tn);
              depth++;
              floodFill(tn, depth, false);
            } else if (et.c != tn.c) {
              drawables.remove(et);
              drawables.add(tn);
              depth++;
              floodFill(tn, depth, false);
            }
          }
        }
      }    
    }
  }

}

MyElement exists(Vector<MyElement> e_list, MyElement e) {
  MyElement exister = null;
  Enumeration<MyElement> elem_enum = e_list.elements();
  while (elem_enum.hasMoreElements()) {
     MyElement check_elem = elem_enum.nextElement();
     if (check_elem.equals(e)) {
         exister = check_elem;
     }
  }
  return exister;
}
void addElem(Vector<MyElement> e_list, MyElement e) {
    MyElement check_elem = exists(e_list, e);
    if (check_elem != null) {
      e_list.remove(check_elem);
    }
    e_list.add(e);
}
