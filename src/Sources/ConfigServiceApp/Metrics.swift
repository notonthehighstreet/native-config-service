import Foundation
import StatsD
import LoggerAPI
import Socket

public class Metrics {

  public func setupStatsD() -> StatsD? {

    do {
      let udpSocket: Socket = try Socket.create(family: .inet, type: .datagram, proto: .udp)

      return StatsD(
        socket: udpSocket,
        interval: 1.0,
        sendCallback: { (success: Bool, error: SocketError?) in
          if success {
            Log.info("Sent data to StatsD")
          } else {
            Log.error("Failed to send data to StatsD \(error)")
          }
        }
      )
    } catch _ {
      Log.error("Error creating socket")
    }
    return nil
 }
}


// public convenience init(socket: SocketWriter, sendCallback: ((Bool, SocketError?) -> Void)? = nil)
