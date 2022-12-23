import java.io.*;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;


class MySvg {
  Vector<String> svg_list;
  double width;
  double height;
  double tx;
  double ty;

  public MySvg(double width_arg, double height_arg) {
      svg_list = new Vector<String>();
      tx = 0;
      ty = 0;
      width = width_arg;
      height = height_arg;
  
      String ss = "<svg width='" + width +"px' height='" + width + "px' xmlns='http://www.w3.org/2000/svg' version='1.1' xmlns:xlink='http://www.w3.org/1999/xlink'>\n";
      __add_to_svg(ss);
  }
  
  void __add_to_svg(String text) {
      //"""
      //    Utility function to add element to drawing.
      //    """
      svg_list.add(text);
  }

  void finalize() {
      
      String s = "</svg>";
      __add_to_svg(s);
  }
  void translate(double tx_arg, double ty_arg) {
      tx = tx_arg;
      ty = ty_arg;
  }
  void _translate(PVector p) {
      p.x += tx;
      p.y += ty;
  }


  void line(String c, int strokewidth, PVector p1_arg, PVector p2_arg) {
  
      PVector p1 = p1_arg.copy();
      PVector p2 = p2_arg.copy();
      //"""
      //    Adds a line using the method's arguments.
      //    """
      _translate(p1);
      _translate(p2);
      
      String ss = "    <line stroke='" + c + "' stroke-width='" + strokewidth + "px' y2='" + p2.y + "' x2='" + p2.x + "' y1='" + p1.y + "' x1='" + p1.x + "' />\n";
      __add_to_svg(ss);
  }

  void start_path(String c, int strokewidth, PVector point_arg)
  {
    PVector point = point_arg.copy();
      String ss = "";
      ss += "<path fill='none' stroke='" + c + "' paint-order='fill stroke markers' stroke-opacity='1' stroke-linecap='round' stroke-miterlimit='10' stroke-dasharray=''\n";
      ss += "d= '";
      ss += "M";
      _translate(point);
      ss += point.x + " " + point.y + " \n";
      __add_to_svg(ss);
  }

  void add_path(PVector point_arg)
  {
    PVector point = point_arg.copy();
      String ss = "L";
      _translate(point);
      ss += point.x + " " + point.y + " \n";
      __add_to_svg(ss);
  }

  void end_path()
  {
      String ss = " '  />\n";
      __add_to_svg(ss);
  }

  void save(String path_str) {
    
    File file = new File(path_str);
    try {
      FileWriter wr = new FileWriter(file);
      for (String s : svg_list) {
        wr.write(s);
      }
      wr.flush();
      wr.close();
    } catch (IOException ioe) {
       println("save failed " + ioe); 
    }

  }

}
