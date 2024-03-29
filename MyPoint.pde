import java.util.*;  

class MyPoint extends MyElement {
  public static final String my_type =  "point";
  
      
      
  private void createMe(PVector p_arg, color c_arg) {
    c = c_arg;
    p = p_arg.copy();
  }
  private void createMe(float x_arg, float y_arg, color c_arg) {
    createMe(new PVector(x_arg, y_arg), c_arg);
  }
  MyPoint(PVector p_arg) {
    createMe(p_arg, color(0,0,0));
  }
  
  MyPoint(float x_arg, float y_arg, color c_arg) {
    createMe(new PVector(x_arg, y_arg),  c_arg);
  }
  MyPoint(float x_arg, float y_arg) {
    this(x_arg,  y_arg,  color(0,0,0));
  }
  
  void move(PVector d) {
    super.move(d);    
  }
  
  @Override
  public String toString(){
    return "MyPoint p" + p; 
  }
  
  void draw() {
    draw(c, 1);
  }
  void draw(color c_arg, float weight) {
     stroke(c_arg);
     strokeWeight(weight);
     PVector sp = getSP();
     circle(sp.x, sp.y, my_pitch.screen_scale/10);
  }

  @Override
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
    setJSONColor(json, c);
    
    return json;
  }
  
  MyPoint(JSONObject json) {
    if (json.getString("type").equals(my_type)) {
      
      float _x = json.getFloat("x");
      float _y = json.getFloat("y");
      color col = getJSONColor(json);
      
      createMe(_x, _y, col);
    }
  }
}
