import java.util.*;

class MyTriangle extends MyElement {
  MyPoint[] ps;
  public static final String my_type =  "triangle"; 
  
  private void createMe(MyPoint p1_arg, MyPoint p2_arg, MyPoint p3_arg, color c_arg) {
    ps = new MyPoint[3];
        
    ps[0] = p1_arg;
    ps[1] = p2_arg;
    ps[2] = p3_arg;

    p = new PVector((ps[0].p.x + ps[1].p.x + ps[2].p.x)/3, (ps[0].p.y + ps[1].p.y + ps[2].p.y)/3);
    
    c = c_arg;

  }
  
  @Override
  public String toString(){
    return "MyTriangle p1:" + ps[0] + " ;p2:" + ps[1] + " ;p3:" + ps[2]; 
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
    PVector sp1 = my_pitch.G2S(ps[0].p);
    PVector sp2 = my_pitch.G2S(ps[1].p);
    PVector sp3 = my_pitch.G2S(ps[2].p);
    triangle(sp1.x, sp1.y, sp2.x, sp2.y, sp3.x, sp3.y);
  }

  @Override
  public boolean equals(Object obj) {
        if(obj.getClass() == this.getClass()) {
          MyTriangle t_check = (MyTriangle) obj;
          return 
            ((ps[0].equals(t_check.ps[0]) && ps[1].equals(t_check.ps[1]) && ps[2].equals(t_check.ps[2])) ||
             (ps[0].equals(t_check.ps[0]) && ps[1].equals(t_check.ps[2]) && ps[2].equals(t_check.ps[1])) ||  
             (ps[0].equals(t_check.ps[1]) && ps[1].equals(t_check.ps[2]) && ps[2].equals(t_check.ps[0])) || 
             (ps[0].equals(t_check.ps[1]) && ps[1].equals(t_check.ps[0]) && ps[2].equals(t_check.ps[2])) || 
             (ps[0].equals(t_check.ps[2]) && ps[1].equals(t_check.ps[0]) && ps[2].equals(t_check.ps[1])) || 
             (ps[0].equals(t_check.ps[2]) && ps[1].equals(t_check.ps[1]) && ps[2].equals(t_check.ps[0]))   );
          
        }
        return false;       
    }
    
  JSONObject getJSON(){
    JSONObject json = new JSONObject();
    json.setString("type", my_type);
    json.setJSONObject("p1", ps[0].getJSON());
    json.setJSONObject("p2", ps[1].getJSON());
    json.setJSONObject("p3", ps[2].getJSON());
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
