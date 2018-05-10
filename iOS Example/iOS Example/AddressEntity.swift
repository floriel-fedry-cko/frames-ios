//import Foundation
//import CoreData
//
//public var AddressEntity: NSManagedObjectModel {
//    let model = NSManagedObjectModel()
//    // Create the entity
//    let entity = NSEntityDescription()
//    
//}
//
//internal var _model: NSManagedObjectModel {
//    let model = NSManagedObjectModel()
//    
//    // Create the entity
//    let entity = NSEntityDescription()
//    entity.name = "DTCachedFile"
//    // Assume that there is a correct
//    // `CachedFile` managed object class.
//    entity.managedObjectClassName = String(CachedFile)
//    
//    // Create the attributes
//    var properties = Array<NSAttributeDescription>()
//    
//    let remoteURLAttribute = NSAttributeDescription()
//    remoteURLAttribute.name = "remoteURL"
//    remoteURLAttribute.attributeType = .stringAttributeType
//    remoteURLAttribute.isOptional = false
//    remoteURLAttribute.isIndexed = true
//    properties.append(remoteURLAttribute)
//    
//    let fileDataAttribute = NSAttributeDescription()
//    fileDataAttribute.name = "fileData"
//    fileDataAttribute.attributeType = .BinaryDataAttributeType
//    fileDataAttribute.optional = false
//    fileDataAttribute.allowsExternalBinaryDataStorage = true
//    properties.append(fileDataAttribute)
//    
//    let lastAccessDateAttribute = NSAttributeDescription()
//    lastAccessDateAttribute.name = "lastAccessDate"
//    lastAccessDateAttribute.attributeType = .DateAttributeType
//    lastAccessDateAttribute.optional = false
//    properties.append(lastAccessDateAttribute)
//    
//    let expirationDateAttribute = NSAttributeDescription()
//    expirationDateAttribute.name = "expirationDate"
//    expirationDateAttribute.attributeType = .DateAttributeType
//    expirationDateAttribute.optional = false
//    properties.append(expirationDateAttribute)
//    
//    let contentTypeAttribute = NSAttributeDescription()
//    contentTypeAttribute.name = "contentType"
//    contentTypeAttribute.attributeType = .StringAttributeType
//    contentTypeAttribute.optional = true
//    properties.append(contentTypeAttribute)
//    
//    let fileSizeAttribute = NSAttributeDescription()
//    fileSizeAttribute.name = "fileSize"
//    fileSizeAttribute.attributeType = .Integer32AttributeType
//    fileSizeAttribute.optional = false
//    properties.append(fileSizeAttribute)
//    
//    let entityTagIdentifierAttribute = NSAttributeDescription()
//    entityTagIdentifierAttribute.name = "entityTagIdentifier"
//    entityTagIdentifierAttribute.attributeType = .StringAttributeType
//    entityTagIdentifierAttribute.optional = true
//    properties.append(entityTagIdentifierAttribute)
//    
//    // Add attributes to entity
//    entity.properties = properties
//    
//    // Add entity to model
//    model.entities = [entity]
//    
//    // Done :]
//    return model
//}
