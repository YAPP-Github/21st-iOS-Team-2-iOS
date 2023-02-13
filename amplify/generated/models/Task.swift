// swiftlint:disable all
import Amplify
import Foundation

public struct Task: Model {
  public let id: String
  public var title: String
  public var description: String?
  public var status: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      title: String,
      description: String? = nil,
      status: String? = nil) {
    self.init(id: id,
      title: title,
      description: description,
      status: status,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      title: String,
      description: String? = nil,
      status: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.title = title
      self.description = description
      self.status = status
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}