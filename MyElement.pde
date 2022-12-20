abstract class  MyElement{
  public color c;
  public PVector p;
  public String my_type;

    
  public abstract float dist(PVector v);
  public abstract void draw();
  public abstract void draw(color c);
  public abstract JSONObject getJSON();
  

  
}
  
