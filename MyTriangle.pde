import java.util.*;

class MyTriangle extends MyElement {
  MyPoint p1, p2, p3;
  public static final String my_type =  "triangle"; 
  
  private void createMe(MyPoint p1_arg, MyPoint p2_arg, MyPoint p3_arg, color c_arg) {
    p1 = p1_arg;
    p2 = p2_arg;
    p3 = p3_arg;

    p = new PVector((p1.p.x + p2.p.x + p3.p.x)/3, (p1.p.y + p2.p.y + p3.p.y)/3);
    
    c = c_arg;
  }
  
  @Override
  public String toString(){
    return "MyTriangle p1:" + p1 + " ;p2:" + p2 + " ;p3:" + p3; 
  }

  MyTriangle(MyPoint p1_arg, MyPoint p2_arg, MyPoint p3_arg, color c_arg) {
    createMe(p1_arg, p2_arg, p3_arg, c_arg);
  }
  MyTriangle(MyPoint p1_arg, MyPoint p2_arg, MyPoint p3_arg) {
    this(p1_arg, p2_arg, p3_arg, color(0, 0, 0));
  }

  void draw() {
    draw(c);
  }
  void draw(color c_arg) {
    fill(c_arg);
    noStroke();
    PVector sp1 = my_pitch.G2S(p1.p);
    PVector sp2 = my_pitch.G2S(p2.p);
    PVector sp3 = my_pitch.G2S(p3.p);
    triangle(sp1.x, sp1.y, sp2.x, sp2.y, sp3.x, sp3.y);
  }

  @Override
  public boolean equals(Object obj) {
        if(obj.getClass() == this.getClass()) {
          MyTriangle t_check = (MyTriangle) obj;
          return ((p1.equals(t_check.p1) && p2.equals(t_check.p2) && p3.equals(t_check.p3)) ||
            (p1.equals(t_check.p1) && p2.equals(t_check.p3) && p3.equals(t_check.p2)) ||  
            (p1.equals(t_check.p2) && p2.equals(t_check.p3) && p3.equals(t_check.p1)) || 
            (p1.equals(t_check.p2) && p2.equals(t_check.p1) && p3.equals(t_check.p3)) || 
            (p1.equals(t_check.p3) && p2.equals(t_check.p1) && p3.equals(t_check.p2)) || 
            (p1.equals(t_check.p3) && p2.equals(t_check.p2) && p3.equals(t_check.p1))   );
          
        }
        return false;       
    }
    
  JSONObject getJSON(){
    JSONObject json = new JSONObject();
    json.setString("type", my_type);
    json.setJSONObject("p1", p1.getJSON());
    json.setJSONObject("p2", p2.getJSON());
    json.setJSONObject("p3", p3.getJSON());
    json.setInt("color", c);
    
    return json;
  }
  MyTriangle(JSONObject json) {
    if (json.getString("type").equals("triangle")) {
      MyPoint p1 = new MyPoint(json.getJSONObject("p1"));
      MyPoint p2 = new MyPoint(json.getJSONObject("p2"));
      MyPoint p3 = new MyPoint(json.getJSONObject("p3"));
      color col = json.getInt("color");
      createMe(p1, p2, p3, col);
    } else {
      println("fail triangle" + json.getString("type"));
    }
  }
    
}
