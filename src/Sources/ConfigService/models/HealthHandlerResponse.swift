import Foundation
import SwiftyJSON

public struct HealthHandlerResponse {
  let statusMessage:String

  public init(statusMessage:String) {
    self.statusMessage = statusMessage
  }

  public func serialize() -> JSONDictionary {
    return ["status_message": statusMessage as AnyObject]
  }
}
