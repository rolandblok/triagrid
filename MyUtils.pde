
 
 
 static boolean fEQ(float A, float B, float acc) {
   return abs(A-B) < acc;
 }
 
  static boolean floatEqualsRelative(float A, float B, float acc)  {
    // Calculate the difference.
    float diff = abs(A - B);
    A = abs(A);
    B = abs(B);
    // Find the largest
    float largest = (B > A) ? B : A;

    if (diff <= largest * acc)
        return true;
    return false;
    
  }
   
 static boolean floatSmallerThenRelative(float A, float B, float acc)  {
     // A < B --> TRUE
    // Calculate the difference.
    float fA = abs(A);
    float fB = abs(B);
    // Find the largest
    float largest = (fB > fA) ? fB : fA;

    return A < B - largest*acc;
    
  }
   
  static int ID_counter = 0; 
  static int getID(){
    ID_counter++;
    return ID_counter;
  }
    
void setJSONColor(JSONObject json, color c){
    JSONObject json_c = new JSONObject();
    json_c.setString("type", "RGB");
    json_c.setFloat("red", red(c));
    json_c.setFloat("green", green(c));
    json_c.setFloat("blue", blue(c));
    
    json.setJSONObject("RGB", json_c);
}
color getJSONColor(JSONObject json) {
    color c = color(0);
    try{
        c = json.getInt("color");
        if (c == -13158401) {
          
        } else if (c == -13107401) {
        } else if (c == -51401) {
           color(55,255,55);
        }
      } catch(Exception e) {
        // no more
      }
      try{
        JSONObject json_c = json.getJSONObject("RGB");
        float r = json_c.getFloat("red");
        float g = json_c.getFloat("green");  
        float b = json_c.getFloat("blue");
        c = color(r,g,b);
      } catch (Exception e) {
         // not yet
      }
    return c;
}
   
