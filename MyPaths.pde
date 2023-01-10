import java.util.*;

class MyPaths {
  String c;
  int thickness;
  LinkedList<LinkedList<PVector>> paths_list;
  float ACC = 0.01;
  
  public MyPaths(Vector<MyElement> elements)
  {
      // initialise variables. WIll be overwritten by first line.
      c = "#000000";
      thickness = 1;
      paths_list = new LinkedList<LinkedList<PVector>>();
      
      LinkedList<MyLine> visible_lines = new LinkedList<MyLine>();
      for (MyElement elem : elements) {
        if (elem.getClass() ==   MyLine.class) {
          visible_lines.add((MyLine) elem);          
        }
      }
  
      //Find length 0 lines, kill em.
      print("Culling zero length lines : from " + visible_lines.size() + " -. ");
      Iterator<MyLine> zero_line_it = visible_lines.iterator();
      while (zero_line_it.hasNext()) {
          MyLine line_it = zero_line_it.next();
          if (fEQ(line_it.ps[0].p.x, line_it.ps[1].p.x, ACC) &&
              fEQ(line_it.ps[0].p.y, line_it.ps[1].p.y, ACC)    ){
              visible_lines.remove(line_it);
          }
      }
      println(""+visible_lines.size());
  
      //Find length double lines, kill em.
      removeDoubleLines(visible_lines);
      println(" Culling double lines to " + visible_lines.size() );
  
      boolean no_more_connections_found = true;
      while (visible_lines.size() > 0) {
        // create a line list and put it to the path list
          
          LinkedList<PVector> point_path;
          if (no_more_connections_found) {
            point_path = new LinkedList<PVector>();
            paths_list.addLast(point_path); 
            MyLine check_line = visible_lines.poll();
            point_path.addFirst(check_line.ps[0].p);  // copy the points of the first line
            point_path.addFirst(check_line.ps[1].p);
            visible_lines.remove(check_line);         // remove it from the list, and go for the next one
          }    else {
            point_path = paths_list.getLast();
            no_more_connections_found = true;
          }
 
          Iterator<MyLine> line_it = visible_lines.iterator();
          while (line_it.hasNext()) {
              MyLine check_line = line_it.next();
              // see if the next line connects to the start or end.
              PVector start = point_path.getFirst();                       // get a reference to the front (for readability)
              PVector end   = point_path.getLast();       // get a reference to the back (for readability)

              if (fEQ(start.x, check_line.ps[0].p.x, ACC) &&
                  fEQ(start.y, check_line.ps[0].p.y, ACC)) {
                  // start connects to left (0) of iterated line
                  point_path.addFirst(check_line.ps[1].p);
                  visible_lines.remove(check_line);
                  no_more_connections_found = false;
                  break;
              }
              else if (fEQ(start.x, check_line.ps[1].p.x, ACC) &&
                  fEQ(start.y, check_line.ps[1].p.y, ACC)) {
                  // start connects to right of iterated line
                  point_path.addFirst(check_line.ps[0].p);
                  visible_lines.remove(check_line);
                  no_more_connections_found = false;
                  break;
              }
              else if (fEQ(end.x, check_line.ps[0].p.x, ACC) &&
                  fEQ(end.y, check_line.ps[0].p.y, ACC)) {
                  // start connects to left of iterated line
                  point_path.addLast( check_line.ps[1].p);
                  visible_lines.remove(check_line);
                  no_more_connections_found = false;
                  break;
              }
              else if (fEQ(end.x, check_line.ps[1].p.x, ACC) &&
                  fEQ(end.y, check_line.ps[1].p.y, ACC)) {
                  // start connects to right of iterated line
                  point_path.addLast(check_line.ps[0].p);
                  visible_lines.remove(check_line);
                  no_more_connections_found = false;
                  break;
              }
          
          }
      }
      println(" number of paths " + getNoPaths() );
  
      return;
  
  }

  
  int removeDoubleLines(LinkedList<MyLine> visible_lines)
  {
    int no_lines_start = visible_lines.size();
    for(ListIterator<MyLine> outer = visible_lines.listIterator(); outer.hasNext() ; ) {
      MyLine line_outer = outer.next();
      for(ListIterator<MyLine> inner = visible_lines.listIterator(outer.nextIndex()); inner.hasNext(); ) {
        MyLine line_inner = inner.next();
         if (line_inner.equals(line_outer)) {
            visible_lines.remove(line_outer);
            //cout << ".";
            break;
         }
       }
    }
    
  //}

  //    Iterator<MyLine> line_it1 = visible_lines.iterator();
      
  //    while (line_it1.hasNext()) {
  //        MyLine line1 = line_it.next();
          
  //        while (line_) {
  //            if (line_it2.equals(line_it)) {
  //                visible_lines.remove(line_it);
  //                line_it.next();
  //                //cout << ".";
  //                break;
  //            }
  //            else {
  //                line_it2.next;
  //            }
  //        }
  //        line_it.next;
  //    }
      return no_lines_start - visible_lines.size();
  
  }
  
  void draw(MySvg svg)
  {
      for (LinkedList<PVector> path : paths_list) {
         Iterator<PVector> vec_it = path.iterator();
         svg.start_path(c, thickness,  my_pitch.G2S(vec_it.next()));
         while (vec_it.hasNext()) {
           svg.add_path( my_pitch.G2S(vec_it.next()));
         }
         svg.end_path();
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
