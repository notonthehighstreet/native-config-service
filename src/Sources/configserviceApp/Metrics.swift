import StatsD
import LoggerAPI
import Socket

class Metrics {

  func setupStatsD() -> StatsD {
    let host = config!["statsd", "host"].stringValue
    let port = config!["statsd", "port"].intValue

    let socket = UDPSocket()
    return StatsD(
      host: host,
      port: port,
      socket: socket,
      interval: 1.0,
       sendCallback: { (success: Bool, error: SocketError?) in
         if success {
           Log.info("Sent data to StatsD")
         } else {
           Log.error("Failed to send data to StatsD \(error)")
         }
       }
    )
  }

}
