import Foundation

public enum Buckets: String {
  case Started = "configservice.started"
  case HealthHandler = "configservice.health"
  case ConfigHandler = "configservice.config"
  case ValidationHandler = "configservice.validation"
  case Get = ".get"
  case Timing = ".timing", Called = ".called"
  case Success = ".success", Failed = ".failed", NotFound = ".notfound", BadRequest = ".badrequest",
    NotAuthorised = ".notauthorised", Error = ".error"
}
