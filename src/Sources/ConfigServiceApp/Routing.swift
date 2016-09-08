import Kitura
import KituraNet

import StatsD
import LoggerAPI
import SwiftyJSON
import ConfigService

public class Routing {

  let statsD: StatsDProtocol
  let config: JSON

  public init(statsD: StatsDProtocol, config: JSON) {
    self.statsD = statsD
    self.config = config
  }

  public func setupRouter() -> Router {
    let router = Router()

    setupHealthRoutes(router: router, path: "/v1/health")
    setupConfigRoute(router:router, path: "/v1/config/:abBranch")

    return router
  }

  private func setupConfigRoute(router: Router, path: String) {
    router.get(path, middleware: ValidationMiddleware(statsD: statsD))

    router.get(path) {
      request, response, next in
        let params = request.parameters
        ConfigHandler.handle(statsD: self.statsD, config: self.config, abBranch: params["abBranch"]!) {
          (status: HTTPStatusCode, data: JSON?) in

            self.sendResponse(response: response, status: status, data: data)
        }
        // execute next middleware in sequence
        next()
    }
  }

  // setup the router with our handlers
  private func setupHealthRoutes(router: Router, path: String) {
    router.get(path) {
      request, response, next in

        HealthHandler.handle(statsD: self.statsD) {
          (status: HTTPStatusCode, data: JSON?) in

            self.sendResponse(response: response, status: status, data: data)
        }
        // execute next middleware in sequence
        next()
    }
  }

  private func sendResponse(response: RouterResponse, status: HTTPStatusCode, data: JSON?) {
    response.status(status)

    if data != nil {
      do {
        try response.send(json: data!).end()
      } catch {
        Log.error("Error sending response")
      }
    }
  }
}