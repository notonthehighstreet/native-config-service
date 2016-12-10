import Foundation
import SwiftyJSON
import LoggerAPI

public struct ConfigLoader {
  
  public static func load(commandLineArgs args: [String]) -> JSON? {
    guard let url = configFilePath(commandLineArgs: args) else { return nil }
    
    do
    {
      let jsonData = try Data(contentsOf: url, options: .uncached)
      return load(data: jsonData)
    } catch {
      Log.error("Loading config data exception.")
      return nil
    }
  }
  
  internal static func configFilePath(commandLineArgs args: [String]) ->URL? {
    guard let path = args[safe:1] else {
      Log.error("Please specify config file as a command line argument.")
      return nil
    }
    
    Log.info("Config path: \(path)")
    return URL(fileURLWithPath: path)
  }
  
  internal static func load(data jsonData: Data) -> JSON? {
    
    let config = JSON(data: jsonData)
    Log.info("Loaded config: \(config)")
    
    guard config.count > 0 else {
      Log.error("Loaded config is empty.")
      return nil
    }
    
    return config
  }
}

extension Collection where Indices.Iterator.Element == Index {
  subscript (safe index: Index) -> Generator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
