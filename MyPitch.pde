import java.util.*;

class MyPitch {
   PVector SCREEN_PITCH;
   float X_GROUND_PITCH = 1.00; 
   float Y_GROUND_PITCH = 0.87;
   float screen_scale;
   boolean invertXY;
   
   Dictionary<PVector, MyOffsetField> my_offset_fields ;
     
   void recalc_grid() {
     SCREEN_PITCH = new PVector(0,0); 
     SCREEN_PITCH.x = X_GROUND_PITCH * screen_scale;
     SCREEN_PITCH.y = Y_GROUND_PITCH * screen_scale;
   }

   MyPitch(float screen_scale_arg) {
     screen_scale = screen_scale_arg;
     recalc_grid();
     my_offset_fields = new Hashtable<PVector,MyOffsetField>();
   }
   
   
   void addOffsetField(int x, int y){
      MyOffsetField my_offset_field = new MyOffsetField(new PVector(x, y), (width+height)/5);
      my_offset_fields.put(new PVector(x,y), my_offset_field);
   }
   void removeOffsetField(int x, int y) {
     PVector p = new PVector(x,y);
     if (my_offset_fields.size() > 0) {
        Enumeration<PVector> keys = my_offset_fields.keys();
        PVector closest_p = keys.nextElement();
        float   closest_dist = p.dist(closest_p);
        while(keys.hasMoreElements()) {
            PVector next_p = keys.nextElement();
            float   next_dist = p.dist(next_p);
            if (next_dist < closest_dist) {
              closest_dist = next_dist;
              closest_p = next_p;
            }
        }
        
        my_offset_fields.remove(closest_p);
     }
     return;
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
      
     Enumeration<MyOffsetField> e = my_offset_fields.elements();
     while (e.hasMoreElements()){
       MyOffsetField mof = e.nextElement();
       res = mof.addOffsetAt(res);
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
    json.setBoolean("invertxy", invertXY);
    JSONArray offset_fields_json = new JSONArray();
    json.setJSONArray("my_offset_fields", offset_fields_json);
    
    Enumeration<MyOffsetField> mof_e= my_offset_fields.elements();
    int i = 0;
    while (mof_e.hasMoreElements()) {
       MyOffsetField mof = mof_e.nextElement();
       offset_fields_json.setJSONObject(i, mof.getJSON());
       i++;
     }
    
    return json;
  }
  
  MyPitch(JSONObject json) {
    if (json.getString("type").equals("MyPitch")) {
      println("load my pitch from json");
      try {
        invertXY = json.getBoolean("invertXY");
      } catch (Exception e) {
        invertXY = false;
      }
      float _screen_scale = json.getFloat("screen_scale");
      screen_scale =_screen_scale;
      recalc_grid();

      my_offset_fields = new Hashtable<PVector,MyOffsetField>();
      try {
        JSONArray offset_fields_json = json.getJSONArray("my_offset_fields");
        for (int i = 0; i < offset_fields_json.size(); i++) {
          JSONObject offset_field_json = offset_fields_json.getJSONObject(i);
          MyOffsetField mof = new MyOffsetField(offset_field_json);
          my_offset_fields.put(mof.origin, mof);
        }
      } catch (Exception e) {
        println("failed load offset fields. Probably old file " + e);
      }



    }
  }
  
}
