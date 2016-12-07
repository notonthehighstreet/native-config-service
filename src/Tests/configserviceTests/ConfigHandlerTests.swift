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
    return JSON(["config": ["giftfinder": ["default": ["a": ["homepage": "http://myhome.com"]]]]])
  }

  public func testReturnsHTTPStatusOKWithValidParams() {
    ConfigHandler.handle(
      statsD:      mockStatsD!,
      config:      getConfig(),
      application: "giftfinder",
      branch:      "a" ) {
        (status: HTTPStatusCode, data: JSON?) in

        XCTAssertEqual(HTTPStatusCode.OK, status)
    }
  }

  public func testReturnsValidResponse() {
    ConfigHandler.handle(
      statsD:      mockStatsD!,
      config:      getConfig(),
      application: "giftfinder",
      branch:      "a" ) {
        (status: HTTPStatusCode, data: JSON?) in

        XCTAssertEqual("http://myhome.com", data!["homepage"])
    }
  }

  public func testServiceReturnsBadRequestWhenApplicationNotExistInConfig() {
    ConfigHandler.handle(
      statsD:      mockStatsD!,
      config:      getConfig(),
      application: "sounds",
      branch:      "a" ) {
        (status: HTTPStatusCode, data: JSON?) in

        XCTAssertEqual(HTTPStatusCode.badRequest, status)
        XCTAssertNil(data)
    }
  }

  public func testServiceReturnsBadRequestWhenBranchNotExistInConfig() {
    ConfigHandler.handle(
      statsD:      mockStatsD!,
      config:      getConfig(),
      application: "giftfinder",
      branch:      "ab" ) {
        (status: HTTPStatusCode, data: JSON?) in

        XCTAssertEqual(HTTPStatusCode.badRequest, status)
        XCTAssertNil(data)
    }
  }

  public func testCallsStatsDWhenOK() {
    ConfigHandler.handle(
      statsD:      mockStatsD!,
      config:      getConfig(),
      application: "giftfinder",
      branch:      "a" ) {
        (status: HTTPStatusCode, data: JSON?) in

        let bucket = Buckets.ConfigHandler.rawValue +
                     Buckets.Get.rawValue +
                     ".branch.a" + Buckets.Success.rawValue

        XCTAssertEqual(bucket, self.mockStatsD!.incrementBucket, "OK")
    }
  }

  public func testCallsStatsDWhenBranchNotPresent() {
    ConfigHandler.handle(
      statsD:      mockStatsD!,
      config:      getConfig(),
      application: "giftfinder",
      branch:      "e" ) {
        (status: HTTPStatusCode, data: JSON?) in

        let bucket = Buckets.ConfigHandler.rawValue +
                     Buckets.Get.rawValue +
                     ".branch.e" + Buckets.BadRequest.rawValue

        XCTAssertEqual(bucket, self.mockStatsD!.incrementBucket, "Incorrect bucket for timing")
    }
  }

  public func testCallsStatsDWhenApplicationNotPresent() {
    ConfigHandler.handle(
      statsD:      mockStatsD!,
      config:      getConfig(),
      application: "sounds",
      branch:      "e" ) {
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
      ("testServiceReturnsBadRequestWhenApplicationNotExistInConfig",
        testServiceReturnsBadRequestWhenApplicationNotExistInConfig),
      ("testCallsStatsDWhenOK", testCallsStatsDWhenOK),
      ("testCallsStatsDWhenBranchNotPresent", testCallsStatsDWhenBranchNotPresent),
      ("testCallsStatsDWhenApplicationNotPresent", testCallsStatsDWhenApplicationNotPresent),
    ]
  }
}
