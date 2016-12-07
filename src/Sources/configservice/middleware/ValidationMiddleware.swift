import Foundation
import StatsD
import Kitura
import KituraNet
import LoggerAPI

public class ValidationMiddleware {

  let statsD: StatsDProtocol
  let minLength: Int
  let maxLength: Int
  let badRequestTag = Buckets.ValidationHandler.rawValue +
                      Buckets.Get.rawValue +
                      Buckets.BadRequest.rawValue

  public init(statsD: StatsDProtocol, minLength: Int, maxLength: Int) {
    self.statsD = statsD
    self.maxLength = maxLength
    self.minLength = minLength
  }

  public func handle(parameters: [String: String], complete: ((_ success: Bool) -> Void)) {
    let (validParams, branch)  = validateParams(params: parameters)

    Log.info("\(validParams) \(branch)")

    if validParams && branch != nil {
      complete(true)
    } else {
      Log.error("Invalid request - did not pass validation")

      statsD.increment(bucket: badRequestTag)
      complete(false)
    }
  }

  private func validateParams(params: [String: String]) -> (valid: Bool, branch: String?) {
    if let branch = params["branch"] {
      let valid =  paramValid(param: branch)
      return (valid, branch)
    }

    return (false, nil)
  }

  private func paramValid(param: String) -> Bool {
    return (param.characters.count >= self.minLength &&
            param.characters.count <= self.maxLength)
  }
}
