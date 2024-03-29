float A6_PORTRAIT_WIDTH =  105.;
float A6_PORTRAIT_HEIGHT = 148.;
float A4_PORTRAIT_WIDTH =  210.;
float A4_PORTRAIT_HEIGHT = 297.;
float A3_PORTRAIT_WIDTH =  297.;
float A3_PORTRAIT_HEIGHT = 420.;
float PADDING_FRAC       = 0.05;

abstract class  MyExporter{



  abstract void finalize() ;


  abstract void start_layer(String c) ;
  abstract void end_layer();

  abstract void start_path(String c, int strokewidth, PVector point_arg, int hor_rep, int ver_rep);

  abstract void add_path(PVector point_arg, int hor_rep, int ver_rep);

  abstract void end_path();

  abstract void save(String path_str) ;
  
}
  
