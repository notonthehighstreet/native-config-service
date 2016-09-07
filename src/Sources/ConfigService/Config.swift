import Foundation

public enum Buckets: String {
  case application = "configservice"
  case healthHandler = "health"
  case configHandler = "config"
  case gett = "get"
  case post = "post"
  case put = "put"
  case delete = "delete"
  case timing = "timing"
  case connection = "connection"
  case called = "called"
  case success = "success"
  case failed = "failed"
  case notFound = "notfound"
  case badRequest = "badrequest"
  case notAuthorised = "notauthorised"
  case started = "started"
  case error = "error"
  case created = "created"
  case disconnected = "disconnected"
  case retrieved = "retrieved"
}
