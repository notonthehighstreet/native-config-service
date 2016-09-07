import Foundation

import Kitura
import KituraSys
import KituraNet
import HeliumLogger
import LoggerAPI
import SwiftyJSON

import StatsD
import ConfigService

var config: JSON? = nil
var statsD: StatsD? = nil
var router: Router? = nil

private func setupLogger() {
  Log.logger = HeliumLogger()
}

// Load the config from the json file
private func loadConfig() -> JSON? {

  if CommandLine.arguments.count < 2 {
    Log.error("Please specify config file")

    return nil
  }

  if let jsonData = NSData(contentsOfFile: CommandLine.arguments[1])
  {
    let config = JSON(data: jsonData as Data)
    Log.info("Loaded config: \(config)")

    if config.count < 1 {
      exit(1)
    }
    return config
  }

  return nil
}

setupLogger()
config = loadConfig()
statsD = Metrics().setupStatsD()
router = Routing(statsD: statsD!, config: config!).setupRouter()

Log.info("Starting Server on port 8090:")
statsD!.increment(bucket: "\(Buckets.application.rawValue).\(Buckets.started.rawValue)")

Kitura.addHTTPServer(onPort: 8090, with: router!)
Kitura.run()
