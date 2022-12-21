import java.util.*;  

class MyPoint extends MyElement {
  public static final String my_type =  "point";
      
  private void createMe(float x_arg, float y_arg, color c_arg) {
    c = c_arg;
    p = new PVector(x_arg, y_arg);

  }
  
  MyPoint(float x_arg, float y_arg, color c_arg) {
    createMe(x_arg,  y_arg,  c_arg);
  }
  MyPoint(float x_arg, float y_arg) {
    this(x_arg,  y_arg,  color(0,0,0));
  }
  
  void draw(color c_arg) {
     stroke(c_arg);
     PVector sp = getSP();
     circle(sp.x, sp.y, 10);
  }
  void draw() {
    draw(c);
  }

  public boolean equals(Object obj) {
    float acc = 0.001;
        if(obj instanceof MyPoint) {
          MyPoint pc = (MyPoint) obj;
          return (fEQ(p.x, pc.p.x, acc) && fEQ(p.y, pc.p.y, acc));
        }
        return false;       
    }
  
  JSONObject getJSON(){
    JSONObject json = new JSONObject();
    json.setString("type", my_type);
    json.setFloat("x", p.x);
    json.setFloat("y", p.y);
    json.setInt("color", c);
    
    return json;
  }
  
  MyPoint(JSONObject json) {
    if (json.getString("type").equals(my_type)) {
      
      float _x = json.getFloat("x");
      float _y = json.getFloat("y");
      color col = json.getInt("color");
      createMe(_x, _y, col);
    }
  }
}
