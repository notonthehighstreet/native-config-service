import Foundation
import LoggerAPI
import KituraNet
import SwiftyJSON

import StatsD

public class ConfigHandler {

  public static func handle(statsD: StatsDProtocol, config: JSON, device: String = "default", abBranch: String, complete: (_ status: HTTPStatusCode, _ data: JSON?) -> Void) -> Void {
    statsD.timer(bucket: "\(Buckets.application.rawValue).\(Buckets.configHandler.rawValue).\(Buckets.gett.rawValue).\(Buckets.timing.rawValue)") {
        if config["config"]["giftfinder"][device][abBranch] != nil {
          statsD.increment(bucket: "\(Buckets.application.rawValue).\(Buckets.configHandler.rawValue).\(Buckets.gett.rawValue).\(Buckets.called.rawValue).\(Buckets.success.rawValue).Branch.\(abBranch)")
          complete(HTTPStatusCode.OK, config["config"]["giftfinder"][device][abBranch])
        } else {

          Log.error("Invalid request - branch not there")
          statsD.increment(bucket: "\(Buckets.application.rawValue).\(Buckets.configHandler.rawValue).\(Buckets.gett.rawValue).\(Buckets.called.rawValue).\(Buckets.badRequest.rawValue)")
          complete(HTTPStatusCode.badRequest, nil)
        }
    }
  }
}
