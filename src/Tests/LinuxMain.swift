import XCTest
import StatsD

@testable import configserviceTests

XCTMain([
  testCase(HealthHandlerResponseTests.allTests),
  testCase(HealthHandlerTests.allTests),
  testCase(ConfigHandlerTests.allTests),
  testCase(ValidationMiddlewareTests.allTests),
  testCase(ConfigLoaderTests.allTests)
  ]
)
