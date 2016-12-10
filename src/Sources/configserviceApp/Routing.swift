import Kitura
import KituraNet

import StatsD
import LoggerAPI
import SwiftyJSON
import configservice

final class Routing {

  let statsD: StatsDProtocol
  let config: JSON
  let validationMiddleware: ValidationMiddleware
  
  typealias p = Parameters.Route

  init(statsD: StatsDProtocol, config: JSON) {
    self.statsD = statsD
    self.config = config
    validationMiddleware = ValidationMiddleware(statsD: statsD, minLength: 1, maxLength: 24)
  }

  func setupRouter() -> Router {
    let router = Router()
    
    let healthPath = "/\(p.v1.rawValue)/\(p.health.rawValue)"
    let branchPath = "/\(p.v1.rawValue)/\(p.config.rawValue)/:\(p.application.rawValue)/:\(p.branch.rawValue)"
    let devicePath = "/\(p.v1.rawValue)/\(p.config.rawValue)/:\(p.application.rawValue)/:\(p.branch.rawValue)/:\(p.device.rawValue)"
    
    setupHealthRoutes(router:router, path: healthPath)
    setupConfigRoute(router:router,  path: branchPath)
    setupConfigRoute(router:router,  path: devicePath)

    return router
  }

  private func setupConfigRoute(router: Router, path: String) {
    
    Routing.setupConfigRoute(router:               router,
                             path:                 path,
                             validationMiddleware: self.validationMiddleware)
    
    Routing.setupConfigRoute(router: router,
                             path:   path,
                             statsD: self.statsD,
                             config: self.config)
  }
  
  private class func setupConfigRoute(router: Router, path: String, validationMiddleware:ValidationMiddleware) {
    
    router.get(path, middleware: RouterMiddlewareGenerator() { (request, response, next) in
      
      validationMiddleware.handle(parameters: request.parameters) {
        if $0 { next() }
      }
    })
  }
  
  private class func setupConfigRoute(router: Router, path: String, statsD: StatsDProtocol, config: JSON) {
    
    router.get(path) { (request, response, next) in
      
      let params   = request.parameters
      let values   = Routing.parameterValues(params)
      let complete = Routing.complete(response: response)
      
      ConfigHandler.handle(statsD:      statsD,
                           config:      config,
                           application: values.application,
                           branch:      values.branch,
                           device:      values.device,
                           complete:    complete)
      // execute next middleware in sequence
      next()
    }
  }
  
  private class func complete(response: RouterResponse) -> ((_: HTTPStatusCode, _: JSON?) -> Void) {
    
    return { (status: HTTPStatusCode, data: JSON?) in
      
      Routing.sendResponse(response: response, status: status, data: data)
    }
  }
  
  private class func parameterValues(_ params : [String : String]) -> (application:String, branch:String, device:String?) {
    let application = params[p.application.rawValue] ?? ""
    let branch      = params[p.branch.rawValue] ?? ""
    let device      = params[p.device.rawValue]
    
    return (application, branch, device)
  }

  // setup the router with our handlers
  private func setupHealthRoutes(router: Router, path: String) {
    
    router.get(path) { (request, response, next) in

        HealthHandler.handle(statsD: self.statsD) { (status: HTTPStatusCode, data: JSON?) in

            Routing.sendResponse(response: response, status: status, data: data)
        }
        // execute next middleware in sequence
        next()
    }
  }

  private class func sendResponse(response: RouterResponse, status: HTTPStatusCode, data: JSON?) {
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
