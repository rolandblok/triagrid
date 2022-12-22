
 
 
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
    
   
