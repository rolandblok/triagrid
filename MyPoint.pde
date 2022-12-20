import java.util.*;  

class MyPoint extends MyElement {
  
  private void createMe(PVector p_arg, color c_arg) {
    p = p_arg;
    c = c_arg;
  }
  
  MyPoint(PVector p_arg, color c_arg) {
    createMe(p_arg, c_arg);
  }
  MyPoint(PVector p_arg) {
    this(p_arg, color(0,0,0));
  }
  
  void draw(color c_arg) {
     stroke(c_arg);
     circle(p.x, p.y, 10);
  }
  void draw() {
    draw(c);
  }
  
  float dist(PVector p_arg) {
    return p_arg.dist(p);
  }
  
  JSONObject getJSON(){
    JSONObject json = new JSONObject();
    json.setString("type", my_type);
    json.setFloat("p1x", p.x);
    json.setFloat("p1y", p.y);
    json.setInt("color", c);
    
    return json;
  }
  
  MyPoint(JSONObject json) {
    if (json.getString("type").equals(my_type)) {
      
      float p1x = json.getFloat("p1x");
      float p1y = json.getFloat("p1y");
      color col = json.getInt("color");
      createMe(new PVector(p1x, p1y), col);
    }
  }
  
}
