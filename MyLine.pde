import java.util.*;

class MyLine extends MyElement {
  MyPoint p1, p2;
  public static final String my_type =  "line"; 
  
  private void createMe(MyPoint p1_arg, MyPoint p2_arg, color c_arg) {
    p1 = p1_arg;
    p2 = p2_arg;
    c = c_arg;
    p = new PVector((p1.p.x + p2.p.x)/2, (p1.p.y + p2.p.y)/2);  

  }

  MyLine(MyPoint p1_arg, MyPoint p2_arg, color c_arg) {
    createMe(p1_arg, p2_arg, c_arg);
    
  }
  MyLine(MyPoint p1_arg, MyPoint p2_arg) {
    this(p1_arg, p2_arg, color(0, 0, 0));
  }

  void draw() {
    draw(c);
  }
  void draw(color c_arg) {
    stroke(c_arg);
    PVector sp1 = my_pitch.G2S(p1.p);
    PVector sp2 = my_pitch.G2S(p2.p);
    line(sp1.x, sp1.y, sp2.x, sp2.y);
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
    json.setJSONObject("p1", p1.getJSON());
    json.setJSONObject("p2", p2.getJSON());    
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
