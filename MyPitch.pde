class MyPitch {
   float X_GROUND_PITCH = 1.00; 
   float Y_GROUND_PITCH = 0.87;
   float X_SCREEN_PITCH;
   float Y_SCREEN_PITCH;
   float X_SCREEN_OFFSET;
   float screen_scale;
   
     
   private void setScreenScale(float screen_scale_arg) {
     screen_scale = screen_scale_arg;
     X_SCREEN_PITCH = X_GROUND_PITCH * screen_scale;
     Y_SCREEN_PITCH = Y_GROUND_PITCH * screen_scale;
   }

   MyPitch(float screen_scale_arg) {
     setScreenScale(screen_scale_arg);
   }
   
   
   /**
    * Grid coordinate to screen coordinate
    */
   PVector G2S(PVector pg) { 
     return PVector.mult(pg, screen_scale);
   }
   PVector S2G(PVector pg) { 
     return PVector.div(pg, screen_scale);
   }
  
  JSONObject getJSON(){
    JSONObject json = new JSONObject();
    json.setString("type", "MyPitch");
    json.setFloat("screen_scale", screen_scale);
    
    return json;
  }
  
  MyPitch(JSONObject json) {
    if (json.getString("type").equals("MyPitch")) {
      
      float _screen_scale = json.getFloat("screen_scale");
      
      setScreenScale(_screen_scale);
    }
  }
  
}
