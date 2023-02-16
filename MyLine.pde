import java.util.*;

class MyLine extends MyElement {
  MyPoint[] ps;
  public static final String my_type =  "line"; 
  
  private void createMe(MyPoint p1_arg, MyPoint p2_arg, color c_arg) {
    ps = new MyPoint[2];
    ps[0] = p1_arg;
    ps[1] = p2_arg;
    c = c_arg;
    p = new PVector((ps[0].p.x + ps[1].p.x)/2, (ps[0].p.y + ps[1].p.y)/2);  

  }

  MyLine(MyPoint p1_arg, MyPoint p2_arg, color c_arg) {
    createMe(p1_arg, p2_arg, c_arg);
    
  }
  MyLine(MyPoint p1_arg, MyPoint p2_arg) {
    this(p1_arg, p2_arg, color(0, 0, 0));
  }
  @Override
  public String toString(){
    return "MyLine p1:" + ps[0] + " ;p2:" + ps[1]; 
  }
  
  void move(PVector d) {
    super.move(d);
    for(MyPoint p : ps) {
      p.move(d);
    }
    
  }

  void reverse() {
     MyPoint p_temp = ps[0];
     ps[0] = ps[1];
     ps[1] = p_temp;
  }
  PVector direction() {
    return PVector.sub(ps[1].p, ps[0].p);    
  }

  void draw() {
    draw(c, 1);
  }
  void draw(color c_arg, float weight) {
    stroke(c_arg);
    strokeWeight(weight);
    PVector sp1 = my_pitch.G2S(ps[0].p);
    PVector sp2 = my_pitch.G2S(ps[1].p);
    
    
    line(sp1.x, sp1.y, sp2.x, sp2.y);
  }

  @Override
  public boolean equals(Object obj) {
      if(obj instanceof MyLine) {
        MyLine l_check = (MyLine) obj;
        return (((ps[0].equals(l_check.ps[0])) && (ps[1].equals(l_check.ps[1]))) ||
                ((ps[0].equals(l_check.ps[1])) && (ps[1].equals(l_check.ps[0])))   );
        
      }
      return false;       
  }
  JSONObject getJSON(){
    JSONObject json = new JSONObject();
    json.setString("type", my_type);
    json.setJSONObject("p1", ps[0].getJSON());
    json.setJSONObject("p2", ps[1].getJSON());    
    json.setInt("color", c);
    
    return json;
  }
  
  MyLine(JSONObject json) {
    if (json.getString("type").equals("line")) {
      MyPoint p1 = new MyPoint(json.getJSONObject("p1"));
      MyPoint p2 = new MyPoint(json.getJSONObject("p2"));
      color col = json.getInt("color");
      createMe(p1, p2, col);
    }
  }

}
