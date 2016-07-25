import Kitura
import KituraNet

import StatsD
import LoggerAPI
import SwiftyJSON
import configservice

class Routing {

  let statsD: StatsDProtocol
  let config: JSON

  init(statsD: StatsDProtocol, config: JSON) {
    self.statsD = statsD
    self.config = config
  }

  func setupRouter() -> Router {
    let router = Router()

    setupHealthRoutes(router: router, path: "/v1/health")
    setupConfigRoute(router:router, path: "/v1/config/:abBranch")

    return router
  }

  private func setupConfigRoute(router: Router, path: String) {
    router.get(path) {
      request, response, next in

        ConfigHandler.handle(statsD: self.statsD, config: self.config, params: request.parameters) {
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
