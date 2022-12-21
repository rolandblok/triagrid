abstract class  MyElement{
  public color c;
  public PVector p; // get coordinate on the grid
  public static final String my_type =  "element"; 
    
  public abstract void draw();
  public abstract void draw(color c);
  public abstract JSONObject getJSON();
  
  public PVector getSP(){
    return( my_pitch.G2S(p));
  }
  public float distS(PVector p_arg) {
    PVector sp = getSP();
    return p_arg.dist(sp);
  }

  
}
  
