import Foundation
import Swift

import Kitura
//import KituraSys
import KituraNet
import HeliumLogger
import LoggerAPI
import SwiftyJSON

import StatsD
import configservice

var config: JSON? = nil
var statsD: StatsD? = nil
var router: Router? = nil

private func setupLogger() {
  Log.logger = HeliumLogger()
}

// Load the config from the json file
private func loadConfig() -> JSON? {
  var args: [String] = CommandLine.arguments

  if args.count < 2 {
    Log.error("Please specify config file")

    return nil
  }

  let url = URL(fileURLWithPath: args[1])
  do
  {
    let jsonData = try Data(contentsOf: url, options: .uncached)
    let config = JSON(data: jsonData)
    Log.info("Loaded config: \(config)")

    if config.count < 1 {
      exit(1)
    }
    return config
  } catch {
    return nil
  }
}

setupLogger()
config = loadConfig()
statsD = Metrics().setupStatsD()
router = Routing(statsD: statsD!, config: config!).setupRouter()

Log.info("Starting Server on port 8090:")
statsD!.increment(bucket: "\(Buckets.Application.rawValue).\(Buckets.Started.rawValue)")

Kitura.addHTTPServer(onPort: 8090, with: router!)
Kitura.run()
