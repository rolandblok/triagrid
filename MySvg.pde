import java.io.*;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;




class MySvg extends MyExporter{
  Vector<String> svg_list;
  PVector paper_size;

  public MySvg(PVector pix_min, PVector pix_max, float mm_width, float mm_height) {
    
    paper_size = new PVector(mm_width, mm_height);
    svg_list = new Vector<String>();

    PVector pix_size = PVector.sub(pix_max, pix_min);
    PVector padding = PVector.mult(pix_size, PADDING_FRAC);
    pix_min.sub(padding);
    pix_size.add(PVector.mult(padding, 2));
    String ss = "<svg width='" + mm_width +"mm' height='" + mm_height + 
              "mm' viewBox='"+ pix_min.x + " " +  pix_min.y + " " + pix_size.x + " " + pix_size.y + "'" + 
              " xmlns='http://www.w3.org/2000/svg' version='1.1' xmlns:xlink='http://www.w3.org/1999/xlink'>\n";
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


  void start_layer(String c) {
    String ss = "<g \n id='" + c + "'>\n";
    
    __add_to_svg(ss);
    
  }
  void end_layer() {
    String ss = "</g>\n";
    
    __add_to_svg(ss);
  }

  void start_path(String c, int strokewidth, PVector point_arg, int hor_rep, int ver_rep)
  {
    PVector point = point_arg.copy();
    PVector rep = new PVector(paper_size.x * hor_rep, paper_size.y * ver_rep);
    point.add(rep);
      String ss = "";
      ss += "<path fill='none' stroke='" + c + "' paint-order='fill stroke markers' stroke-opacity='1' stroke-linecap='round' stroke-miterlimit='10' stroke-dasharray=''\n";
      ss += "d= '";
      ss += "M";
      ss += point.x + " " + point.y + " \n";
      __add_to_svg(ss);
  }

  void add_path(PVector point_arg, int hor_rep, int ver_rep)
  {
    PVector point = point_arg.copy();
    PVector rep = new PVector(paper_size.x * hor_rep, paper_size.y * ver_rep);
    point.add(rep);
      String ss = "L";
      ss += point.x + " " + point.y + " \n";
      __add_to_svg(ss);
  }

  void end_path()
  {
      String ss = " '  />\n";
      __add_to_svg(ss);
  }

  void save(String path_str) {
    
    File file = new File(path_str+".svg");
    println("saving to : "+file); 
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
