import Foundation
import StatsD
import Kitura
import KituraNet
import LoggerAPI

public class ValidationMiddleware: RouterMiddleware {

  let statsD: StatsDProtocol
  let badRequestTag = Buckets.ValidationHandler.rawValue +
                      Buckets.Get.rawValue +
                      Buckets.Called.rawValue +
                      Buckets.BadRequest.rawValue

  public init(statsD: StatsDProtocol) {
    self.statsD = statsD
  }

  public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
    let (validParams, abBranch) = validateParams(params: request.parameters)

    Log.info("\(validParams) \(abBranch)")

    if validParams && abBranch != nil {
      next()
    } else {
      do {
        Log.error("Invalid request - did not pass validation")

        statsD.increment(bucket: badRequestTag)
        response.status(HTTPStatusCode.badRequest)

        try response.end()
      } catch {
        Log.error("Error")
      }
    }
  }

  private func validateParams(params: [String: String]?) -> (valid: Bool, branch: String?) {
    
    if params != nil, let branch = params!["abBranch"] {
      let valid =  paramValid(param: branch)
      return (valid, branch)
    }

    return (false, nil)
  }

  private func paramValid(param: String) -> Bool {
    return (param.characters.count == 1)
  }
}
