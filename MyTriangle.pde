import java.util.*;

class MyTriangle extends MyElement {
  PVector p1, p2, p3;
  
  private void createMe(PVector p1_arg, PVector p2_arg, PVector p3_arg, color c_arg) {
    p1 = p1_arg;
    p2 = p2_arg;
    p3 = p3_arg;

    p  = new PVector((p1.x + p2.x + p3.x)/3, (p1.y + p2.y + p3.y)/3);
    c = c_arg;
    my_type = "triangle";
     
  }

  MyTriangle(PVector p1_arg, PVector p2_arg, PVector p3_arg, color c_arg) {
    createMe(p1_arg, p2_arg, p3_arg, c_arg);
  }
  MyTriangle(PVector p1_arg, PVector p2_arg, PVector p3_arg) {
    this(p1_arg, p2_arg, p3_arg, color(0, 0, 0));
  }

  void draw() {
    draw(c);
  }
  void draw(color c_arg) {
    fill(c_arg);
    noStroke();
    triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
  }

  float dist(PVector p_arg) {
    return p_arg.dist(p);
  }
  public boolean equals(Object obj) {
        if(obj instanceof MyTriangle) {
          MyTriangle t_check = (MyTriangle) obj;
          return (((p1 == t_check.p1) && (p2 == t_check.p2) && (p3 == t_check.p3)) ||
            ((p1 == t_check.p1) && (p2 == t_check.p3) && (p3 == t_check.p2)) ||  
            ((p1 == t_check.p2) && (p2 == t_check.p3) && (p3 == t_check.p1)) || 
            ((p1 == t_check.p2) && (p2 == t_check.p1) && (p3 == t_check.p3)) || 
            ((p1 == t_check.p3) && (p2 == t_check.p1) && (p3 == t_check.p2)) || 
            ((p1 == t_check.p3) && (p2 == t_check.p2) && (p3 == t_check.p1))   );
          
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
    json.setFloat("p3x", p3.x);
    json.setFloat("p3y", p3.y);
    json.setInt("color", c);
    
    return json;
  }
  MyTriangle(JSONObject json) {
    if (json.getString("type").equals("triangle")) {
      float p1x = json.getFloat("p1x");
      float p1y = json.getFloat("p1y");
      float p2x = json.getFloat("p2x");
      float p2y = json.getFloat("p2y");
      float p3x = json.getFloat("p3x");
      float p3y = json.getFloat("p3y");
      color col = json.getInt("color");
      createMe(new PVector(p1x, p1y), new PVector(p2x, p2y), new PVector(p3x, p3y), col);
    } else {
      println("fail " + json.getString("type"));
    }
  }
    
}
