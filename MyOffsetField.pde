

class MyOffsetField {
  PVector origin;
  float noise_scale, gauss_scale, offset_scale;
  long seed_x, seed_y;
  float[] offsets_x;
  float[] offsets_y;
    public static final String my_type =  "offset_field"; 
  
  private int index(int x, int y) {
    return x*width + y;
  }

  private void createMe(PVector p, float offset_scl, float noise_scl, float gauss_scl){
    println("create noisefields");
    origin = p.copy();
    offset_scale = offset_scl;
    noise_scale = noise_scl;
    gauss_scale = gauss_scl;
    seed_x = (long)random(10000.);
    seed_y = (long)random(10000.);
    offsets_x = new float[width*height];
    offsets_y = new float[width*height];
    
    noiseSeed(seed_x);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        offsets_x[index(x,y)] = calcSingleOffsetAt(new PVector(x,y));
      }
    }
    noiseSeed(seed_y);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        offsets_y[index(x,y)] = calcSingleOffsetAt(new PVector(x,y));
      }
    }
    println("done noisefields");
  }
  
  MyOffsetField(PVector p, float offset_scl, float noise_scl, float gauss_scl) {
    createMe(p, offset_scl, noise_scl, gauss_scl);
  }
  
  MyOffsetField(PVector p, float offset_scl) {
    createMe(p, offset_scl, 0.001, 0.00001);
  }
  
  public PVector getOffsetAt(PVector p) {
    PVector offset = new PVector(0,0);
    int i = index((int)p.x, (int)p.y);
    if ((i < width * height) && (i >= 0)) {
      offset.x = offsets_x[i];
      offset.y = offsets_y[i];
    }
    return offset;
  }
  
  public PVector addOffsetAt(PVector p) {
    PVector offset = getOffsetAt(p);
    return offset.add(p);
  }
  

  private float calcSingleOffsetAt( PVector p) {

    float off = (offset_scale*(-0.5+noise(noise_scale*p.x,noise_scale*p.y)));
    PVector c = PVector.sub (p, origin);
    float offset =off*(exp(-1.0*gauss_scale*c.x*c.x)*exp(-1.0*gauss_scale*c.y*c.y));
    
    return offset;
  }
  
  JSONObject getJSON(){

    JSONObject json = new JSONObject();
    json.setString("type", my_type);
    json.setFloat("origin_x", origin.x);
    json.setFloat("origin_y", origin.y);
    json.setFloat("offset_scale", offset_scale);
    json.setFloat("noise_scale", noise_scale);
    json.setFloat("gauss_scale", gauss_scale);
        
    return json;
  }
  
  MyOffsetField(JSONObject json) {
    if (json.getString("type").equals(MyOffsetField.my_type)) {
      println("load my pitch from json");
      float _x = json.getFloat("origin_x");
      float _y = json.getFloat("origin_y");
      float offset_scale = json.getFloat("offset_scale");
      float noise_scale = json.getFloat("noise_scale");
      float gauss_scale = json.getFloat("gauss_scale");
      createMe(new PVector(_x, _y), offset_scale, noise_scale, gauss_scale);
    } else {
      println("fail offsetfield json load" + json.getString("type"));
    }
  }
  
}
