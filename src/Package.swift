import PackageDescription

let package = Package(
    name: "configservice",
    targets: [
      Target(
        name: "configserviceApp",
        dependencies: [.Target(name: "configservice")]),
      Target(
        name: "configservice")
    ],
    dependencies: [
      .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0, minor: 28),
      .Package(url: "https://github.com/IBM-Swift/HeliumLogger", majorVersion: 0, minor: 15),
      .Package(url: "https://github.com/notonthehighstreet/swift-statsd", majorVersion: 0, minor: 5)
    ])
