abstract class  MyElement{
  public color c;
  public PVector p; // get coordinate on the grid
  public static final String my_type =  "element"; 
    
  public abstract void draw();
  public abstract void draw(color c, float weight);
  public abstract JSONObject getJSON();
  
  public void move(PVector d) {
    p.add(d);
  }
  
  public PVector getSP(){
    return( my_pitch.G2S(p));
  }
  //public float distS(PVector scr_p_arg) {
  //  PVector sp = getSP();
  //  return scr_p_arg.dist(sp);
  //}
  public float distG(PVector grid_p_arg) {
    return grid_p_arg.dist(p);
  }

  
}
  
