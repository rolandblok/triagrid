import java.util.*;

class MyLine extends MyElement {
  PVector p1, p2;
  
  private void createMe(PVector p1_arg, PVector p2_arg, color c_arg) {
    p1 = p1_arg;
    p2 = p2_arg;
    p  = new PVector((p1.x + p2.x)/2, (p1.y + p2.y)/2);
    c = c_arg;
    my_type = "line";
  }

  MyLine(PVector p1_arg, PVector p2_arg, color c_arg) {
    createMe(p1_arg, p2_arg, c_arg);
    
  }
  MyLine(PVector p1_arg, PVector p2_arg) {
    this(p1_arg, p2_arg, color(0, 0, 0));
  }

  void draw() {
    draw(c);
  }
  void draw(color c_arg) {
    stroke(c_arg);
    line(p1.x, p1.y, p2.x, p2.y);
  }

  float dist(PVector p_arg) {
    return p_arg.dist(p);
  }
  
    public boolean equals(Object obj) {
        if(obj instanceof MyLine) {
          MyLine l_check = (MyLine) obj;
          return (((p1 == l_check.p1) && (p2 == l_check.p2)) ||
                  ((p1 == l_check.p2) && (p2 == l_check.p1))   );
          
        }
        return false;       
    }
  JSONObject getJSON(){
    JSONObject json = new JSONObject();
    json.setString("type", my_type);

    json.setFloat("p1x", p1.x);
    json.setFloat("p1y", p1.y);
    json.setFloat("p2x", p2.x);
    json.setFloat("p2y", p2.y);
    json.setInt("color", c);
    
    return json;
  }
  
  MyLine(JSONObject json) {
    if (json.getString("type").equals("line")) {
      
      float p1x = json.getFloat("p1x");
      float p1y = json.getFloat("p1y");
      float p2x = json.getFloat("p2x");
      float p2y = json.getFloat("p2y");
      color col = json.getInt("color");
      createMe(new PVector(p1x, p1y), new PVector(p2x, p2y), col);
    }
  }

}
