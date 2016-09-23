import PackageDescription

let package = Package(
    name: "ConfigService",
    targets: [
      Target(
        name: "ConfigServiceApp",
        dependencies: [.Target(name: "ConfigService")]),
      Target(
        name: "ConfigService")
    ],
    dependencies: [
      .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 0, minor: 17),
      .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0, minor: 32),
      .Package(url: "https://github.com/notonthehighstreet/swift-statsd", majorVersion: 0, minor: 5)
    ])
