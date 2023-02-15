abstract class  MyExporter{



  abstract void finalize() ;


  abstract void start_layer(String c) ;
  abstract void end_layer();

  abstract void start_path(String c, int strokewidth, PVector point_arg);

  abstract void add_path(PVector point_arg);

  abstract void end_path();

  abstract void save(String path_str) ;
  
}
  
