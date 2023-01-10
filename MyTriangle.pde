import java.util.*;

enum TSide {
  LEFT, MID, RIGHT
}

class MyTriangle extends MyElement {
  EnumMap<TSide,MyPoint> ps;
  public static final String my_type =  "triangle"; 
  
  Vector<MyLine> hatches ;


  
  private void createMe(MyPoint p1_arg, MyPoint p2_arg, MyPoint p3_arg, color c_arg) {
    ps = new EnumMap<>(TSide.class);
        
    ps.put(TSide.LEFT, p1_arg);
    ps.put(TSide.MID, p2_arg);
    ps.put(TSide.RIGHT, p3_arg);
        
    PVector pl = ps.get(TSide.LEFT).p;
    PVector pm = ps.get(TSide.MID).p;
    PVector pr = ps.get(TSide.RIGHT).p;
    
    p = new PVector((pl.x + pm.x + pr.x)/3, (pl.y + pm.y + pr.y)/3);
    
    c = c_arg;
    hatches = new Vector<MyLine>();
    for (float l = 0.2; l < 1; l += 0.2) {
      PVector p1 = PVector.add(pm, PVector.mult(PVector.sub(pl, pm), l));             
      PVector p2 = PVector.add(pm, PVector.mult(PVector.sub(pr, pm), l));   
      MyLine hatch = new MyLine(new MyPoint(p1), new MyPoint(p2)); 
      hatches.add(hatch);
    }

  }
  
  @Override
  public String toString(){
    return "MyTriangle pl:" + ps.get(TSide.LEFT).p + " ;pm:" + ps.get(TSide.MID).p + " ;pr:" +ps.get(TSide.RIGHT).p; 
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
    PVector sp1 = my_pitch.G2S(ps.get(TSide.LEFT).p);
    PVector sp2 = my_pitch.G2S(ps.get(TSide.MID).p);
    PVector sp3 = my_pitch.G2S(ps.get(TSide.RIGHT).p);
    triangle(sp1.x, sp1.y, sp2.x, sp2.y, sp3.x, sp3.y);
    
    for (MyLine h : hatches) {
      h.draw();
    }
    
  }

  @Override
  public boolean equals(Object obj) {
        if(obj.getClass() == this.getClass()) {
          MyTriangle t_check = (MyTriangle) obj;
          return 
            ((ps.get(TSide.LEFT).equals(t_check.ps.get(TSide.LEFT)) && ps.get(TSide.MID).equals(t_check.ps.get(TSide.MID)) && ps.get(TSide.RIGHT).equals(t_check.ps.get(TSide.RIGHT))) ||
             (ps.get(TSide.LEFT).equals(t_check.ps.get(TSide.LEFT)) && ps.get(TSide.MID).equals(t_check.ps.get(TSide.RIGHT)) && ps.get(TSide.RIGHT).equals(t_check.ps.get(TSide.MID))) ||  
             (ps.get(TSide.LEFT).equals(t_check.ps.get(TSide.MID)) && ps.get(TSide.MID).equals(t_check.ps.get(TSide.RIGHT)) && ps.get(TSide.RIGHT).equals(t_check.ps.get(TSide.LEFT))) || 
             (ps.get(TSide.LEFT).equals(t_check.ps.get(TSide.MID)) && ps.get(TSide.MID).equals(t_check.ps.get(TSide.LEFT)) && ps.get(TSide.RIGHT).equals(t_check.ps.get(TSide.RIGHT))) || 
             (ps.get(TSide.LEFT).equals(t_check.ps.get(TSide.RIGHT)) && ps.get(TSide.MID).equals(t_check.ps.get(TSide.LEFT)) && ps.get(TSide.RIGHT).equals(t_check.ps.get(TSide.MID))) || 
             (ps.get(TSide.LEFT).equals(t_check.ps.get(TSide.RIGHT)) && ps.get(TSide.MID).equals(t_check.ps.get(TSide.MID)) && ps.get(TSide.RIGHT).equals(t_check.ps.get(TSide.LEFT)))   );
          
        }
        return false;       
    }
    
  JSONObject getJSON(){
    JSONObject json = new JSONObject();
    json.setString("type", my_type);
    json.setJSONObject("p1", ps.get(TSide.LEFT).getJSON());
    json.setJSONObject("p2", ps.get(TSide.MID).getJSON());
    json.setJSONObject("p3", ps.get(TSide.RIGHT).getJSON());
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
