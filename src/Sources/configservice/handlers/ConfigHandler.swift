import Foundation

import KituraNet
import SwiftyJSON

import StatsD

public class ConfigHandler {

  public static func handle(statsD: StatsDProtocol, abBranch: String = "a", config: JSON, complete: (status: HTTPStatusCode, data: JSON?) -> Void) -> Void {
    statsD.timer(bucket: "\(Buckets.Application.rawValue).\(Buckets.HealthHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Timing.rawValue)") {
      let configForUser = config["ios"][abBranch]
      complete(status: HTTPStatusCode.OK, data: getConfigForUser(abBranch, configForUser))
    }
  }
}
