import Foundation

import KituraNet
import SwiftyJSON

import StatsD

public class HealthHandler {

  public static func handle(statsD: StatsDProtocol, complete: (_: HTTPStatusCode, _: JSON?) -> Void) -> Void {
    statsD.timer(bucket: "\(Buckets.Application.rawValue).\(Buckets.HealthHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Timing.rawValue)") {
      let result = HealthHandlerResponse(statusMessage: "OK it's fine")
      complete(HTTPStatusCode.OK, JSON(result.serialize()))
    }
  }

}
