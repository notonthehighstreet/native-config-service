import XCTest
import StatsD

@testable import configserviceTestSuite

XCTMain([
  testCase(HealthHandlerResponseTests.allTests),
  testCase(HealthHandlerTests.allTests),
  testCase(ConfigHandlerTests.allTests)
  ]
)
