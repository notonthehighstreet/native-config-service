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
    return JSON(["config": ["giftfinder": ["default": ["a": ["balls": "boobs"]]]]])
  }

  public func testReturnsHTTPStatusOKWithValidParams() {
    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), branch: "a" ) {
      (status: HTTPStatusCode, data: JSON?) in

        XCTAssertEqual(HTTPStatusCode.OK, status)
    }
  }

  public func testReturnsValidResponse() {
    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), branch: "a" ) {
      (status: HTTPStatusCode, data: JSON?) in

        XCTAssertEqual("boobs", data!["balls"])
    }
  }

  public func testServiceReturnsBadRequestWhenBranchNotExistInConfig() {
    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), branch: "ab" ) {
      (status: HTTPStatusCode, data: JSON?) in

        XCTAssertEqual(HTTPStatusCode.badRequest, status)
        XCTAssertNil(data)
    }
  }

  public func testCallsStatsDWhenOK() {
    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), branch: "a" ) {
        (status: HTTPStatusCode, data: JSON?) in

        let bucket = Buckets.ConfigHandler.rawValue +
                     Buckets.Get.rawValue +
                     ".branch.a" + Buckets.Success.rawValue

        XCTAssertEqual(bucket, self.mockStatsD!.incrementBucket, "OK")
    }
  }

  public func testCallsStatsDWhenABBranchNotPresent() {
    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), branch: "e" ) {
      (status: HTTPStatusCode, data: JSON?) in

        let bucket = Buckets.ConfigHandler.rawValue +
                     Buckets.Get.rawValue +
                     ".branch.e" + Buckets.BadRequest.rawValue

        XCTAssertEqual(bucket, self.mockStatsD!.incrementBucket, "Incorrect bucket for timing")
    }
  }
}

extension ConfigHandlerTests {
  static var allTests: [(String, (ConfigHandlerTests) -> () throws -> Void)] {
    return [
      ("testReturnsHTTPStatusOKWithValidParams", testReturnsHTTPStatusOKWithValidParams),
      ("testReturnsValidResponse", testReturnsValidResponse),
      ("testServiceReturnsBadRequestWhenBranchNotExistInConfig",
        testServiceReturnsBadRequestWhenBranchNotExistInConfig),
      ("testCallsStatsDWhenOK", testCallsStatsDWhenOK),
      ("testCallsStatsDWhenABBranchNotPresent", testCallsStatsDWhenABBranchNotPresent),
    ]
  }
}
