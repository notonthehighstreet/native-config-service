import Foundation

import KituraNet
import SwiftyJSON

import StatsD

public final class HealthHandler {

  static let timingTag = Buckets.HealthHandler.rawValue +
                         Buckets.Get.rawValue + 
                         Buckets.Timing.rawValue

  public static func handle(statsD: StatsDProtocol, 
                            complete: (_: HTTPStatusCode, _: JSON?) -> Void) -> Void {
    
    statsD.timer(bucket: timingTag) {
      
      let result = HealthHandlerResponse(statusMessage: "OK it's fine")
      complete(HTTPStatusCode.OK, JSON(result.serialize()))
    }
  }

}
