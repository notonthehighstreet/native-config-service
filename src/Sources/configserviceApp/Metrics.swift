import StatsD
import LoggerAPI
import Socket
import SwiftyJSON

struct Metrics {

  static func setupStatsD(config: JSON) -> StatsD {
    
    let host          = config[Key.statsD, Key.host].stringValue
    let port          = config[Key.statsD, Key.port].intValue
    let socket        = UDPSocket()
    let sendCallback  = callback()
    
    return StatsD(host: host,
                  port: port,
                  socket: socket,
                  interval: 1.0,
                  sendCallback: sendCallback)
  }
  
  private static func callback() -> ((Bool, SocketError?) -> Void) {
    
    return { (success: Bool, error: SocketError?) in
      guard success else {
        Log.error("Failed to send data to StatsD \(error)")
        return
      }
      
      Log.info("Sent data to StatsD")
    }
  }
  
  private struct Key {
    static let statsD = "statsd"
    static let host   = "host"
    static let port   = "port"
  }
  
}
