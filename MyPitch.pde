class MyPitch {
   PVector SCREEN_PITCH;
   float X_GROUND_PITCH = 1.00; 
   float Y_GROUND_PITCH = 0.87;
   float screen_scale;
   boolean invertXY;
   
     
   void recalc_grid() {
     SCREEN_PITCH = new PVector(0,0); 
     SCREEN_PITCH.x = X_GROUND_PITCH * screen_scale;
     SCREEN_PITCH.y = Y_GROUND_PITCH * screen_scale;
   }

   MyPitch(float screen_scale_arg) {
     screen_scale = screen_scale_arg;
     recalc_grid();
   }
   
   
   
   /**
    * Grid coordinate to screen coordinate
    */
   PVector G2S(PVector pg) {
     PVector res = pg.copy();
     res.x = SCREEN_PITCH.x * res.x;
     res.y = SCREEN_PITCH.y * res.y;
     if (invertXY) {
       float x_t = res.x;
       res.x = res.y;
       res.y = x_t;
     }
     return res;
   }
   PVector S2G(PVector pg) { 
     PVector res = pg.copy();
     if (invertXY) {
       float x_t = res.x;
       res.x = res.y;
       res.y = x_t;
     }
     res.x = res.x / SCREEN_PITCH.x;
     res.y = res.y / SCREEN_PITCH.y;
     return res;

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
      screen_scale =_screen_scale;
      recalc_grid();
    }
  }
  
}
