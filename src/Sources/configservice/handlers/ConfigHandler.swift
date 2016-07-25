import Foundation
import LoggerAPI
import KituraNet
import SwiftyJSON

import StatsD

public class ConfigHandler {

  public static func handle(statsD: StatsDProtocol, config: JSON, abBranch: String, complete: (status: HTTPStatusCode, data: JSON?) -> Void) -> Void {
    statsD.timer(bucket: "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Timing.rawValue)") {
        if config["ios"][abBranch] != nil {
          statsD.increment(bucket: "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Called.rawValue).\(Buckets.Success.rawValue).Branch.\(abBranch)")
          complete(status: HTTPStatusCode.OK, data: config["ios"][abBranch])
        } else {
          Log.error("Invalid request")
          statsD.increment(bucket: "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Called.rawValue).\(Buckets.BadRequest.rawValue)")
          complete(status: HTTPStatusCode.badRequest, data: nil)
        }
    }
  }
}
