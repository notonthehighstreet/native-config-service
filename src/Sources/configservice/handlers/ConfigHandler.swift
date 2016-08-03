import Foundation
import LoggerAPI
import KituraNet
import SwiftyJSON

import StatsD

public class ConfigHandler {

  public static func handle(statsD: StatsDProtocol, config: JSON, device: String = "default", abBranch: String, complete: (status: HTTPStatusCode, data: JSON?) -> Void) -> Void {
    statsD.timer(bucket: "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Timing.rawValue)") {
        if config["config"]["giftfinder"][device][abBranch] != nil {
          statsD.increment(bucket: "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Called.rawValue).\(Buckets.Success.rawValue).Branch.\(abBranch)")
          complete(status: HTTPStatusCode.OK, data: config["config"]["giftfinder"][device][abBranch])
        } else {
          
          Log.error("Invalid request - branch not there")
          statsD.increment(bucket: "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Called.rawValue).\(Buckets.BadRequest.rawValue)")
          complete(status: HTTPStatusCode.badRequest, data: nil)
        }
    }
  }
}
