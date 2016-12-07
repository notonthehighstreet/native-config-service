import Foundation
import LoggerAPI
import KituraNet
import SwiftyJSON

import StatsD

public class ConfigHandler {

  static let timerTag = Buckets.ConfigHandler.rawValue +
                        Buckets.Get.rawValue +
                        Buckets.Timing.rawValue

  static let handlerTag = Buckets.ConfigHandler.rawValue +
                         Buckets.Get.rawValue

  public static func handle(
    statsD: StatsDProtocol,
    config: JSON,
    application: String,
    branch: String,
    device: String? = "default",
    complete: (_: HTTPStatusCode, _: JSON?) -> Void) -> Void {
 
      let d = (device == nil) ? "default" : device!
      statsD.timer(bucket: timerTag) {

      if let branchJSON = getBranch(
        config,
        application: application,
        device:      d,
        branch:      branch) {

    Log.info("Fo shizzle")
        statsD.increment(bucket: tagForBranch(branch))
        complete(HTTPStatusCode.OK, branchJSON)
    Log.info("Fo shizzle")
      } else {

        Log.error("Invalid request - branch not found")
        statsD.increment(bucket: tagForBadRequest(branch))

        complete(HTTPStatusCode.badRequest, nil)
      }
    }
  }

  private static func tagForBranch(_ branch: String) -> String {
    return "\(handlerTag).branch.\(branch)\(Buckets.Success.rawValue)"
  }

  private static func tagForBadRequest(_ branch: String) -> String {
    return "\(handlerTag).branch.\(branch)\(Buckets.BadRequest.rawValue)"
  }

  private static func getBranch(
    _ config:    JSON,
    application: String,
    device:      String,
    branch:      String) -> JSON? {

    let branch = config["config"][application][device][branch]
    if branch == JSON.null {
      return nil
    }

    return branch
  }
}
