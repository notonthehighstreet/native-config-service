import Foundation
import XCTest
import SwiftyJSON
import KituraNet

@testable import ConfigService
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
    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), abBranch: "a" ) {
      (status: HTTPStatusCode, data: JSON?) in
        XCTAssertEqual(HTTPStatusCode.OK, status)
    }
  }

  public func testReturnsValidResponse() {
    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), abBranch: "a" ) {
      (status: HTTPStatusCode, data: JSON?) in
        XCTAssertEqual("boobs", data!["balls"])
    }
  }

  public func testServiceReturnsBadRequestWhenBranchNotExistInConfig() {
    ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), abBranch: "ab" ) {
      (status: HTTPStatusCode, data: JSON?) in
        XCTAssertEqual(HTTPStatusCode.badRequest, status)
        XCTAssertNil(data)
    }
  }
  //
  // public func testCallsStatsDWhenOK() {
  //   ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), abBranch: "a" ) {
  //       (status: HTTPStatusCode, data: JSON?) in
  //     XCTAssertEqual(
  //       "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Called.rawValue).\(Buckets.Success.rawValue).Branch.a",
  //         self.mockStatsD!.incrementBucket,
  //         "OK")
  //   }
  // }
  //
  // public func testCallsStatsDWhenABBranchNotPresent() {
  //   ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), abBranch: "e" ) {
  //     (status: HTTPStatusCode, data: JSON?) in
  //     XCTAssertEqual(
  //         "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Called.rawValue).\(Buckets.BadRequest.rawValue)",
  //         self.mockStatsD!.incrementBucket,
  //         "Incorrect bucket for timing")
  //   }
  // }
  //
  // public func testCallsStatsDWithBranch() {
  //   ConfigHandler.handle(statsD: mockStatsD!, config: getConfig(), abBranch: "a" ) {
  //     (status: HTTPStatusCode, data: JSON?) in
  //     XCTAssertEqual(
  //         "\(Buckets.Application.rawValue).\(Buckets.ConfigHandler.rawValue).\(Buckets.Get.rawValue).\(Buckets.Called.rawValue).\(Buckets.Success.rawValue).Branch.a",
  //         self.mockStatsD!.incrementBucket,
  //         "OK")
  //   }
  // }
}

extension ConfigHandlerTests {
  static var allTests: [(String, (ConfigHandlerTests) -> () throws -> Void)] {
    return [
      ("testReturnsHTTPStatusOKWithValidParams", testReturnsHTTPStatusOKWithValidParams),
      ("testReturnsValidResponse", testReturnsValidResponse),
      ("testServiceReturnsBadRequestWhenBranchNotExistInConfig", testServiceReturnsBadRequestWhenBranchNotExistInConfig)
      // ("testCallsStatsDWhenOK", testCallsStatsDWhenOK),
      // ("testCallsStatsDWhenABBranchNotPresent", testCallsStatsDWhenABBranchNotPresent),
      // ("testCallsStatsDWithBranch", testCallsStatsDWithBranch)
    ]
  }
}
