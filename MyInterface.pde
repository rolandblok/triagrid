
import uibooster.*;
import uibooster.model.*;

//https://milchreis.github.io/uibooster-for-processing/reference/uibooster/UiBooster.html
UiBooster booster;

boolean triangle_fill_mode_on = false;
boolean move_mode_on = false;

color active_color = color(0);

void myInterFaceSetup() {
    booster = new UiBooster();
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

String KEY_MANUAL =  
  " s : save json \n" +
  " l : load json \n" + 
  " t : toggle line / hatching(triangle) mode \n"  +
  "   in TRIANGLE mode: \n" +
  "     f :  flood fill hatching \n"+ 
  "     g : flood erase hatching \n"+ 
  "     123 : hatching  \n"+
  "   in LINE mode : \n" +
  "     1234546789 : draw line in numbered direction \n" +
  " m : toggle drawing move mode \n" +
  "     1234546789 : move the drawing \n" +
  " y/u : create / removedistortion field \n" + 
  " z : toggle draw grid \n"+ 
  " x : toggle draw lines \n"+ 
  " c : toggle draw hatches \n"+ 
  " -= : scale \n"+ 
  " [] : aspect \n" +
  " p : save print to svg and gcode \n" +
  " C : clear hatching \n"+ 
  " n : NEW \n";




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
    
    String selected_file = null;
    if (true) {
      File data_dir = new File(sketchPath() + "/data");
      File[] json_files = data_dir.listFiles();
      String[] json_array = Arrays.stream(json_files).map(Object::toString).toArray(String[]::new);
      List json_list = Arrays.asList(json_array);
      
      selected_file = booster.showSelectionDialog("select a file", "Select a File", json_list);
    } 
    
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
    
  } else if (key == 't') {
      triangle_fill_mode_on = !triangle_fill_mode_on;
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
    
  } else if (key == 'm') {
    move_mode_on = !move_mode_on;
    println("MOVE MODE " + (move_mode_on?"ON " : "OFF"));
  } else if (move_mode_on && (key == '1')) {
    moveElements(-1.0,  1.0);
  } else if (move_mode_on && (key == '2')) {
    moveElements( 0.0,  2.0);
  } else if (move_mode_on && (key == '3')) {
    moveElements( 1.0,  1.0);
  } else if (move_mode_on && (key == '6')) {
    moveElements( 2.0,  0.0);
  } else if (move_mode_on && (key == '9')) {
    moveElements( 1.0, -1.0);
  } else if (move_mode_on && (key == '8')) {
    moveElements( 0.0, -2.0);
  } else if (move_mode_on && (key == '7')) {
    moveElements(-1.0, -1.0);
  } else if (move_mode_on && (key == '4')) {
    moveElements(-2.0,  0.0);
    
  } else if ((triangle_fill_mode_on) && ((key == '1') || (key == '2') || (key == '3'))) {
    if (key == '1') {
      active_color = color(50,50,50);
    } else if (key == '2') {
      active_color = color(125,125,125);
    } else if (key == '3') {
      active_color = color(200,200,200);
    }
  } else if (!triangle_fill_mode_on && (key == '1')) {
    addRemLineToClosePoint(-1.0,  1.0);
  } else if (!triangle_fill_mode_on && (key == '2')) {
    addRemLineToClosePoint( 0.0,  2.0);
  } else if (!triangle_fill_mode_on && (key == '3')) {
    addRemLineToClosePoint( 1.0,  1.0);
  } else if (!triangle_fill_mode_on && (key == '6')) {
    addRemLineToClosePoint( 2.0,  0.0);
  } else if (!triangle_fill_mode_on && (key == '9')) {
    addRemLineToClosePoint( 1.0, -1.0);
  } else if (!triangle_fill_mode_on && (key == '8')) {
    addRemLineToClosePoint( 0.0, -2.0);
  } else if (!triangle_fill_mode_on && (key == '7')) {
    addRemLineToClosePoint(-1.0, -1.0);
  } else if (!triangle_fill_mode_on && (key == '4')) {
    addRemLineToClosePoint(-2.0,  0.0);
  } else if (key == 'n') {
    my_pitch = new MyPitch(30);
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
  } else if (key == 'p') {
    
    String selection = new UiBooster().showSelectionDialog(
        "Select Format",
        "Format?",
        Arrays.asList("A4 PORTRAIT", "A4 LANDSCAPE", "A3 PORTRAIT", "A3 LANDSCAPE", "A6 PORTRAIT", "A6 LANDSCAPE"));
    
    String name_ext = "A4POR";
    float p_w = A4_PORTRAIT_WIDTH;
    float p_h = A4_PORTRAIT_HEIGHT;
    println("selection " + selection);
    if (selection == "A4 PORTRAIT") {
      p_w = A4_PORTRAIT_WIDTH;
      p_h = A4_PORTRAIT_HEIGHT;
      name_ext = ".A4POR";
    } else if (selection == "A4 LANDSCAPE") {
      p_w = A4_PORTRAIT_HEIGHT;
      p_h = A4_PORTRAIT_WIDTH;
      name_ext = ".A4LAN";
    } else if (selection == "A3 PORTRAIT") {
      p_w = A3_PORTRAIT_WIDTH;
      p_h = A3_PORTRAIT_HEIGHT;
      name_ext = ".A3POR";
    } else if (selection == "A3 LANDSCAPE") {
      p_w = A3_PORTRAIT_HEIGHT;
      p_h = A3_PORTRAIT_WIDTH;
      name_ext = ".A3LAN";
    } else if (selection == "A6 PORTRAIT") {
      p_w = A6_PORTRAIT_WIDTH;
      p_h = A6_PORTRAIT_HEIGHT;
      name_ext = ".A3POR";
    } else if (selection == "A6 LANDSCAPE") {
      p_w = A6_PORTRAIT_HEIGHT;
      p_h = A6_PORTRAIT_WIDTH;
      name_ext = ".A3LAN";
    }
    
    MyPaths paths = new MyPaths(drawables);
    PVector min = new PVector();
    PVector max = new PVector();
    paths.getBounds(min, max);

    String filename = sketchPath() + "/gcode/" + plot_name + name_ext;
    
    MyGCode gcode = new MyGCode(min, max, p_w, p_h);
    paths.draw(gcode);
    gcode.finalize();
    gcode.save(filename);

    filename = sketchPath() + "/svg/" + plot_name + name_ext;
    
    MySvg svg = new MySvg(min, max, p_w, p_h);
    paths.draw(svg);
    svg.finalize();
    svg.save(filename);

    filename = sketchPath() + "/png/" + plot_name + ".png";
    save(filename);
  } else if (key == 'i') {
    my_pitch.invertXY = !my_pitch.invertXY;    
  } else if (key == 'q') {
    exit();
  } else if (key == 'y') {
    println("create offsetfield at " + mouseX + " " + mouseY);
    my_pitch.addOffsetField(mouseX, mouseY);
  } else if (key == 'u') {
    println("remove offsetfield at " + mouseX + " " + mouseY);
    my_pitch.removeOffsetField(mouseX, mouseY);
  } else if (key == '?') {

            new UiBooster().showInfoDialog(KEY_MANUAL);


  }
  
  
}

PVector dir2Offset(float x_dir, float y_dir) {
    if (my_pitch.invertXY) {
      float xdir_t = x_dir;
      x_dir = y_dir; 
      y_dir = xdir_t;
    }
    float dx = x_dir * 0.5;
    float dy = y_dir * 1.0;
    return new PVector(dx, dy);
}

void addRemLineToClosePoint(float x_dir, float y_dir) {
  PVector d = dir2Offset(x_dir, y_dir);
    MyPoint np = new MyPoint(closest_point.p.x+d.x, closest_point.p.y+d.y);
    MyLine l = new MyLine(closest_point, np);
    add_rem_elem(l);
    closest_point = closest(np.p, false);
}


void add_rem_elem(MyElement element) {
    MyElement e = exists( drawables, element) ;
    if (e == null) {
      drawables.add(element);
    } else {
      drawables.remove(element);
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
    MyLine l = new MyLine(closest1, closest2);
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
void moveElements(float dx, float dy) {
    PVector d = dir2Offset(dx, dy);
    for (MyElement e : drawables) {
      e.move(d);
    }
}
