import Foundation
import XCTest

@testable import configservice


public final class ConfigLoaderTests: XCTestCase {

  
  public func testReturnsNilWithNoArgs() {
    let data = ConfigLoader.load(commandLineArgs: [])
    XCTAssertTrue(data == nil,
                  "If no arguments are passed in, the load method should return nil.")
  }
  
  public func testReturnsNilWithOnlyOneArgument() {
    let data = ConfigLoader.load(commandLineArgs: ["oneArgument"])
    XCTAssertTrue(data == nil,
                  "If only one argument is passed in, the load method should return nil.")
  }
  
  public func testReturnsNilWithInvalidSecondArgument() {
    let data = ConfigLoader.load(commandLineArgs: ["oneArgument", "invalidSecondOne"])
    XCTAssertTrue(data == nil,
                  "If second argument is not a valid path to JSON file, the load method should return nil.")
  }
  
  
  //TODO: Implement this test when the Swift Bundle class implements the required init method on Linux
  // currently it is: "public init(for aClass: AnyClass) { NSUnimplemented() }"
  
  /*public func testReturnsDataWithValidSecondArgument() {
    
    let bundle = Bundle(for: type(of: self))
    
    guard let configurationFilePath = bundle.path(forResource: "config", ofType: "json") else {
      fatalError("config.json file not found in test bundle.")
    }
    
    let data = ConfigLoader.load(commandLineArgs: ["oneArgument", configurationFilePath])
    XCTAssertTrue(data != nil,
                  "If valid path string to valid JSON is passed in as second arg, the load method should return data.")
  }*/
  
  public func testPathNilWithMissingSecondArg() {
    let data = ConfigLoader.configFilePath(commandLineArgs: ["oneArgument"])
    XCTAssertTrue(data == nil,
                  "If only one argument is passed in, the configFilePath method should return nil.")
  }
  
  public func testReturnsURLWithAnySecondArgument() {
    let data = ConfigLoader.configFilePath(commandLineArgs: ["oneArgument", ""])
    XCTAssertTrue(data != nil,
                  "If second argument is a string, the configFilePath method should return a URL object.")
  }
  
  public func testLoadDataReturnsNilWithEmptyData() {
    let data = Data(capacity: 0)
    let jsonData = ConfigLoader.load(data: data)
    XCTAssertTrue(jsonData == nil,
                  "If data is empty the load data method should return nil.")
  }
  
  public func testLoadDataReturnsNilWithGarbageData() {
    let str = "se687364£¡"
    let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    
    let jsonData = ConfigLoader.load(data: data)
    XCTAssertTrue(jsonData == nil,
                  "If data is garbadge the load data method should return nil.")
  }
  
  public func testLoadDataReturnsNilWithInvalidData() {
    let str = "{}"
    let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    
    let jsonData = ConfigLoader.load(data: data)
    XCTAssertTrue(jsonData == nil,
                  "If data is not valid the load data method should return nil.")
  }
  
  public func testLoadDataReturnsJSONWithValidData() {
    let str = "{\"doodoo\": [\"aromatic\", \"pungent\"]}"
    let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    
    let jsonData = ConfigLoader.load(data: data)
    XCTAssertTrue(jsonData != nil,
                  "If data is valid the load data method should return an object.")
  }
  
  //TODO: Do we want the configLoader to define what valid data is beyond it having at least one JSON object
  // We could check for the statsD object to be present. Do we want to inject that rule?

}

extension ConfigLoaderTests {
  static var allTests: [(String, (ConfigLoaderTests) -> () throws -> Void)] {
    return [
      ("testReturnsNilWithNoArgs",                testReturnsNilWithNoArgs),
      ("testReturnsNilWithOnlyOneArgument",       testReturnsNilWithOnlyOneArgument),
      ("testReturnsNilWithInvalidSecondArgument", testReturnsNilWithInvalidSecondArgument),
//      ("testReturnsDataWithValidSecondArgument",  testReturnsDataWithValidSecondArgument),
      ("testPathNilWithMissingSecondArg",         testPathNilWithMissingSecondArg),
      ("testReturnsURLWithAnySecondArgument",     testReturnsURLWithAnySecondArgument),
      ("testLoadDataReturnsNilWithEmptyData",     testLoadDataReturnsNilWithEmptyData),
      ("testLoadDataReturnsNilWithGarbageData",   testLoadDataReturnsNilWithGarbageData),
      ("testLoadDataReturnsNilWithInvalidData",   testLoadDataReturnsNilWithInvalidData),
      ("testLoadDataReturnsJSONWithValidData",    testLoadDataReturnsJSONWithValidData),
    ]
  }
}
