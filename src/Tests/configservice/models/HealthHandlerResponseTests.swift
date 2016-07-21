import Foundation
import XCTest

import SwiftyJSON

@testable import configservice

public class HealthHandlerResponseTests: XCTestCase {
  public func testSerializesObject() {
    let h = HealthHandlerResponse(statusMessage: "MyMessage")
    let json = h.serialize()

    XCTAssertEqual("MyMessage", json["status_message"] as? String)
  }
}

extension HealthHandlerResponseTests {
  static var allTests: [(String, (HealthHandlerResponseTests) -> () throws -> Void)] {
    return [
      ("testSerializesObject", testSerializesObject)
    ]
  }
}
