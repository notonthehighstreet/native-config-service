import XCTest
import StatsD

@testable import configserviceTestSuite

XCTMain([
  testCase(HealthHandlerResponseTests.allTests),
  testCase(HealthHandlerTests.allTests)
  ]
)
