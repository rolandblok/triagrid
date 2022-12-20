class MyPitch {
   public static final float X_GROUND_PITCH = 1.00; 
   public final static float Y_GROUND_PITCH = 0.87;
   float X_PITCH;
   float Y_PITCH;
   float X_OFFSET;
   
   private void setAll(float pitch_scale) {
     X_PITCH = X_GROUND_PITCH * pitch_scale;
     Y_PITCH = Y_GROUND_PITCH * pitch_scale;
     X_OFFSET = X_PITCH/2.0;
   }
   
   MyPitch(float pitch_scale) {
     setAll(pitch_scale);
   }
  
}
