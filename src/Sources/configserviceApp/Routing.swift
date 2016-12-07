import Kitura
import KituraNet

import StatsD
import LoggerAPI
import SwiftyJSON
import configservice

class Routing {

  let statsD: StatsDProtocol
  let config: JSON
  let validationMiddleware: ValidationMiddleware

  init(statsD: StatsDProtocol, config: JSON) {
    self.statsD = statsD
    self.config = config
    validationMiddleware = ValidationMiddleware(statsD: statsD, minLength: 1, maxLength: 24)
  }

  func setupRouter() -> Router {
    let router = Router()

    setupHealthRoutes(router:router, path: "/v1/health")
    setupConfigRoute(router:router, path: "/v1/config/:application/:branch")
    setupConfigRoute(router:router, path: "/v1/config/:application/:branch/:device")

    return router
  }

  private func setupConfigRoute(router: Router, path: String) {
    router.get(path, middleware: RouterMiddlewareGenerator() {
      (request, response, next) in

        self.validationMiddleware.handle(parameters: request.parameters) {
          if $0 {
            next()
          }
        }
    })

    router.get(path) {
      (request, response, next) in
        let params = request.parameters

        ConfigHandler.handle(
          statsD:      self.statsD,
          config:      self.config,
          application: params["application"]!,
          branch:      params["branch"]!,
          device:      params["device"]) {
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
      (request, response, next) in

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
