import Foundation
import LoggerAPI
import KituraNet
import SwiftyJSON

import StatsD

public final class ConfigHandler {

  static let timerTag = Buckets.ConfigHandler.rawValue +
                        Buckets.Get.rawValue +
                        Buckets.Timing.rawValue

  static let handlerTag = Buckets.ConfigHandler.rawValue +
                          Buckets.Get.rawValue

  public static func handle(statsD: StatsDProtocol,
                            config: JSON,
                            application: String,
                            branch: String,
                            device: String? = "default",
                            complete: ((_: HTTPStatusCode, _: JSON?) -> Void) ) {
    
    let deviceOrDefault = device ?? "default"
    
    statsD.timer(bucket: timerTag) {
      guard let branchJSON = getBranch(config,
                                       application: application,
                                       device:      deviceOrDefault,
                                       branch:      branch)
      else {
        Log.error("Invalid request - branch not found")
        statsD.increment(bucket: tagForBadRequest(branch))
        complete(HTTPStatusCode.badRequest, nil)
        return
      }
      
      statsD.increment(bucket: tagForBranch(branch))
      complete(HTTPStatusCode.OK, branchJSON)
    }
  }

  private static func tagForBranch(_ branch: String) -> String {
    return "\(handlerTag).branch.\(branch)\(Buckets.Success.rawValue)"
  }

  private static func tagForBadRequest(_ branch: String) -> String {
    return "\(handlerTag).branch.\(branch)\(Buckets.BadRequest.rawValue)"
  }

  private static func getBranch(_ config:    JSON,
                                application: String,
                                device:      String,
                                branch:      String) -> JSON? {
    
    let branch = config["config"][application][device][branch]
    
    guard branch != JSON.null else { return nil }

    return branch
  }
}
