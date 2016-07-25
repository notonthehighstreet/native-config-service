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

  public func testReturnsHTTPStatusOKWithValidParams() {
    var params = [String: String]()
    params["abBranch"] = "a"

    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), params: params) {
      (status: HTTPStatusCode, data: JSON?) in
        XCTAssertEqual(HTTPStatusCode.OK, status)
    }
  }

  public func testReturnsValidResponse() {
    var params = [String: String]()
    params["abBranch"] = "a"

    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), params: params) {
      (status: HTTPStatusCode, data: JSON?) in
        XCTAssertEqual("boobs", data!["balls"])
    }
  }

  public func testParamsInvalidWithId() {
    var params = [String: String]()
    params["abBranch"] = "ab"

    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), params: params ) {
      (status: HTTPStatusCode, data: JSON?) in
        XCTAssertEqual(HTTPStatusCode.badRequest, status)
        XCTAssertNil(data)
    }
  }
}

extension ConfigHandlerTests {
  static var allTests: [(String, (ConfigHandlerTests) -> () throws -> Void)] {
    return [
      ("testReturnsHTTPStatusOKWithValidParams", testReturnsHTTPStatusOKWithValidParams),
      ("testReturnsValidResponse", testReturnsValidResponse),
      ("testParamsInvalidWithId", testParamsInvalidWithId)
    ]
  }
}
