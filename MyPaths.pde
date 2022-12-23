import java.util.*;

class MyPaths {
  String c;
  int thickness;
  Vector<LinkedList<PVector>> paths_list;
  float ACC = 0.01;
  
  public MyPaths(Vector<MyLine> visible_lines)
  {
      // initialise variables. WIll be overwritten by first line.
      c = "#000000";
      thickness = 1;
      paths_list = new Vector<LinkedList<PVector>>();
  
      //Find length 0 lines, kill em.
      print("Culling zero length lines : from " + visible_lines.size() + " -. ");
      Enumeration<MyLine> zero_line_enum = visible_lines.elements();
      while (zero_line_enum.hasMoreElements()) {
          MyLine line_it = zero_line_enum.nextElement();
          if (fEQ(line_it.ps[0].p.x, line_it.ps[1].p.x, ACC) &&
              fEQ(line_it.ps[0].p.y, line_it.ps[1].p.y, ACC)    ){
              visible_lines.remove(line_it);
          }
      }
      println(""+visible_lines.size());
  
      //Find length double lines, kill em.
      removeDoubleLines(visible_lines);
      println(" Culling double lines to " + visible_lines.size() );
  
      
      while (visible_lines.size() > 0) {
        // create a line list and put it to the path list
          LinkedList<PVector> point_path = new LinkedList<PVector>();
          paths_list.add(point_path); 
  
          Enumeration<MyLine> line_enum = visible_lines.elements();
          MyLine check_line = line_enum.nextElement();
          point_path.addFirst(check_line.ps[0].p);  // copy the points of the first line
          point_path.addFirst(check_line.ps[1].p);
          visible_lines.remove(check_line);         // remove it from the list, and go for the next one
  
          while (line_enum.hasMoreElements()) {
              check_line = line_enum.nextElement();
              // see if the next line connects to the start or end.
              PVector start = point_path.get(0);                       // get a reference to the front (for readability)
              PVector end   = point_path.get(point_path.size()-1);       // get a reference to the back (for readability)

              if (fEQ(start.x, check_line.ps[0].p.x, ACC) &&
                  fEQ(start.y, check_line.ps[0].p.y, ACC)) {
                  // start connects to left (0) of iterated line
                  point_path.add(0, check_line.ps[1].p);
                  visible_lines.remove(check_line);

              }
              else if (fEQ(start.x, check_line.ps[1].p.x, ACC) &&
                  fEQ(start.y, check_line.ps[1].p.y, ACC)) {
                  // start connects to right of iterated line
                  point_path.add(0, check_line.ps[0].p);
                  visible_lines.remove(check_line);

              }
              else if (fEQ(end.x, check_line.ps[0].p.x, ACC) &&
                  fEQ(end.y, check_line.ps[0].p.y, ACC)) {
                  // start connects to left of iterated line
                  point_path.add(point_path.size(), check_line.ps[1].p);
                  visible_lines.remove(check_line);

              }
              else if (fEQ(end.x, check_line.ps[1].p.x, ACC) &&
                  fEQ(end.y, check_line.ps[1].p.y, ACC)) {
                  // start connects to right of iterated line
                  point_path.add(point_path.size(), check_line.ps[0].p);
                  visible_lines.remove(check_line);

              }
          
          }
      }
  
      return;
  
  }
  
  int removeDoubleLines(Vector<MyLine> visible_lines)
  {
    int no_lines_start = visible_lines.size();
      LinkedHashSet<MyLine> hashSet = new LinkedHashSet<>(visible_lines);
      visible_lines = new Vector<MyLine>(hashSet);
      //Enumeration<MyLine> line_enum = visible_lines.elements();
      //while (line_enum.hasNext()) {
      //    auto line_it2 = line_it+1;
      //    while (line_it2 != visible_lines.end()) {
      //        if (*line_it2 == *line_it) {
      //            line_it = visible_lines.erase(line_it);
      //            no_lines_removed++;
      //            //cout << ".";
      //            break;
      //        }
      //        else {
      //            line_it2++;
      //        }
      //    }
      //    line_it++;
      //}
      return no_lines_start - visible_lines.size();
  
  }
  
  void draw(MySvg svg)
  {
      for (LinkedList<PVector> path : paths_list) {
         Iterator<PVector> vec_it = path.iterator();
         svg.start_path(c, thickness, vec_it.next());
         while (vec_it.hasNext()) {
           svg.add_path(vec_it.next());
         }
      }
    
  }
  
  int getNoPaths()
  {
      return paths_list.size();
  }
  
  int getNoLines()
  {
      int no_lines = 0;
      for (LinkedList<PVector> path : paths_list) {
         no_lines += path.size()-1;
      }
      return no_lines;
  }
      
}
