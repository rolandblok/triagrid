import java.io.*;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;


class MyGCode extends MyExporter{
  Vector<Vector<String>> layers_gcode_list;
  int     cur_layer;
  PVector pix_min;
  PVector pix_max;
  float mm_width;
  float mm_height;
  PVector padding;
  
  float pix2mm ;
  PVector mm_offset;
  
  int draw_speed;
  int move_speed;
  
  private PVector pix2mm(PVector pix) {
    PVector mm = PVector.add(PVector.mult(pix, pix2mm), mm_offset); 
    
    return mm; 
  }
  
  private void pen_up() {
    String ss = "M5\n";
    __add_to_svg(ss);
  }
    
  private void pen_down() {
    int no_steps = 5;
    for (int i = 0; i < no_steps; i++){
        float sv = lerp(10, 30,i/(no_steps-1.));
        String ss = String.format("m3 s%02d;\n", (int)sv);
        __add_to_svg(ss);
        __add_to_svg("G4 P0.1;\n");
    }
  }

  void __add_to_svg(String text) {
      //"""
      //    Utility function to add element to drawing.
      //    """
      layers_gcode_list.get(cur_layer).add(text);
  }


  public MyGCode(PVector pix_min, PVector pix_max, float mm_width, float mm_height) {
    move_speed = 2000;
    draw_speed = 700;
    
    this.pix_min = pix_min;
    this.pix_max = pix_max;
    this.mm_width = mm_width;
    this.mm_height = mm_height;
    this.padding = padding;
    
    layers_gcode_list = new Vector<Vector<String>>();
    cur_layer = -1;

    PVector pix_size = PVector.sub(pix_max, pix_min);
    float pix2mm_x = mm_width / pix_size.x;
    float pix2mm_y = mm_height / pix_size.y;
    if (pix2mm_x * mm_height > 1) {
      pix2mm = pix2mm_y; 
    } else {
       pix2mm = pix2mm_x; 
    }
    mm_offset = new PVector();

  }


  void finalize() {
  }



  void start_layer(String c) {
    cur_layer ++;
    Vector<String> gcode_list = new Vector<String>();
    layers_gcode_list.add(gcode_list);
    
    String ss = "G90\nM5\n";
    __add_to_svg(ss);
    
  }
  void end_layer() {
    String ss = "M5\n";
    __add_to_svg(ss);
  }

  void start_path(String c, int strokewidth, PVector p_pix)
  {
      PVector p_mm = pix2mm(p_pix);
      String ss = String.format("G1 F%d X%.3f Y%.3f\n", (int)move_speed, p_mm.x, p_mm.y);
      __add_to_svg(ss);
      pen_down();
  }

  void add_path(PVector p_pix)
  {
      PVector p_mm = pix2mm(p_pix);
      String ss = String.format("G1 F%d X%.3f Y%.3f\n", (int)draw_speed, p_mm.x, p_mm.y);
      __add_to_svg(ss);
  }

  void end_path()
  {
    pen_up();
  }

  void save(String path_str) {
    
    for (int i = 0; i < layers_gcode_list.size(); i++) {
      Vector<String> gcode_list = layers_gcode_list.get(i);
      String fn = String.format("%s%02d.gcode", path_str, i);
      println("saving to : "+fn); 

      File file = new File(fn);
      try {
        FileWriter wr = new FileWriter(file);
        for (String s : gcode_list) {
          wr.write(s);
        }
        wr.flush();
        wr.close();
      } catch (IOException ioe) {
         println("save failed " + ioe); 
      }
    }

  }

}
