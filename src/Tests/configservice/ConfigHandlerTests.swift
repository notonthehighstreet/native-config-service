import Foundation
import XCTest
import SwiftyJSON
import KituraNet

@testable import configservice
@testable import StatsD

public class ConfigHandlerTests: XCTestCase {
  var mockStatsD: MockStatsD?

  public override func setUp() {
    mockStatsD = MockStatsD()
  }

  private func getConfig() -> JSON {
    return JSON(["ios": ["a": ["balls": "boobs"]]])
  }

  public func testReturnsHTTPStatusOK() {
    ConfigHandler.handle(statsD: mockStatsD!, abBranch: "a", config: getConfig()) {
      (status: HTTPStatusCode, data: JSON?) in
        XCTAssertEqual(HTTPStatusCode.OK, status)
    }
  }

  public func testReturnsValidResponse() {
    ConfigHandler.handle(statsD: mockStatsD!, abBranch: "a", config: getConfig()) {
      (status: HTTPStatusCode, data: JSON?) in
        XCTAssertEqual("boobs", data!["balls"])
    }
  }
}

extension ConfigHandlerTests {
  static var allTests: [(String, (ConfigHandlerTests) -> () throws -> Void)] {
    return [
      ("testReturnsHTTPStatusOK", testReturnsHTTPStatusOK),
      ("testReturnsValidResponse", testReturnsValidResponse)
    ]
  }
}
