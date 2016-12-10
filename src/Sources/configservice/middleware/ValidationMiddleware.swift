import Foundation
import StatsD
import Kitura
import KituraNet
import LoggerAPI

public final class ValidationMiddleware {

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

    guard validParams && branch != nil else {
      Log.error("Invalid request - did not pass validation")
      
      statsD.increment(bucket: badRequestTag)
      complete(false)
      return
    }
    
    complete(true)
  }

  private func validateParams(params: [String: String]) -> (valid: Bool, branch: String?) {
    let branchKey = Parameters.Route.branch.rawValue
    guard let branch = params[branchKey] else { return (false, nil) }
    let valid = paramValid(param: branch)
    
    return (valid, branch)
  }

  private func paramValid(param: String) -> Bool {
    return (param.characters.count >= self.minLength &&
            param.characters.count <= self.maxLength)
  }
}
