import java.util.*;

enum TSide {
  LEFT, MID, RIGHT
}

class MyTriangle extends MyElement {
  EnumMap<TSide,MyPoint> ps;
  public static final String my_type =  "triangle"; 
  
  Vector<MyLine> hatches ;
  int hatch_density;
  
  private void createMe(MyPoint p1_arg, MyPoint p2_arg, MyPoint p3_arg, color c_arg) {
    ps = new EnumMap<>(TSide.class);
    
    ArrayList<MyPoint> sort_list = new ArrayList<MyPoint>();
    sort_list.add(p1_arg);
    sort_list.add(p2_arg);
    sort_list.add(p3_arg);
    
    Collections.sort(sort_list, (MyPoint p1, MyPoint p2) -> Float.compare(p1.p.x, p2.p.x));
    
    ps.put(TSide.LEFT, sort_list.get(0));
    ps.put(TSide.MID, sort_list.get(1));
    ps.put(TSide.RIGHT, sort_list.get(2));
    
    hatch_density = 2;
    c = c_arg;
    color hc = color(255,55,55);
    PVector p0 = ps.get(TSide.MID).p;
    PVector p1 = ps.get(TSide.LEFT).p;
    PVector p2 = ps.get(TSide.RIGHT).p;  

    if (green(c_arg) < 255/3) {    
      hc = color(55,255,55);
      hatch_density = 4;
      if (ps.get(TSide.LEFT).p.y < ps.get(TSide.MID).p.y) {
        p0 = ps.get(TSide.LEFT).p;
        p1 = ps.get(TSide.MID).p;
        p2 = ps.get(TSide.RIGHT).p;
      } else {
        p0 = ps.get(TSide.RIGHT).p;
        p1 = ps.get(TSide.MID).p;
        p2 = ps.get(TSide.LEFT).p;        
      }
    } else if (green(c_arg) < 2*255/3) {
      hc = color(55,55,255);
      hatch_density = 6;
      if (ps.get(TSide.LEFT).p.y < ps.get(TSide.MID).p.y) {
        p0 = ps.get(TSide.RIGHT).p;
        p1 = ps.get(TSide.MID).p;
        p2 = ps.get(TSide.LEFT).p;
      } else {
        p0 = ps.get(TSide.LEFT).p;
        p1 = ps.get(TSide.MID).p;
        p2 = ps.get(TSide.RIGHT).p;        
      }    
    } 
    
    p = new PVector((p0.x + p1.x + p2.x)/3, (p0.y + p1.y + p2.y)/3);


    hatches = new Vector<MyLine>();
    for (int i = 1; i <= hatch_density; i++) {
      float l = i * 1.0 / hatch_density;
      
      PVector pa= PVector.lerp(p0, p1, l);
      PVector pb= PVector.lerp(p0, p2, l);
      //PVector pa = PVector.add(p0, PVector.mult(PVector.sub(p1, p0), l));             
      //PVector pb = PVector.add(p0, PVector.mult(PVector.sub(p2, p0), l));   
      MyLine hatch = new MyLine(new MyPoint(pa), new MyPoint(pb), hc); 
      hatches.add(hatch);
    }

  }
  String getStrColor() {
    return "#"+Integer.toHexString( (int)red(c)) + Integer.toHexString( (int)green(c)) +Integer.toHexString( (int)blue(c));
     //String.format("%02d", (int)red(c))  +
     //String.format("%02d", (int)green(c)) +
     //String.format("%02d", (int)blue(c))  ;
  }
  
  void move(PVector d) {
    super.move(d);

    // using for-each loop for iteration over Map.entrySet()
    for (Map.Entry<TSide,MyPoint> p_entry : ps.entrySet()) {
      p_entry.getValue().move(d);
    }
    for (MyLine hatch : hatches) {
      hatch.move(d);
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
    draw(c, 1);
  }
  void draw(color c_arg, float weight) {
    stroke(c_arg);
    if (weight == 0) {
      noStroke();
    } else {
      strokeWeight(weight);
      
    }
    PVector sp1 = my_pitch.G2S(ps.get(TSide.LEFT).p);
    PVector sp2 = my_pitch.G2S(ps.get(TSide.MID).p);
    PVector sp3 = my_pitch.G2S(ps.get(TSide.RIGHT).p);
    //triangle(sp1.x, sp1.y, sp2.x, sp2.y, sp3.x, sp3.y);
    
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
    setJSONColor(json, c);
    
    
    return json;
  }
  MyTriangle(JSONObject json) {
    if (json.getString("type").equals("triangle")) {
      MyPoint p1 = new MyPoint(json.getJSONObject("p1"));
      MyPoint p2 = new MyPoint(json.getJSONObject("p2"));
      MyPoint p3 = new MyPoint(json.getJSONObject("p3"));
      color c = getJSONColor(json);
      
      createMe(p1, p2, p3, c);
    } else {
      println("fail triangle" + json.getString("type"));
    }
  }
    
}
