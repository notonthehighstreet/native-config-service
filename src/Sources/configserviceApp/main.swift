import Foundation
import Swift

import Kitura
import KituraNet
import HeliumLogger
import LoggerAPI

import StatsD
import configservice

private func setupLogger() {
  Log.logger = HeliumLogger()
}

setupLogger()

private let args: [String] = CommandLine.arguments

guard let config = ConfigLoader.load(commandLineArgs: args) else {
  Log.error("Exit:No config file loaded from command line. Use Docker to run Consul.")
  exit(1)
}

private let statsD = Metrics.setupStatsD(config: config)
private let router = Routing(statsD: statsD, config: config).setupRouter()

Log.info("Starting Server on port 8090:")
statsD.increment(bucket: Buckets.Started.rawValue)

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
