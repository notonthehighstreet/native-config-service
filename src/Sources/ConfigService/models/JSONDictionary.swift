#if os(OSX)
  public typealias JSONDictionary = [String : AnyObject]
#else
  public typealias JSONDictionary = [String : Any]
#endif
