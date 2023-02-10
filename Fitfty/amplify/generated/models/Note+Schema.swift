// swiftlint:disable all
import Amplify
import Foundation

extension Note {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case content
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let note = Note.keys
    
    model.pluralName = "Notes"
    
    model.attributes(
      .primaryKey(fields: [note.id])
    )
    
    model.fields(
      .field(note.id, is: .required, ofType: .string),
      .field(note.content, is: .required, ofType: .string),
      .field(note.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(note.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Note: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}