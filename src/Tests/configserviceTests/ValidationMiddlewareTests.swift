import Foundation
import XCTest
import SwiftyJSON
import KituraNet

@testable import configservice
@testable import StatsD

public class ValidationMiddlewareTests: XCTestCase {
  var mockStatsD: MockStatsD?

  public override func setUp() {
    mockStatsD = MockStatsD()
  }

  private func getConfig() -> JSON {
    return JSON(["config": ["giftfinder": ["default": ["a": ["balls": "boobs"]]]]])
  }

  public func testReturnsTrueWithValidParams() {
    ValidationMiddleware(statsD: mockStatsD!, minLength: 1, maxLength: 1)
      .handle(parameters: ["branch": "a"]) { success in
        XCTAssertTrue(success)
      }
  }

  public func testReturnsFalseWithInvalidParams() {
    ValidationMiddleware(statsD: mockStatsD!, minLength: 1, maxLength: 1)
      .handle(parameters: ["branch": "av"]) { success in
        XCTAssertFalse(success)
      }
  }

  public func testCallsStatsDWhenInvalid() {
    ValidationMiddleware(statsD: mockStatsD!, minLength: 1, maxLength: 1)
      .handle(parameters: ["branch": "av"]) { success in
        let bucket = Buckets.ValidationHandler.rawValue +
                     Buckets.Get.rawValue +
                     Buckets.BadRequest.rawValue

        XCTAssertEqual(bucket, self.mockStatsD!.incrementBucket, "OK")
      }
  }
}

extension ValidationMiddlewareTests {
  static var allTests: [(String, (ValidationMiddlewareTests) -> () throws -> Void)] {
    return [
      ("testReturnsTrueWithValidParams", testReturnsTrueWithValidParams),
      ("testReturnsFalseWithInvalidParams", testReturnsFalseWithInvalidParams),
      ("testCallsStatsDWhenInvalid", testCallsStatsDWhenInvalid),
    ]
  }
}
