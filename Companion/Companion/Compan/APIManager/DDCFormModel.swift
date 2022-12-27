//
//  DDCFormModel.swift
//  Compan
//
//  Created by Ambu Sangoli on 03/05/22.
//
//   let dDCFormModel = try? newJSONDecoder().decode(DDCFormModel.self, from: jsonData)

import Foundation
import SwiftUI


//Map<String, List<Map<String, String>>>
// MARK: - DDCFormModel
class DDCFormModel: Codable {
    let template: Template?
    let valueSet: Dictionary<String,[Dictionary<String, String>]>?//[ValueSet]?
    let isCreated: Bool?
    let id: String?
    let version: Int?
    var valueSetSortedArray: [Dictionary<String,[Dictionary<String, String>]>.Element]? = []

    enum CodingKeys: String, CodingKey {
        case template
        case valueSet = "value_set"
        case isCreated = "is_created"
        case id, version
    }

    init(template: Template?, valueSet: Dictionary<String,[Dictionary<String, String>]>?, isCreated: Bool?, id: String?, version: Int?) {
        self.template = template
        self.valueSet = valueSet
        self.isCreated = isCreated
        self.id = id
        self.version = version
    }
    
    required init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
        self.template = try? container.decodeIfPresent(Template.self, forKey: .template)
        self.valueSet = try? container.decodeIfPresent(Dictionary<String,[Dictionary<String, String>]>.self, forKey: .valueSet)
        self.isCreated = try? container.decodeIfPresent(Bool.self, forKey: .isCreated)
        self.id = try? container.decodeIfPresent(String.self, forKey: .id)
        self.version = try? container.decodeIfPresent(Int.self, forKey: .version)

        self.valueSetSortedArray = valueSet?.sorted{ $0.key  < $1.key }

       }
}

// MARK: - Template
class Template: Codable {
    let instanceID: String?
    var entities: Dictionary<String,Entity>?
    let active: Bool?
    let title: String?
    let uri: String?
    var uniqueId: String = ""
    var sortedArray : [Dictionary<String, Entity>.Element]? = []


    enum CodingKeys: String, CodingKey {
        case instanceID = "instance_id"
        case entities, active, title, uri
    }

    init(instanceID: String?, entities: Dictionary<String,Entity>?, active: Bool?, title: String?, uri: String?,isRepeated: Bool?,uniqueId: String, sortedArray: [Dictionary<String, Entity>.Element]?) {
        self.instanceID = instanceID
        self.entities = entities
        self.active = active
        self.title = title
        self.uri = uri
        self.uniqueId = uniqueId
        self.sortedArray = entities?.sorted{ $0.value.order ?? 0 < $1.value.order ?? 0}
        for item in self.sortedArray ?? [] {
            item.value.uri = item.key
        }
    }
    
    required init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
        self.instanceID = try? container.decodeIfPresent(String.self, forKey: .instanceID)//try container.decode(String.self, forKey: .instanceID)
        self.entities = try container.decode(Dictionary<String,Entity>?.self, forKey: .entities)
        self.active = try container.decode(Bool.self, forKey: .active)
        self.title = try container.decode(String.self, forKey: .title)
        self.uri = try container.decode(String.self, forKey: .uri)
        self.sortedArray = entities?.sorted{ $0.value.order ?? 0 < $1.value.order ?? 0}
        for item in self.sortedArray ?? [] {
            item.value.uri = item.key
        }
       }
    
}

// MARK: - Entity
class Entity: Codable {
    let type: TypeEnum?
    let title: String?
    let active: Bool?
    let order: Int?
    let guiControlType, id: String?// value, oldValue: String?
    var value: AnyCodable?
    var oldValue: AnyCodable?
    let lastUpdatedBy: String?
    let lastUpdatedDate: Int?
    var uri: String?
    let valueSetRef: String?
    let settings: Settings?
    var entityGroups: [Dictionary<String, EntityRepeatableGroup>]?
    var isRepeated : Bool?
    var sortedEntityGroupsArray : [Dictionary<String, EntityRepeatableGroup>.Element]? = []
    let isVisible : String?
    let calculation: String?
    var isHidden : Bool = false
    var required : Bool? = false
    var errorMessage : String?
    var onValue : String?
    var attributedTitleHeight : CGFloat = 0
    var invokation : Bool = false
    
    enum CodingKeys: String, CodingKey {
    
        case entityGroups = "entity_groups"
        case type, title, active, order, guiControlType, id, value, oldValue, lastUpdatedBy, lastUpdatedDate, uri, valueSetRef, settings, isVisible
        case calculation
        case required, errorMessage, onValue
    }

    init(type: TypeEnum?, title: String?, active: Bool?, order: Int?, guiControlType: String?, id: String?, value: AnyCodable?, oldValue: AnyCodable?, lastUpdatedBy: String?, lastUpdatedDate: Int?, uri: String?, valueSetRef: String?, settings: Settings?,entityGroups: [Dictionary<String, EntityRepeatableGroup>]? ,isRepeated: Bool?,isVisible: String?,calculation: String?, required: Bool?,errorMessage: String?, onValue: String?
    ) {
        self.type = type
        self.title = title
        self.active = active
        self.order = order
        self.guiControlType = guiControlType
        self.id = id
        self.value = value
        self.oldValue = oldValue
        self.lastUpdatedBy = lastUpdatedBy
        self.lastUpdatedDate = lastUpdatedDate
        self.uri = uri
        self.valueSetRef = valueSetRef
        self.settings = settings
        self.entityGroups = entityGroups
        self.isRepeated = isRepeated
        self.isVisible = isVisible
        self.calculation = calculation
        self.required = required
        self.errorMessage = errorMessage

        for object in self.entityGroups ?? [] {
            for item in object {
                self.sortedEntityGroupsArray?.append(item)
            }
        }
        
        for item in self.sortedEntityGroupsArray ?? [] {
            item.value.uri = item.key
        }
        
        self.sortedEntityGroupsArray = sortedEntityGroupsArray?.sorted{ $0.value.order ?? 0 < $1.value.order ?? 0}
        self.onValue = onValue

    }
    
    required init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try? container.decodeIfPresent(TypeEnum.self, forKey: .type)
        self.title = try? container.decodeIfPresent(String.self, forKey: .title)
        self.active = try? container.decodeIfPresent(Bool.self, forKey: .active)
        self.order = try? container.decodeIfPresent(Int.self, forKey: .order)
        self.guiControlType = try? container.decodeIfPresent(String.self, forKey: .guiControlType)
        self.id = try? container.decodeIfPresent(String.self, forKey: .id)
        
        self.value = try? container.decodeIfPresent(AnyCodable.self, forKey: .value)
        self.oldValue = try? container.decodeIfPresent(AnyCodable.self, forKey: .oldValue)


        self.lastUpdatedBy = try? container.decodeIfPresent(String.self, forKey: .lastUpdatedBy)
        self.lastUpdatedDate = try? container.decodeIfPresent(Int.self, forKey: .lastUpdatedDate)
        self.uri = try? container.decodeIfPresent(String.self, forKey: .uri)
        self.valueSetRef = try? container.decodeIfPresent(String.self, forKey: .valueSetRef)
        self.settings =  try? container.decodeIfPresent(Settings.self, forKey: .settings)
        self.entityGroups = try? container.decodeIfPresent([Dictionary<String, EntityRepeatableGroup>].self, forKey: .entityGroups)
        self.isVisible = try? container.decodeIfPresent(String.self, forKey: .isVisible)
        self.calculation = try? container.decodeIfPresent(String.self, forKey: .calculation)
        for object in self.entityGroups ?? [] {
            for item in object {
                self.sortedEntityGroupsArray?.append(item)
            }
        }
        
        for item in self.sortedEntityGroupsArray ?? [] {
            item.value.uri = item.key
        }
        
        self.sortedEntityGroupsArray = sortedEntityGroupsArray?.sorted{ $0.value.order ?? 0 < $1.value.order ?? 0}
        let isRequired = try? container.decodeIfPresent(Bool.self, forKey: .required)
        self.required = isRequired ?? false
        self.errorMessage = try? container.decodeIfPresent(String.self, forKey: .errorMessage)
        self.onValue = try? container.decodeIfPresent(String.self, forKey: .onValue)
        let height = Utilities.getLableHeightRuntime(attributedText: self.title?.htmlToAttributedString)
        self.attributedTitleHeight = height
    }
    
    
    
}

// MARK: - EntityRepeatableGroup
class EntityRepeatableGroup: Codable {
    let type: TypeEnum?
    let title: String?
    let active: Bool?
    let order: Int?
    let guiControlType, id, value, oldValue: String?
    let lastUpdatedBy: String?
    let lastUpdatedDate: Int?
    var uri: String?
    let valueSetRef: String?
    let settings: Settings?
    var entityGroups: [Dictionary<String, EntityRepeatableGroup>]?
    var sortedEntityGroupsArray : [Dictionary<String, EntityRepeatableGroup>.Element]? = []
    var isRepeated : Bool?
    var entities: Dictionary<String,Entity>?
    var sortedEntitiesArray : [Dictionary<String, Entity>.Element]? = []
    var uniqueId: String = ""


    
    enum CodingKeys: String, CodingKey {
    
        case entityGroups = "entity_groups"
        case type, title, active, order, guiControlType, id, value, oldValue, lastUpdatedBy, lastUpdatedDate, uri, valueSetRef, settings
        case entities
    }

    init(type: TypeEnum?, title: String?, active: Bool?, order: Int?, guiControlType: String?, id: String?, value: String?, oldValue: String?, lastUpdatedBy: String?, lastUpdatedDate: Int?, uri: String?, valueSetRef: String?, settings: Settings?,entityGroups: [Dictionary<String, EntityRepeatableGroup>]? ,isRepeated: Bool?,entities: Dictionary<String,Entity>?,sortedEntityGroupsArray: [Dictionary<String, EntityRepeatableGroup>.Element]?, sortedEntitiesArray : [Dictionary<String, Entity>.Element]?, uniqueId: String? ) {
        self.type = type
        self.title = title
        self.active = active
        self.order = order
        self.guiControlType = guiControlType
        self.id = id
        self.value = value
        self.oldValue = oldValue
        self.lastUpdatedBy = lastUpdatedBy
        self.lastUpdatedDate = lastUpdatedDate
        self.uri = uri
        self.valueSetRef = valueSetRef
        self.settings = settings
        self.entityGroups = entityGroups
        self.isRepeated = isRepeated
        self.entities = entities
        
        for object in self.entityGroups ?? [] {
            for item in object {
                self.sortedEntityGroupsArray?.append(item)
            }
        }
        for item in self.sortedEntityGroupsArray ?? [] {
            item.value.uri = item.key
        }
        
        self.sortedEntitiesArray = self.entities?.sorted{ $0.value.order ?? 0 < $1.value.order ?? 0}
        for item in self.sortedEntitiesArray ?? [] {
            item.value.uri = item.key
        }
       
    }
    
    required init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try? container.decodeIfPresent(TypeEnum.self, forKey: .type)
        self.title = try? container.decodeIfPresent(String.self, forKey: .title)
        self.active = try? container.decodeIfPresent(Bool.self, forKey: .active)
        self.order = try? container.decodeIfPresent(Int.self, forKey: .order)
        self.guiControlType = try? container.decodeIfPresent(String.self, forKey: .guiControlType)
        self.id = try? container.decodeIfPresent(String.self, forKey: .id)
        self.value = try? container.decodeIfPresent(String.self, forKey: .value)
        self.oldValue = try? container.decodeIfPresent(String.self, forKey: .oldValue)
        self.lastUpdatedBy = try? container.decodeIfPresent(String.self, forKey: .lastUpdatedBy)
        self.lastUpdatedDate = try? container.decodeIfPresent(Int.self, forKey: .lastUpdatedDate)
        self.uri = try? container.decodeIfPresent(String.self, forKey: .uri)
        self.valueSetRef = try? container.decodeIfPresent(String.self, forKey: .valueSetRef)
        self.settings =  try? container.decodeIfPresent(Settings.self, forKey: .settings)
        self.entityGroups = try? container.decodeIfPresent([Dictionary<String, EntityRepeatableGroup>].self, forKey: .entityGroups)
        self.entities = try? container.decode(Dictionary<String,Entity>?.self, forKey: .entities)
        for object in self.entityGroups ?? [] {
            for item in object {
                self.sortedEntityGroupsArray?.append(item)
            }
        }
        for item in self.sortedEntityGroupsArray ?? [] {
            item.value.uri = item.key
        }
        
        self.sortedEntitiesArray = self.entities?.sorted{ $0.value.order ?? 0 < $1.value.order ?? 0}
        for item in self.sortedEntitiesArray ?? [] {
            item.value.uri = item.key
        }
       }
    }


// MARK: - Settings
class Settings: Codable {
    let timeFormat, dateFormat: String?
    let min, max, precision: Int?
    let step: Double?
    let placeholderText, url: String?
    let suffix: Suffix?


    enum CodingKeys: String, CodingKey {
        case timeFormat = "time-format"
        case dateFormat = "date-format"
        case min, max, precision
        case step
        case placeholderText, url
        case suffix
    }

    init(timeFormat: String?, dateFormat: String?, min: Int?, max: Int?, step: Double?, placeholderText: String?, url: String?,suffix: Suffix?, precision: Int?) {
        self.timeFormat = timeFormat
        self.dateFormat = dateFormat
        self.min = min
        self.max = max
        self.step = step
        self.placeholderText = placeholderText
        self.url = url
        self.suffix = suffix
        self.precision = precision
    }
}

// MARK: - Suffix
class Suffix: Codable {
    var text: String?
    
    enum CodingKeys: String, CodingKey {
        case text
    }

    init(text: String?) {
        self.text = text
    }
}


enum TypeEnum: String, Codable {
    case enumerationEntity = "EnumerationEntity"
    case messageEntity = "MessageEntity"
    case textEntryEntity = "TextEntryEntity"
    case entityGroupRepeatable = "EntityGroupRepeatable"
    case entityGroup = "EntityGroup"
    case calculatedEntity = "CalculatedEntity"
}

// MARK: - ValueSet
class ValueSet: Codable {
    let refID: String?
    let valueSetData: [ValueSetDatum]?

    enum CodingKeys: String, CodingKey {
        case refID = "refId"
        case valueSetData
    }

    init(refID: String?, valueSetData: [ValueSetDatum]?) {
        self.refID = refID
        self.valueSetData = valueSetData
    }
}

// MARK: - ValueSetDatum
class ValueSetDatum: Codable {
    let key, value: String?

    init(key: String?, value: String?) {
        self.key = key
        self.value = value
    }
}
