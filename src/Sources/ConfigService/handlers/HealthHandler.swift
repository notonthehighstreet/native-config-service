import Foundation

import KituraNet
import SwiftyJSON

import StatsD

public class HealthHandler {

  public static func handle(statsD: StatsDProtocol, complete: (_ status: HTTPStatusCode, _ data: JSON?) -> Void) -> Void {
    statsD.timer(bucket: "\(Buckets.application.rawValue).\(Buckets.healthHandler.rawValue).\(Buckets.gett.rawValue).\(Buckets.timing.rawValue)") {
      let result = HealthHandlerResponse(statusMessage: "OK it's fine")
      complete(HTTPStatusCode.OK, JSON(result.serialize()))
    }
  }

}
