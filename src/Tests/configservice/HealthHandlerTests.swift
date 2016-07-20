import Foundation
import XCTest
import SwiftyJSON
import KituraNet

@testable import configservice
@testable import StatsD

public class HealthHandlerTests: XCTestCase {
  var mockStatsD: MockStatsD?

  public override func setUp() {
    mockStatsD = MockStatsD()
  }

  public func testReturnsHTTPStatusOK() {
    HealthHandler.handle(statsD: mockStatsD!) {
      (status: HTTPStatusCode, data: JSON?) in
        XCTAssertEqual(HTTPStatusCode.OK, status)
    }
  }

  public func testReturnsValidResponse() {
    HealthHandler.handle(statsD: mockStatsD!) {
      (status: HTTPStatusCode, data: JSON?) in
        XCTAssertEqual("OK it's fine", data!["status_message"])
    }
  }
}

extension HealthHandlerTests {
  static var allTests: [(String, HealthHandlerTests -> () throws -> Void)] {
    return [
      ("testReturnsHTTPStatusOK", testReturnsHTTPStatusOK),
      ("testReturnsValidResponse", testReturnsValidResponse)
    ]
  }
}
