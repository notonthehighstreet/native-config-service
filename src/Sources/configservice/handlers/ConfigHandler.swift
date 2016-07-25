import Foundation
import LoggerAPI
import KituraNet
import SwiftyJSON

import StatsD

public class ConfigHandler {

  public static func handle(statsD: StatsDProtocol, config: JSON, params: [String: String], complete: (status: HTTPStatusCode, data: JSON?) -> Void) -> Void {
    statsD.timer(bucket: "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Timing.rawValue)") {
      let (validParams, abBranch) = validateParams(params: params)

      if validParams && abBranch != nil {
        let configForUser = config["ios"][abBranch!]
        complete(status: HTTPStatusCode.OK, data: configForUser)
      } else {
        Log.error("Invalid request")
        statsD.increment(bucket: "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Post.rawValue).\(Buckets.Called.rawValue).\(Buckets.BadRequest.rawValue)")
        complete(status: HTTPStatusCode.badRequest, data: nil)
      }
    }
  }

  private static func validateParams(params: [String: String]?) -> (valid: Bool, id: String?) {
    if params != nil, let id = params!["abBranch"] {
      return (paramValid(param: id), id)
    }

    return (true, nil)
  }

  private static func paramValid(param: String) -> Bool {
    if param.characters.count == 1 {
      return true
    }

    return false
  }
}
